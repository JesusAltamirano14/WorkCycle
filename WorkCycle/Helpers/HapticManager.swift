//
//  HapticManager.swift
//  WorkCycle
//
//  Created by Jesus Dario Altamirano Barzola on 9/12/23.
//
import Foundation
import SwiftUI

class HapticManager {
    
    static let instance = HapticManager() //Singleton
    
    func notificationVibrate(type: UINotificationFeedbackGenerator.FeedbackType) -> Void {
        let generateNotification = UINotificationFeedbackGenerator()
        generateNotification.notificationOccurred(type)
    }
    
    func impactVibrate(style: UIImpactFeedbackGenerator.FeedbackStyle) -> Void {
        let generatorImpact = UIImpactFeedbackGenerator(style: style)
        generatorImpact.impactOccurred()
    }
    
}
