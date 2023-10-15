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
        setupWebSocket()
    }
    
    private func setupWebSocket() {
        let request = URLRequest(
            url: URL(string: SERVER_DEV)!
        )
        socket = WebSocket(request: request)
        socket?.delegate = self
    }

    
    public func connectSocket() {
        guard isSocketConnected == false else {
            print("⚠️ Already Socket Connected")
            return
        }
        
        socket?.connect()
    }
        
    public func setSocketEvent(onEvent: ((WebSocketEvent) -> Void)?) {
        socket?.onEvent = onEvent
    }
    
    public func closeConnection() {
        socket?.disconnect()
        socket?.delegate = nil
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
            print("websocket is connected: \(headers)")
        
        case .disconnected(let reason, let code):
            isSocketConnected = false
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
            isSocketConnected = false
            print("websocket is cancelled")
        
        case .error(let error):
            isSocketConnected = false
            print("websocket is error = \(error!)")
        
        case .peerClosed:
            isSocketConnected = false
            print("websocket is pearClosed")
            break
        }
    }
}
