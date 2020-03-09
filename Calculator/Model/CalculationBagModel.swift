//
//  CalculationBagModel.swift
//  Calculator
//
//  Created by 嚴安生 on 2020/3/3.
//  Copyright © 2020 Anderson. All rights reserved.
//

import Foundation

struct CalculationBag {
    var firstOperation: String = ""     // Save first operation sign.
    var lastOperation: String = ""      // Save last operation sign.
    var lastNumber: Double = 0.0        // Save first number.
    var calcuAry = [String]()           // To temporary privious calculation.
}
