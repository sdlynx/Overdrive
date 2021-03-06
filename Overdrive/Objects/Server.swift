//
//  Server.swift
//  Overdrive
//
//  Created by Sanjit Dutta on 11/3/18.
//  Copyright © 2018 Sanjit Dutta. All rights reserved.
//

import UIKit
import os.log

class Server: NSObject, NSCoding {
    
    //MARK: Properties
    
    var nickname: String
    var hostname: String
    var username: String
    var password: String
    var port: Int
    var rootDirectory: String
    var scheme: String
    var sessionKey: String

    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("servers")
    
    //MARK: Types
    
    struct PropertyKey {
        static let nickname = "nickname"
        static let hostname = "hostname"
        static let username = "username"
        static let password = "password"
        static let port = "port"
        static let rootDirectory = "rootDirectory"
        static let scheme = "scheme"
        static let sessionKey = "sessionKey"
    }
    
    //MARK: Initialization
    init?(nickname: String?, hostname: String, username: String?, password: String?, port: Int?, rootDirectory: String?, scheme: String?, sessionKey: String?) {
        self.nickname = nickname ?? hostname
        self.hostname = hostname
        self.username = username ?? ""
        self.password = password ?? ""
        self.port = port ?? 9091
        self.rootDirectory = rootDirectory ?? "/transmission/rpc"
        self.scheme = scheme ?? "http"
        self.sessionKey = sessionKey ?? ""
        
        // override in case rootDirectory was ""
        if (self.rootDirectory.isEmpty) {
            self.rootDirectory = "/transmission/rpc"
        }
    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(nickname, forKey: PropertyKey.nickname)
        aCoder.encode(hostname, forKey: PropertyKey.hostname)
        aCoder.encode(username, forKey: PropertyKey.username)
        aCoder.encode(password, forKey: PropertyKey.password)
        aCoder.encode(port, forKey: PropertyKey.port)
        aCoder.encode(rootDirectory, forKey: PropertyKey.rootDirectory)
        aCoder.encode(scheme, forKey: PropertyKey.scheme)
        aCoder.encode(sessionKey, forKey: PropertyKey.sessionKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let hostname = aDecoder.decodeObject(forKey: PropertyKey.hostname) as? String else {
            os_log("Unable to decode the hostname for a Server object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        let nickname = aDecoder.decodeObject(forKey: PropertyKey.nickname) as? String
        let username = aDecoder.decodeObject(forKey: PropertyKey.username) as? String
        let password = aDecoder.decodeObject(forKey: PropertyKey.password) as? String
        let port = aDecoder.decodeInteger(forKey: PropertyKey.port) as Int
        let rootDirectory = aDecoder.decodeObject(forKey: PropertyKey.rootDirectory) as? String
        let scheme = aDecoder.decodeObject(forKey: PropertyKey.scheme) as? String
        let sessionKey = aDecoder.decodeObject(forKey: PropertyKey.sessionKey) as? String
        
        // Must call designated initializer.
        self.init(nickname: nickname, hostname: hostname, username: username, password: password, port: port, rootDirectory: rootDirectory, scheme: scheme, sessionKey: sessionKey)
    }
}
