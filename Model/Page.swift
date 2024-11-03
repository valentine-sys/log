//
//  Page.swift
//  log
//
//  Created by Valome on 11/3/24.
//

import SwiftUI



enum Page: String, CaseIterable {
    
    case page1 = "checkmark.seal.fill"
    case page2 = "heart.fill"
    case page3 = "wand.and.sparkles"
    case page4 = "app.gift.fill"

    var title: String {
        switch self {
        case .page1: return "Welcome to Vlog"
        case .page2: return "Share your logs with loggers"
        case .page3: return "Level your logs with creative ideas"
        case .page4: return "Build your fanbase with your logs"
        }
    }
    
    var subTitle: String {
        switch self {
        case .page1: return "Start your journey here."
        case .page2: return "Connect and share your moments."
        case .page3: return "Create logs with new ideas"
        case .page4: return "Engage and grow your community."
        }
    }

    var index: CGFloat {
        switch self {
        case .page1: return 0
        case .page2: return 1
        case .page3: return 2
        case .page4: return 3
        }
    }
    
    var nextPage: Page {
        let index = Int(self.index) + 1
        if index < Page.allCases.count {
            return Page.allCases[index]
        }
        return self
    }

    var previousPage: Page {
        let index = Int(self.index) - 1
        if index >= 0 {
            return Page.allCases[index]
        }
        return self
    }
}
