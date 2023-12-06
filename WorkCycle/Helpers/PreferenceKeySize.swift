//
//  PreferenceKeySize.swift
//  WorkCycle
//
//  Created by Jesus Dario Altamirano Barzola on 28/11/23.
//

import Foundation
import SwiftUI


struct SizePreferenceKey: PreferenceKey {
    
    static var defaultValue: CGSize = .zero
    
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        defaultValue = nextValue()
    }
}

struct WidthPreferenceKey: PreferenceKey{
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        defaultValue = nextValue()
    }
}


struct FloatPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        defaultValue = nextValue()
    }
}

