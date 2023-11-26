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
    
//    private var bufferDictionary: [Int:AVAudioPCMBuffer] = [:]
    private var bufferArray: [AudioBuffer] = []
    private var curIndex: Int = 0
    private var isSchedule: Bool = false
    
    var isFirst: Bool = true
    var isPaused: Bool = false
    var isBuffer1: Bool = true
    
//    let queue = DispatchQueue(label: "com.example.myqueue")
//    private let highPriorityQueue = DispatchQueue.global(qos: .userInitiated)
    let interval = 100
    var buffer1: AVAudioPCMBuffer!
    var buffer2: AVAudioPCMBuffer!
    
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
    public func connectServer() {
        delegate?.willAudioPlayOnServer()
    }
    
//    func scheduleBuffers(_ bufferCount: Int) {
//        while bufferCount > curIndex + 5 {
//            let index = curIndex
//            var buffers: [AVAudioPCMBuffer] = []
//                
//            for i in index..<index + 5 {
//                buffers.append(self.bufferDictionary[i]!)
//                self.bufferDictionary.removeValue(forKey: i)
//            }
//                
//            for i in 0..<5 {
//                playerNode.scheduleBuffer(buffers[i])
//            }
//
//            curIndex += 5
//        }
//    }
    
//    func scheduleBuffer(_ data: Data) {
//        let floatArray = data.byteToFloat2DArray()
//        let buffer = floatArray.toStereoBuffer()
//        
////        bufferArray[bufferStruct.index] = buffer
//    }
    
    func play() {
        if !playerNode.isPlaying {
            playerNode.play()
            if isFirst {
                isFirst = false
                buffer1 = prepareBuffer(curIndex: curIndex)
                schduleBuffer1()
            } else {
                if isBuffer1 {
                    schduleBuffer1()
                } else {
                    schduleBuffer2()
                }
            }
            
        }
    }
    
    func pause() {
        playerNode.pause()
    }
    
    func prepareBuffer(curIndex: Int) -> AVAudioPCMBuffer? {
        print(curIndex)
        print(bufferArray.count)
        let bufferCount = bufferArray.count
        
        guard curIndex < bufferCount else {
            bufferArray.removeAll()
            print("play Done.")
            return nil
        }
        
        let lastIndex = min(bufferCount, curIndex + interval)
        
        var buffer = bufferArray[curIndex]
        
        for buf in bufferArray[curIndex + 1..<lastIndex] {
            buffer = buffer + buf
        }
        self.curIndex = lastIndex
        
        return buffer.toStereoBuffer()
    }
    
    func schedulBuffer(_ curIndex: Int) {
        if isBuffer1 {
            playerNode.scheduleBuffer(buffer1) { [weak self] in
                guard let self = self else { return }
                self.isBuffer1 = false
                print("play done!")
                schedulBuffer(self.curIndex)
            }
            buffer2 = prepareBuffer(curIndex: curIndex)
        } else {
            playerNode.scheduleBuffer(buffer2) { [weak self] in
                guard let self = self else { return }
                self.isBuffer1 = true
                print("play done!")
                schedulBuffer(self.curIndex)
            }
            buffer1 = prepareBuffer(curIndex: curIndex)
        }
        
//        playerNode.scheduleBuffer(buffer) {
//            schedulBuffer(curIndex+1)
//        }
    }
    
    func schduleBuffer1() {
        guard isPaused else { return }
        
        guard curIndex < bufferArray.count else {
            buffer1 = nil
            print("buffer1 Done.")
            return
        }
        
        playerNode.scheduleBuffer(buffer1) {
            self.isBuffer1 = false
            self.schduleBuffer2()
            print("play done!")
        }
        buffer2 = prepareBuffer(curIndex: curIndex)
    }
    
    func schduleBuffer2() {
        guard isPaused else { return }
        
        guard curIndex < bufferArray.count else {
            buffer2 = nil
            print("buffer2 Done.")
            return
        }
        
        playerNode.scheduleBuffer(buffer2) {
            self.isBuffer1 = true
            self.schduleBuffer1()
            print("play done!")
        }
        buffer1 = prepareBuffer(curIndex: curIndex)
    }
    
//    func schedulBuffersSemaphore(_ bufferCount: Int) {
//        var nxtIdx = curIndex + 1
//        while bufferCount > curIndex {
//            if nxtIdx > curIndex {
//                playerNode.scheduleBuffer(bufferArray[curIndex]) {
//                    nxtIdx += 1
//                }
//                curIndex += 1
//            }
//        }
//    }
    
    func loadBufferSemaphore(_ jsonString: String) {
        guard let bufferStruct = AudioBuffer.decodeJsonToBuffer(jsonString) else { return }

        let index = bufferStruct.index
        let semaphore = DispatchSemaphore(value: 0)
//        print("버퍼 스케쥴링")
//        playerNode.play()
//        playerNode.scheduleBuffer(bufferStruct.toStereoBuffer())
        
        DispatchQueue.global().async { [self] in
            if bufferArray.count > index {
                bufferArray[index] = bufferStruct
            } else {
                bufferArray.append(bufferStruct)
            }
            
            semaphore.signal()
        }
        
        semaphore.wait()
    }
    
//    func scheduleBuffer(_ jsonString: String) {
//        guard let bufferStruct = AudioBuffer.decodeJsonToBuffer(jsonString) else { return }
//            
//        let buffer = bufferStruct.toStereoBuffer()
//        let index = bufferStruct.index
//            
//        queue.sync { [self] in
//            bufferDictionary[index] = buffer
//            if bufferDictionary.count > curIndex + 5 {
//                scheduleBuffers(bufferDictionary.count)
//                print("buffercount: \(bufferDictionary.count), curIndex: \(curIndex)")
//            }
//        }
//        
//        if !playerNode.isPlaying {
//            playerNode.play()
//        }
//    }
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
