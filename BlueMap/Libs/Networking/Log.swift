//
//  Log.swift
//  Treatsure
//
//  Created by Vinh on 7/1/17.
//  Copyright © 2017 VinhNH. All rights reserved.
//

import UIKit

class Log {
    
    class func debug(_ messages: Any..., filename: String = #file,
                     function: String = #function, line: Int = #line) {
        #if DEBUG
            let component = filename.components(separatedBy: "/")
            var log = ""
            for item in messages {
                log = log + " " + String(describing: item)
            }
            if let fileName = component.last {
                print("😡[\(Date())][debug][\(fileName):\(line)] \(function) 👉 \(log)")
            } else {
                print("😡[\(Date())][debug][Unknown File:\(line)] \(function) 👉 \(log)")
            }
        #endif
    }
    
    class func info(_ messages: Any..., filename: String = #file,
                    function: String = #function, line: Int = #line) {
        #if DEBUG
            let component = filename.components(separatedBy: "/")
            var log = ""
            for item in messages {
                log = log + " " + String(describing: item)
            }
            if let fileName = component.last {
                print("👻[\(Date())][info][\(fileName):\(line)] \(function) 👉 \(log)")
            } else {
                print("👻[\(Date())][info][Unknown File:\(line)] \(function) 👉 \(log)")
            }
        #endif
    }
    
    class func warn(_ messages: Any..., filename: String = #file,
                    function: String = #function, line: Int = #line) {
        #if DEBUG
            let component = filename.components(separatedBy: "/")
            var log = ""
            for item in messages {
                log = log + " " + String(describing: item)
            }
            if let fileName = component.last {
                print("⚠️[\(Date())][warn][\(fileName):\(line)] \(function) 👉 \(log)")
            } else {
                print("⚠️[\(Date())][warn][Unknown File:\(line)] \(function) 👉 \(log)")
            }
        #endif
    }
    
    class func error(_ messages: Any..., filename: String = #file,
                     function: String = #function, line: Int = #line) {
        #if DEBUG
            let component = filename.components(separatedBy: "/")
            var log = ""
            for item in messages {
                log = log + " " + String(describing: item)
            }
            if let fileName = component.last {
                print("⛔️[\(Date())][error][\(fileName):\(line)] \(function) 👉 \(log)")
            } else {
                print("⛔️[\(Date())][error][Unknown File:\(line)] \(function) 👉 \(log)")
            }
        #endif
    }
}
