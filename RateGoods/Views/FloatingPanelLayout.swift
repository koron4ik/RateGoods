//
//  FloatingPanelLayout.swift
//  RateGoods
//
//  Created by Vadim on 12/23/18.
//  Copyright © 2018 Koronchik. All rights reserved.
//

import UIKit
import FloatingPanel

class MyFloatingPanelLayout: FloatingPanelLayout {
    
    func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        switch position {
        case .full: return 140.0
        case .tip: return 69.0
        default: return nil
        }
    }
    
    public var supportedPositions: Set<FloatingPanelPosition> {
        return [.full, .tip]
    }
    
    var initialPosition: FloatingPanelPosition {
        return .full
    }
}
