//
//  ReachabilityManager.swift
//  SkyForecast
//
//  Created by Hellen Soloviy on 3/18/19.
//  Copyright © 2019 HellySolovii. All rights reserved.
//

import Reachability

public class ReachabilityManager: NSObject {
    override fileprivate init(){}
    
    var isReachable = true
    var reachability: Reachability?
    
    var isCurrentlyReachable: Bool {
        if let reachability = self.reachability {
            return reachability.connection != .none
        } else {
            return false
        }
    }
    
    static let shared = ReachabilityManager()
    
    func startTracking(){
        reachability = Reachability()
        
        do { try reachability?.startNotifier() } catch {
            print("Unable to start notifier")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged),name: Notification.Name.reachabilityChanged,object: reachability)
    }
    
    func updateStatus(){
        guard let reachability = self.reachability else { return }
        updateStatus(reachability: reachability)
    }
    
    func updateStatus(reachability : Reachability){
        if reachability.connection != .none {
            isReachable = true
        } else {
            isReachable = false
            fatalError()
        }
    }
    
    @objc func reachabilityChanged(note: NSNotification) {
        let reachability = note.object as! Reachability
        updateStatus(reachability: reachability)
    }
}
