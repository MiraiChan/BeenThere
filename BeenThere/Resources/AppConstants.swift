//
//  AppConstants.swift
//  BeenThere
//
//  Created by Almira Khafizova on 08.09.26.
//

import SwiftUI

enum AppConstants {
    enum Spacing {
        static let tiny: CGFloat = 2
        static let small: CGFloat = 4
        static let medium: CGFloat = 10
        static let large: CGFloat = 24
    }
    
    enum Padding {
        static let tiny: CGFloat = 2
        static let small: CGFloat = 4
        static let medium: CGFloat = 10
        static let large: CGFloat = 32
    }
    
    enum CornerRadius {
        static let standard: CGFloat = 16
        static let large: CGFloat = 20
    }
    
    enum Layout {
        static let activityNumberWidth: CGFloat = 28
        static let mapHeight: CGFloat = 200
    }
    
    enum Icons {
        static let onboardingSize: CGFloat = 90
    }
    
    enum Opacity {
        static let faint: Double = 0.1
        static let shadow: Double = 0.15
        static let light: Double = 0.2
        static let medium: Double = 0.6
        static let strong: Double = 0.9
    }
    
    enum Animation {
        static let springResponse: Double = 0.5
        static let scaleActive: CGFloat = 1.1
        static let scaleInactive: CGFloat = 1.0
    }
    
    enum Shadow {
        static let standardRadius: CGFloat = 3
        static let standardY: CGFloat = 1
    }
}
