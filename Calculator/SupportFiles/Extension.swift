//
//  Extension.swift
//  Calculator
//
//  Created by 嚴安生 on 2020/3/3.
//  Copyright © 2020 Anderson. All rights reserved.
//

import Foundation

extension Double {
    
    func toString() -> String {
        return String(self)
    }
    
    func toInt() -> Int {
        return Int(self)
    }
}

extension Int {
    
    func toString() -> String {
        return String(self)
    }
    
}

extension String {
    func toDouble() -> Double? {
        return Double(self)
    }
}
