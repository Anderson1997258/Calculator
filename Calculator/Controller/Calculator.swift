//
//  Calculator.swift
//  Calculator
//
//  Created by 嚴安生 on 2020/3/3.
//  Copyright © 2020 Anderson. All rights reserved.
//

import Foundation

class Calculator {
    
    static let sheard = Calculator()
    var calculationBag: CalculationBag
    
    init() {
        calculationBag = CalculationBag()
    }
    
    
    /// Auto judgment first operation sign to calculating last answer.
    /// - Parameter calcuBag: Need calculation bag of the calculating.
    func calculatingAll(calcuBag: CalculationBag) -> Double {
        var lastAnswer: Double
        
        if calcuBag.firstOperation == "+" || calcuBag.firstOperation == "-" {
            lastAnswer = calculatingAllForAdd(calcuBag: calcuBag)
        } else {
            lastAnswer = calculatingAllForMult(calcuBag: calcuBag)
        }
        
        return lastAnswer
    }
    
    /// If first operation sign is '÷' or '×', use this function to calculating last answer.
    /// - Parameter calcuBag: Need calculation bag of the calculating.
    func calculatingAllForMult(calcuBag: CalculationBag) -> Double {
        let calcuAry = calcuBag.calcuAry
        print("(calculatingAllForMult) calcuAry: \(calcuAry)")
        var lastNum = calcuAry[0].toDouble() ?? -99
        var tmpOperation = ""
        
        for i in 1..<calcuAry.count {
            if let num = calcuAry[i].toDouble() {
                lastNum = cal(operation: tmpOperation, number1: num, number2: lastNum)
            } else {
                tmpOperation = calcuAry[i]
            }
            
        }
        return lastNum
    }
    
    /// If first operation sign is '+' or '-', and second operation sign is '÷' or '×',
    /// use this function to calculate the part of '÷' and '×'.
    /// - Parameter calcuBag: Need calculation bag of the calculating.
    func calculatingSmall(calcuBag: CalculationBag) -> Double {
        let calcuAry = calcuBag.calcuAry
        print("(calculatingSmall) calcuAry: \(calcuAry)")
        var lastNum = calcuAry[2].toDouble() ?? -99
        var tmpOperation = ""
        
        for i in 3..<calcuAry.count {
            if let num = calcuAry[i].toDouble() {
                lastNum = cal(operation: tmpOperation, number1: num, number2: lastNum)
            } else {
                tmpOperation = calcuAry[i]
            }
        }
        return lastNum
    }
    
    /// To fix zero after dot and over space.
    /// - Parameter currentAnswer: Input calculated answer
    func checkOkAnswer(from currentAnswer: Double) -> String {
        var lastAnswer: String
        if floor(currentAnswer) == currentAnswer {
            lastAnswer = Int(currentAnswer).toString()
        } else {
            lastAnswer = currentAnswer.toString()
        }
        
        if lastAnswer.count > 10 {
            lastAnswer = String(lastAnswer.prefix(9))
        }
        
        return lastAnswer
    }
    
    /// Check calculate array need cleaning
    /// - Parameter calcuBag: To check calculate array calculation bag.
    func checkIsNeedClean(calcuBag: CalculationBag) -> Bool {
        let calcuAry = calcuBag.calcuAry
        if calcuAry.count > 3 {
            if calcuAry[calcuAry.count-1] == "+" || calcuAry[calcuAry.count-1] == "-" {
                return true
            }
        }
        return false
    }
    
    /// Cleaning calculate array.
    /// - Parameters:
    ///   - calcuBag: To need cleaning calculate array calculation bag.
    ///   - lastOpe: Input the last operation sign.
    func cleanCalculationBag(calcuBag: CalculationBag) -> CalculationBag {
        var calcuBag = calcuBag
        let a = calculatingAll(calcuBag: calcuBag)
        calcuBag.calcuAry.removeAll()
        calcuBag.calcuAry.append(a.toString())
        calcuBag.calcuAry.append(calcuBag.lastOperation)
        calcuBag.firstOperation = calcuBag.lastOperation
        return calcuBag
    }
    
    /// If first operation sign is '+' or '-', use this function to calculating last answer.
    /// - Parameter calcuBag: Need calculation bag of the calculating.
    private func calculatingAllForAdd(calcuBag: CalculationBag) -> Double {
        let calcuAry = calcuBag.calcuAry
        var lastNum = calculatingSmall(calcuBag: calcuBag)
        lastNum = cal(operation: calcuAry[1], number1: lastNum, number2: calcuAry[0].toDouble()!)
        return lastNum
    }
    
    /// Calculating two numbers.
    /// - Parameters:
    ///   - operation: Input operation sign.
    ///   - number1: Input the first number.
    ///   - number2: Input the second number.
    private func cal(operation: String, number1: Double, number2: Double) -> Double {
        let answer: Double
        
        switch operation {
        case "+":
            answer = number2 + number1
        case "-":
            answer = number2 - number1
        case "×":
            answer = number2 * number1
        case "÷":
            answer = number2 / number1
        default:
            return 0
        }
        
        return answer
    }
    
}
