//
//  NetworkService.swift
//  MiPS
//
//  Created by 남유성 on 2023/10/10.
//

import Foundation
import SocketIO
import Starscream

class NetworkService {
    static let shared = NetworkService()
    
    private let url: String = "http://127.0.0.1:8000/ws"
    private var socket: WebSocket?
    private var isConnected: Bool = false
    
    private init() {
        setupWebSocket()
    }
    
    private func setupWebSocket() {
        let url = URL(string: url)!
        var request = URLRequest(url: url)
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket?.delegate = self
    }
    
    public func connect() {
        socket?.connect()
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
            break
        }
    }
}
