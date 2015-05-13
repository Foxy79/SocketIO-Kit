//
//  SocketIO.swift
//  Smartime
//
//  Created by Ricardo Pereira on 02/04/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

import Foundation

internal let SocketIOName = "SocketIO"

class SocketIO<T: Printable>: SocketIOReceiver, SocketIOEmitter {
    
    private let url: NSURL
        
    // Default transport: WebSocket
    private lazy var connection = SocketIOConnection(transport: SocketIOWebSocket.self)
    
    convenience init(url: String) {
        if let url = NSURL(string: url) {
            self.init(nsurl: url)
        }
        else {
            assertionFailure("\(SocketIOName): Invalid URL")
            self.init(url: "")
        }
    }
    
    convenience init(nsurl: NSURL) {
        self.init(nsurl: nsurl, withOptions: SocketIOOptions())
    }
    
    convenience init(url: String, withOptions options: SocketIOOptions) {
        if let url = NSURL(string: url) {
            self.init(nsurl: url, withOptions: options)
        }
        else {
            assertionFailure("\(SocketIOName): Invalid URL")
            self.init(url: "", withOptions: options)
        }
    }

    init(nsurl: NSURL, withOptions options: SocketIOOptions) {
        url = nsurl
        
        // TODO: Options
    }
    
    final func connect() {
        connection.open(url)
    }
    
    final func connect(customTransport: SocketIOTransport.Type) {
        connection = SocketIOConnection(transport: customTransport.self)
    }
    
    final func connect(customRequest: SocketIORequester, customTransport: SocketIOTransport.Type) {
        connection = SocketIOConnection(requester: customRequest, transport: customTransport.self)
    }
    
    final func disconnect() {
        connection.close()
    }
    
    final func reconnect() {
        connection.close()
        connection = SocketIOConnection(transport: SocketIOWebSocket.self)
        
        // TODO: Reuse options
    }
    
    func canConnect(url: NSURL) -> Bool {
        // ?
        return NSURLConnection.canHandleRequest(NSURLRequest(URL: url))
    }
    
    
    //MARK: SocketIOEmitter
    
    /**
    Sends a text message to the server.
    
    :param: event     Event name provided with SocketIOEvent.
    :param: message   Message to send.
    */
    final func emit(event: SocketIOEvent, withMessage message: String) {
        emit(event.description, withMessage: message)
    }

    /**
    Sends a text message to the server.
    
    :param: event     Event name provided with generic type.
    :param: message   Message to send.
    */
    final func emit(event: T, withMessage message: String) {
        emit(event.description, withMessage: message)
    }

    /**
    Sends a text message to the server.
    
    :param: event     Event name.
    :param: message   Message to send.
    */
    final func emit(event: String, withMessage message: String) {
        connection.emit(event, withMessage: message)
    }

    /**
    Sends a list of items to the server.
    
    :param: event   Event name provided with SocketIOEvent.
    :param: list    List of type NSArray to send.
    */
    final func emit(event: SocketIOEvent, withList list: NSArray) {
        emit(event.description, withList: list)
    }

    /**
    Sends a list of items to the server.
    
    :param: event   Event name provided with generic type.
    :param: list    List of type NSArray to send.
    */
    final func emit(event: T, withList list: NSArray) {
        emit(event.description, withList: list)
    }
    
    /**
    Sends a list of items to the server.
    
    :param: event   Event name.
    :param: list    List of type NSArray to send.
    */
    final func emit(event: String, withList list: NSArray) {
        connection.emit(event, withList: list)
    }
    
    /**
    Sends a dictionary (key-value) to the server.
    
    :param: event   Event name provided with SocketIOEvent.
    :param: dict    Key-value object of type NSDictionary to send.
    */
    final func emit(event: SocketIOEvent, withDictionary dict: NSDictionary) {
        emit(event.description, withDictionary: dict)
    }

    /**
    Sends a dictionary (key-value) to the server.
    
    :param: event   Event name provided with generic type.
    :param: dict    Key-value object of type NSDictionary to send.
    */
    final func emit(event: T, withDictionary dict: NSDictionary) {
        emit(event.description, withDictionary: dict)
    }

    /**
    Sends a dictionary (key-value) to the server.
    
    :param: event   Event name.
    :param: dict    Key-value object of type NSDictionary to send.
    */
    final func emit(event: String, withDictionary dict: NSDictionary) {
        connection.emit(event, withDictionary: dict)
    }
    
    /**
    Sends a object to the server.
    
    :param: event   Event name provided with SocketIOEvent.
    :param: object  Object that comply SocketIOObject protocol.
    */
    final func emit(event: SocketIOEvent, withObject object: SocketIOObject) {
        emit(event.description, withObject: object)
    }
    
    /**
    Sends a object to the server.
    
    :param: event   Event name provided with generic type.
    :param: object  Object that comply SocketIOObject protocol.
    */
    final func emit(event: T, withObject object: SocketIOObject) {
        emit(event.description, withObject: object)
    }
    
    /**
    Sends a object to the server.
    
    :param: event   Event name provided.
    :param: object  Object that comply SocketIOObject protocol.
    */
    final func emit(event: String, withObject object: SocketIOObject) {
        connection.emit(event, withObject: object)
    }

    
    
    //MARK: SocketIOReceiver
    
    final func on(event: SocketIOEvent, withCallback callback: SocketIOCallback) -> SocketIOEventHandler {
        return connection.on(event, withCallback: callback)
    }
    
    final func on(event: T, withCallback callback: SocketIOCallback) -> SocketIOEventHandler {
        return on(event.description, withCallback: callback)
    }
    
    final func on(event: String, withCallback callback: SocketIOCallback) -> SocketIOEventHandler {
        return connection.on(event, withCallback: callback)
    }
    
    final func onAny(callback: SocketIOCallback) -> SocketIOEventHandler {
        return connection.onAny(callback)
    }
    
    final func off() -> SocketIOEventHandler {
        return connection.off()
    }
    
}
