//
//  NetworkService.swift
//  MiPS
//
//  Created by 남유성 on 2023/10/11.
//

import Foundation
import Starscream
import AVFoundation

protocol NetworkServiceProtocol {
    var isSocketConnected: Bool { get }
}

class NetworkService: NetworkServiceProtocol {

    static let shared = NetworkService()

    private var socket: WebSocket?
    var isSocketConnected: Bool = false
    
    private init() {
        let request = URLRequest(url: URL(string: SERVER_DEV)!)
        socket = WebSocket(request: request)
        socket?.delegate = self
    }

    public func setSocketEvent(onEvent: ((WebSocketEvent) -> Void)?) {
        socket?.onEvent = onEvent
    }
    
    public func connectSocket() {
        guard isSocketConnected == false else {
            alert("⚠️ Already Socket Connected")
            return
        }
        
        socket?.connect()
    }
    
    public func disconnectSocket() {
        isSocketConnected = false
        socket?.disconnect()
    }
    
    public func sendMessage(_ message: String) {
        socket?.write(string: message)
    }
    
    public func sendData(_ data: Data) {
        socket?.write(data: data)
    }
}

extension NetworkService: WebSocketDelegate {
    func didReceive(event: WebSocketEvent, client: WebSocketClient) {
        switch event {
        case .connected(let headers):
            isSocketConnected = true
            alert("websocket is connected: \(headers)")
        
        case .disconnected(let reason, let code):
            isSocketConnected = false
            alert("websocket is disconnected: \(reason) with code: \(code)")
        
        case .text(let string):
//            alert("Received text: \(string.count)")
            break
        
        case .binary(let data):
//            alert("Received data: \(data.count)")
            break
        
        case .ping(_):
            break
        
        case .pong(_):
            break
        
        case .viabilityChanged(_):
            break
        
        case .reconnectSuggested(_):
            break
        
        case .cancelled:
            isSocketConnected = false
            alert("websocket is cancelled")
        
        case .error(let error):
            isSocketConnected = false
            alert("websocket is error = \(error!)")
        
        case .peerClosed:
            isSocketConnected = false
            alert("websocket is pearClosed")
            break
        }
    }
}

extension NetworkService {
    private func alert(_ message: String) {
        print("[NetworkService] \(message)")
    }
}
