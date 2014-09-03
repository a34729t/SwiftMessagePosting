//
//  Reachability.swift
//  MessagePosting
//
//  Created by Nicolas Flacco on 8/31/14.
//  Copyright (c) 2014 Nicolas Flacco. All rights reserved.
//

import UIKit

class Reachability {

    class var sharedInstance:Reachability {
        struct Singleton {
            static let instance = Reachability()
        }

        return Singleton.instance
    }

    var reachability:TMReachability
    
    required init() {
        self.reachability = TMReachability(hostName: "yahoo.com") // yahoo always works
        // See here for instructions: https://github.com/tonymillion/Reachability
        // NOTE: If I build a connection aware task-queue, notifications will obviously be important in allowing the queue to push data to the web on network state changes.
    }
    
    func hasInternet() -> Bool {
        let reachableWifi = self.reachability.isReachableViaWiFi()
        let reachableWWAN = self.reachability.isReachableViaWWAN()
        
//        println("hasReachability Wifi:%d WWAN:%d", reachableWifi, reachableWWAN)
        
        return reachableWifi || reachableWWAN
    }

}