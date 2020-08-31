//
//  NotificationCenterEnum.swift
//  InternetConnection
//
//  Created by ds-mayur on 30/8/2020.
//

import UIKit

enum NotificationCenterEnum {
    
    case online
    case offline
    case onlineConnected
    
    public func getName() -> Notification.Name{
        switch self {
        case .online:
            return Notification.Name(rawValue: "Online")
        case .offline:
            return Notification.Name(rawValue: "Offline")
        case .onlineConnected:
            return Notification.Name(rawValue: "OnlineConnected")
        }
    }
}
