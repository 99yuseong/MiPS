//
//  NetworkService.swift
//  MiPS
//
//  Created by 남유성 on 2023/10/11.
//

import Foundation
import Starscream
import AVFoundation

class NetworkService {
    static let shared = NetworkService()
    
    var audioEngine = AVAudioEngine()
    var playerNode = AVAudioPlayerNode()
    var audioFileBuffer = AVAudioPCMBuffer()
    
    private let url: String = "http://0.0.0.0:8000/ws"
    private var socket: WebSocket?
    private var isConnected: Bool = false
    
    private init() {
        setupWebSocket()
        prepareEngine()
    }
    
    private func setupWebSocket() {
        let url = URL(string: url)!
        var request = URLRequest(url: url)
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket?.delegate = self
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
    
    func play(bufferData: [[Float]]) -> AVAudioPCMBuffer {
        let format = AVAudioFormat(
            standardFormatWithSampleRate: 44100,
            channels: 2
        )!
        
        let buffer = AVAudioPCMBuffer(
            pcmFormat: format,
            frameCapacity: UInt32(bufferData[0].count)
        )!
        
        buffer.frameLength = buffer.frameCapacity

        let left = bufferData[0]
        let right = bufferData[1]
        
        for i in 0..<bufferData[0].count {
            buffer.floatChannelData?[0][i] = left[i]
            buffer.floatChannelData?[1][i] = right[i]
        }

        return buffer
    }
    
    public func connect() {
        socket?.onEvent = { event in
            switch event {
            case .text(let text):
                print(text)
                break
            case .binary(let data):
                let floatCount = data.count / 8
                
                let byteSizeForOneArray = floatCount * MemoryLayout<Float>.size
                
                let left = data.subdata(in: 0..<byteSizeForOneArray)
                let right = data.subdata(in: byteSizeForOneArray..<data.count)
                
                let left_Array: [Float] = left.withUnsafeBytes { Array($0.bindMemory(to: Float.self)) }
                let right_Array: [Float] = right.withUnsafeBytes { Array($0.bindMemory(to: Float.self)) }
                
                self.stackQueue(array: [left_Array, right_Array])
                
                break
            default:
                break
            }
        }
        socket?.connect()
    }
    
    func stackQueue(array: [[Float]]) {
        let buffer = play(bufferData: array)
        self.playerNode.scheduleBuffer(buffer)
    }
    
    func play() {
        playerNode.play()
    }
    
    func convertDataToFloatArray(_ data: Data) -> [Float] {
        let uint8Array = [UInt8](data)
        return convertUInt8ArrayToFloatArray(uint8Array)
    }
    
    
    func convertUInt8ArrayToFloatArray(_ uint8Array: [UInt8]) -> [Float] {
        var floatArray = [Float]()
        
        for i in stride(from: 0, to: uint8Array.count, by: 4) {
            let byte1 = uint8Array[i]
            let byte2 = uint8Array[i + 1]
            let byte3 = uint8Array[i + 2]
            let byte4 = uint8Array[i + 3]
            
            let floatValue = floatFromBytes(byte1, byte2, byte3, byte4)
            floatArray.append(floatValue)
        }
        
        return floatArray
    }

    func floatFromBytes(_ b1: UInt8, _ b2: UInt8, _ b3: UInt8, _ b4: UInt8) -> Float {
        let intValue = Int32(b1) << 24 | Int32(b2) << 16 | Int32(b3) << 8 | Int32(b4)
        return Float(bitPattern: UInt32(bitPattern: intValue))
    }
    
    
    func floatValue(data: Data) -> Float {
        return Float(bitPattern: UInt32(bigEndian: data.withUnsafeBytes { $0.load(as: UInt32.self) }))
    }
    
    public func closeConnection() {
        socket?.disconnect()
        socket?.delegate = nil
    }
    
    public func sendMessage(_ message: String) {
        socket?.write(string: message)
    }
}

extension NetworkService: WebSocketDelegate {
    func didReceive(event: WebSocketEvent, client: WebSocketClient) {
        switch event {
        case .connected(let headers):
            isConnected = true
            print("websocket is connected: \(headers)")
        case .disconnected(let reason, let code):
            isConnected = false
            print("websocket is disconnected: \(reason) with code: \(code)")
        case .text(let string):
            print("Received text: \(string)")
        case .binary(let data):
            print("Received data: \(data.count)")
        case .ping(_):
            break
        case .pong(_):
            break
        case .viabilityChanged(_):
            break
        case .reconnectSuggested(_):
            break
        case .cancelled:
            print("websocket is canclled")
        case .error(let error):
            print("websocket is error = \(error!)")
        case .peerClosed:
            print("closed")
            break
        }
    }
}
