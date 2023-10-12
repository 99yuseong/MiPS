//
//  AudioService.swift
//  MiPS
//
//  Created by 남유성 on 2023/09/20.
//

import Foundation
import AVFoundation

protocol AudioServiceProtocol {
    func playLocalSource(for resource: String, format: AudioExt)
    func downloadExtSource(from urlString: String)
    func playStreamingFromServer()
}

class AudioService: AudioServiceProtocol {
    
    // MARK: - Property
    static let shared = AudioService()
    
    private var audioEngine = AVAudioEngine()
    private var playerNode = AVAudioPlayerNode()
    private var soundEffect: AVAudioPlayer?
    
    // MARK: - Life Cycle
    private init() {
        prepareEngine()
    }
    
    private func prepareEngine() {
        audioEngine.attach(playerNode)
        audioEngine.connect(
            playerNode, to: audioEngine.mainMixerNode, format: nil
        )
        
        do {
            try audioEngine.start()
        } catch {
            print(#fileID, #function, #line, "⛔️ Failed to start engine: \(error)")
        }
    }
    
    
    private func scheduleBuffer(_ floatArray: [[Float]]) {
        let buffer = floatArray.toStereoBuffer()
        scheduleBuffer(buffer)
    }
    
    private func scheduleBuffer(_ buffer: AVAudioPCMBuffer) {
        playerNode.scheduleBuffer(buffer)
    }
}

// MARK: - Methods
extension AudioService {
    public func playLocalSource(for resource: String, format: AudioExt) {
        guard let url = checkLocalUrl(for: resource, format: format) else {
            print("\(resource) can not found.")
            return
        }
        
        playAudio(localUrl: url)
    }
    
    public func downloadExtSource(from urlString: String) {
        DispatchQueue.global().async { [self] in
            guard let url = checkExtUrl(for: urlString),
                  let data = requestSourceData(from: url)
            else { return }
            
            playAudio(resource: data)
        }
    }
    
    public func playStreamingFromServer() {
        setStreaming()
        playerNode.play()
    }
    
    func setStreaming() {
        NetworkService.shared.setSocketEvent(onEvent: { [self] event in
            switch event {
            case .binary(let data):
                DispatchQueue.global().async { [self] in
                    let floatArray = convertDataToArray(data)
                    scheduleBuffer(floatArray)
                }
            default:
                break
            }
        })
        
        NetworkService.shared.connectSocket()
    }
    
    func sendHeadPosition(_ position: HeadPosition) {
        let encoder = JSONEncoder()
        
        do {
            let jsonData = try encoder.encode(position)
            
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                NetworkService.shared.sendMessage(jsonString)
            }
        } catch {
           print("Error encoding object to JSON:", error.localizedDescription)
        }
    }
    
    func convertDataToArray(_ data: Data) -> [[Float]] {
        let floatCount = data.count / 8
        
        let byteSizeForOneArray = floatCount * MemoryLayout<Float>.size
        
        let left = data.subdata(in: 0..<byteSizeForOneArray)
        let right = data.subdata(in: byteSizeForOneArray..<data.count)
        
        return [left.byteToFloatArray(), right.byteToFloatArray()]
    }
}

// MARK: - Play functions
extension AudioService {
    private func playAudio(resource: Data) {
        do {
            soundEffect = try AVAudioPlayer(data: resource)
            soundEffect?.play()
        } catch {
            print("Failed to play mp3 file. error = \(error.localizedDescription)")
        }
    }
    
    private func playAudio(localUrl: URL) {
        do {
            soundEffect = try AVAudioPlayer(contentsOf: localUrl)
            soundEffect?.play()
        } catch {
            print("Failed to play mp3 file. error = \(error.localizedDescription)")
        }
    }
}

// MARK: - URL Check and Data Networking
extension AudioService {
    private func checkLocalUrl(for resource: String, format: AudioExt) -> URL? {
        
        return Bundle.main.url(
            forResource: resource,
            withExtension: format.description
        )
    }
    
    private func checkExtUrl(for urlString: String) -> URL? {
        guard let urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: urlString)
        else {
            print("\(urlString) is invalid URL")
            return nil
        }
        
        return url
    }
    
    private func requestSourceData(from url: URL) -> Data? {
        do {
            let data = try Data(contentsOf: url)
            return data
        } catch {
            print("Failed to get data from url. error = \(error.localizedDescription)")
            return nil
        }
    }
}
