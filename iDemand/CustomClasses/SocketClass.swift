//
//  SocketClass.swift
//  iDemand
//
//  Created by Roby on 27/10/20.
//  Copyright © 2020 Hitasoft. All rights reserved.
//

import UIKit
import SocketIO

var socket = SocketManager(socketURL: URL(string: SOCKET_URL)!, config: [.log(true), .compress])

protocol socketDelegate {
    func gotSocket(msg:NSDictionary,type:String)
}

class SocketClass {
    static let sharedInstance = SocketClass()
     var delegate : socketDelegate?

    //connect socket
    func connect()  {
        self.disconnect()//disconnect before connect
        socket.defaultSocket.connect()
        socket.defaultSocket.on(clientEvent: .connect) {data, ack in
             print("SOCKET CONNECTED SUCCESSFULLY")
            self.joinLive()
            self.liveMe()
            self.ping()
            self.addHandler()
        }
    }
    //disconnect socet
    func disconnect()  {
        self.offSocketEvents()
        socket.defaultSocket.disconnect()
    }

    //off all sockets
    func offSocketEvents()  {
        socket.defaultSocket.off("receiveMessage")
        socket.defaultSocket.off("ping")
    }
    func ping()  {
        socket.defaultSocket.emit("ping","")
    }
    //connect chat
    func joinLive(){
        let requestDict = NSMutableDictionary()
        requestDict.setValue(LocalDefault.shared.userID(), forKey: "chat_id")
        socket.defaultSocket.emit("joinChat", requestDict)
    }
    
    //live me
    func liveMe()  {
        let requestDict = NSMutableDictionary()
             requestDict.setValue(LocalDefault.shared.userID(), forKey: "user_id")
             socket.defaultSocket.emit("liveMe", requestDict)
    }
    
    //join to particular Chat
    func join(chat:String)  {
        let requestDict = NSMutableDictionary()
         requestDict.setValue(chat, forKey: "chat_id")
         socket.defaultSocket.emit("joinChat", requestDict)
    }
    
    //send msg
    func send(msg:NSDictionary) {
        // print("SEND MSG \(msg)")
        socket.defaultSocket.emit("sendMessage", msg)
    }
    
    //notify instant informtion
    func updateMsg(msgDict:NSDictionary, type:String)  {
        self.delegate?.gotSocket(msg: msgDict, type: type)
    }
    
    // Response for receive, read message
    func addHandler(){
        socket.defaultSocket.on("pong") { ( data, ack) -> Void in
            self.ping()
        }
        //msg listener
        socket.defaultSocket.on("receiveMessage") { ( data, ack) -> Void in
            let listArray:NSArray = data as NSArray
            let msgDict:NSDictionary = listArray.object(at: 0) as! NSDictionary
            print("RECEIVE MSG \(msgDict)")
            self.delegate?.gotSocket(msg: msgDict, type: "receiveMessage")
        }
        //block listener
        socket.defaultSocket.on("blockChat") { ( data, ack) -> Void in
            let listArray:NSArray = data as NSArray
            let msgDict:NSDictionary = listArray.object(at: 0) as! NSDictionary
            self.delegate?.gotSocket(msg: msgDict, type: "blockChat")
        }
    }
}
