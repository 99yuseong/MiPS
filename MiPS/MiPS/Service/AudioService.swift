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
    
    private var bufferArray: [AudioBuffer] = []
    private var bufferIndex: Int = 0
    private var curIndex: Int = 0
    private var isSchedule: Bool = false
    
    var isFirst: Bool = true
    var isPaused: Bool = false
    var isBuffer1: Bool = true
    
    let interval = 1
    var buffer1: AVAudioPCMBuffer!
    var buffer2: AVAudioPCMBuffer!
    var buffer3: AVAudioPCMBuffer!
    
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

extension AudioService {
    /// 현재 재생 중인 데이터 전달
    /// - Parameter headRotation: 현재 머리 각도
    public func sendPlayingData(_ headRotation: HeadRotation) {
        guard let playingData = PlayingData(
            headRotation: headRotation,
            curIndex: curIndex
        ).toJsonString() else { return }
        
        NetworkService.shared.sendMessage(playingData)
    }
}

// MARK: - 음원 버퍼
extension AudioService {
    public func connectServer() {
        delegate?.willAudioPlayOnServer()
    }
    
    func play() {
        isPaused = false

        if !playerNode.isPlaying {
            playerNode.play()
            if isFirst {
                isFirst = false
                buffer1 = prepareBuffer()
                buffer2 = prepareBuffer()
                schduleBuffer1()
            }
        }
    }
    
    func pause() {
        playerNode.pause()
        isPaused = true
    }
    
    func prepareBuffer() -> AVAudioPCMBuffer? {
        let bufferCount = bufferArray.count
        
        guard bufferIndex < bufferCount else {
            print("curIndex: \(curIndex), bufferCount: \(bufferCount)")
            return nil
        }
        
        print("buffering: \(bufferIndex)")
        let lastIndex = min(bufferCount, bufferIndex + interval)
        
        var buffer = bufferArray[bufferIndex]
        
        for buf in bufferArray[bufferIndex + 1..<lastIndex] {
            buffer = buffer + buf
        }
        
        self.bufferIndex = lastIndex
        
        return buffer.toStereoBuffer()
    }
    
    func schduleBuffer1() {
        guard !isPaused else {
            isBuffer1 = true
            return
        }
//        guard bufferIndex < bufferArray.count else {
//            buffer1 = nil
//            print("buffer1 Done.")
//            return
//        }
        
        playerNode.scheduleBuffer(buffer1) {
            self.curIndex += self.interval
            print("playing \(self.curIndex)")
//            self.isBuffer1 = false
            self.schduleBuffer3()
//            print("play done!")
        }
        playerNode.scheduleBuffer(buffer2) {
            self.curIndex += self.interval
        }
        buffer3 = prepareBuffer()
        buffer1 = prepareBuffer()
    }
    
    func schduleBuffer2() {
        guard !isPaused else {
            isBuffer1 = false
            return
        }
        
//        guard bufferIndex < bufferArray.count else {
//            buffer2 = nil
//            print("buffer2 Done.")
//            return
//        }
        
        playerNode.scheduleBuffer(buffer2) {
            self.curIndex += self.interval
            print("playing \(self.curIndex)")
            self.schduleBuffer1()
        }
        playerNode.scheduleBuffer(buffer3) {
            self.curIndex += self.interval
        }
        buffer1 = prepareBuffer()
        buffer2 = prepareBuffer()
    }
    
    func schduleBuffer3() {
        guard !isPaused else {
            isBuffer1 = false
            return
        }
        
        
//        guard bufferIndex < bufferArray.count else {
//            buffer3 = nil
//            print("buffer3 Done.")
//            return
//        }
        
        playerNode.scheduleBuffer(buffer3) {
            self.curIndex += self.interval
            print("playing \(self.curIndex)")
            self.schduleBuffer2()
        }
        playerNode.scheduleBuffer(buffer1) {
            self.curIndex += self.interval
        }
        buffer2 = prepareBuffer()
        buffer3 = prepareBuffer()
    }
    
    func loadBufferSemaphore(_ jsonString: String) {
        guard let bufferStruct = AudioBuffer.decodeJsonToBuffer(jsonString) else { return }

        let index = bufferStruct.index
        let semaphore = DispatchSemaphore(value: 0)
        
        DispatchQueue.global().async { [weak self] in
            
            guard let self = self else { return }
            if self.bufferArray.count > index {
                self.bufferArray[index] = bufferStruct
            } else {
                self.bufferArray.append(bufferStruct)
            }
            
            semaphore.signal()
        }
        
        semaphore.wait()
    }
}

// MARK: - 로컬 음원 재생
extension AudioService {
//    public func playLocalSource(for resource: String, format: AudioExt) {
//        guard let url = checkLocalUrl(for: resource, format: format) else {
//            alert("\(resource) can not found.")
//            return
//        }
//        
//        playAudio(localUrl: url)
//    }
//    
//    private func checkLocalUrl(for resource: String, format: AudioExt) -> URL? {
//        
//        return Bundle.main.url(
//            forResource: resource,
//            withExtension: format.description
//        )
//    }
//    
//    private func playAudio(localUrl: URL) {
//        do {
//            soundEffect = try AVAudioPlayer(contentsOf: localUrl)
//            soundEffect?.play()
//        } catch {
//            alert("Failed to play mp3 file. error = \(error.localizedDescription)")
//        }
//    }
}

// MARK: - 외부 음원 다운로드
extension AudioService {
//    public func downloadExtSource(from urlString: String) {
//        DispatchQueue.global().async { [self] in
//            guard let url = checkExtUrl(for: urlString),
//                  let data = requestSourceData(from: url)
//            else { return }
//            
//            playAudio(resource: data)
//        }
//    }
//    
//    private func checkExtUrl(for urlString: String) -> URL? {
//        guard let urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
//              let url = URL(string: urlString)
//        else {
//            alert("\(urlString) is invalid URL")
//            return nil
//        }
//        
//        return url
//    }
//    
//    private func requestSourceData(from url: URL) -> Data? {
//        do {
//            let data = try Data(contentsOf: url)
//            return data
//        } catch {
//            alert("Failed to get data from url. error = \(error.localizedDescription)")
//            return nil
//        }
//    }
//    
//    private func playAudio(resource: Data) {
//        do {
//            soundEffect = try AVAudioPlayer(data: resource)
//            soundEffect?.play()
//        } catch {
//            alert("Failed to play mp3 file. error = \(error.localizedDescription)")
//        }
//    }
}

extension AudioService {
    private func alert(_ message: String) {
        print("[AudioService] \(message)")
    }
}
