//
//  AudioService.swift
//  MiPS
//
//  Created by 남유성 on 2023/09/20.
//

import Foundation
import AVFoundation

protocol AudioServiceDelegate: NSObjectProtocol {
    func willAudioPlayOnServer()
    func willAudioEndOnServer()
    func didAudioPlayOnServer()
    func didAudioEndOnServer()
}

class AudioService {
    
    // MARK: - Property
    weak var delegate: AudioServiceDelegate?
    
    private var audioEngine = AVAudioEngine()
    private var playerNode = AVAudioPlayerNode()
    private var soundEffect: AVAudioPlayer?
    
    // MARK: - Life Cycle
    init() {
        prepareEngine()
    }
    
    private func prepareEngine() {
        audioEngine.attach(playerNode)
        audioEngine.connect(
            playerNode, 
            to: audioEngine.mainMixerNode,
            format: nil
        )
        
        do {
            try audioEngine.start()
        } catch {
            alert("Failed to start engine: \(error)")
        }
    }
}

// MARK: - 음원 버퍼
extension AudioService {
    public func play() {
        delegate?.willAudioPlayOnServer()
        playerNode.play()
    }
    
    func scheduleBuffer(_ data: Data) {
        let floatArray = data.byteToFloat2DArray()
        let buffer = floatArray.toStereoBuffer()
        playerNode.scheduleBuffer(buffer)
    }
}

// MARK: - 로컬 음원 재생
extension AudioService {
    public func playLocalSource(for resource: String, format: AudioExt) {
        guard let url = checkLocalUrl(for: resource, format: format) else {
            alert("\(resource) can not found.")
            return
        }
        
        playAudio(localUrl: url)
    }
    
    private func checkLocalUrl(for resource: String, format: AudioExt) -> URL? {
        
        return Bundle.main.url(
            forResource: resource,
            withExtension: format.description
        )
    }
    
    private func playAudio(localUrl: URL) {
        do {
            soundEffect = try AVAudioPlayer(contentsOf: localUrl)
            soundEffect?.play()
        } catch {
            alert("Failed to play mp3 file. error = \(error.localizedDescription)")
        }
    }
}

// MARK: - 외부 음원 다운로드
extension AudioService {
    public func downloadExtSource(from urlString: String) {
        DispatchQueue.global().async { [self] in
            guard let url = checkExtUrl(for: urlString),
                  let data = requestSourceData(from: url)
            else { return }
            
            playAudio(resource: data)
        }
    }
    
    private func checkExtUrl(for urlString: String) -> URL? {
        guard let urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: urlString)
        else {
            alert("\(urlString) is invalid URL")
            return nil
        }
        
        return url
    }
    
    private func requestSourceData(from url: URL) -> Data? {
        do {
            let data = try Data(contentsOf: url)
            return data
        } catch {
            alert("Failed to get data from url. error = \(error.localizedDescription)")
            return nil
        }
    }
    
    private func playAudio(resource: Data) {
        do {
            soundEffect = try AVAudioPlayer(data: resource)
            soundEffect?.play()
        } catch {
            alert("Failed to play mp3 file. error = \(error.localizedDescription)")
        }
    }
}

extension AudioService {
    private func alert(_ message: String) {
        print("[AudioService] \(message)")
    }
}
