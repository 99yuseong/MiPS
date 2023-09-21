//
//  AudioService.swift
//  MiPS
//
//  Created by 남유성 on 2023/09/20.
//

import Foundation
import AVFoundation

protocol AudioServiceProtocol {
    func playLocalSource(for resource: String, format: AudioFormat)
    func playExtSource(from urlString: String)
}

class AudioService: AudioServiceProtocol {
    
    // MARK: - Property
    static let shared = AudioService()
    
    private var soundEffect: AVAudioPlayer?
    
    // MARK: - Life Cycle
    private init() {}
}

// MARK: - Methods
extension AudioService {
    public func playLocalSource(for resource: String, format: AudioFormat) {
        guard let url = checkLocalUrl(for: resource, format: format) else {
            print("\(resource) can not found.")
            return
        }
        
        playAudio(localUrl: url)
    }
    
    public func playExtSource(from urlString: String) {
        DispatchQueue.global().async { [self] in
            guard let url = checkExtUrl(for: urlString),
                  let data = requestSourceData(from: url)
            else { return }
            
            playAudio(resource: data)
        }
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
    private func checkLocalUrl(for resource: String, format: AudioFormat) -> URL? {
        
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
