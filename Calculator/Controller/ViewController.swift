//
//  ViewController.swift
//  Calculator
//
//  Created by 嚴安生 on 2020/3/3.
//  Copyright © 2020 Anderson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var labInputArea: UILabel!
    @IBOutlet var btnOperation: [UIButton]!
    
    let calculator = Calculator.sheard
    
    var isCalculating = false   // Save whether to calculating
    var isStart = false         // Save whether to start
    var isSwitch = true         // Save a mark with switch numbers and operation
    var isNeedClean = false     // Save calculated array markers need cleaning
    var numberOfClearButton = 0 // Calculation clear button clicked number of time
    
    var calcuBag: CalculationBag!
    
    /// Get cleared ',' sign of the number
    var getNumber: Double {
        get {
            var input = labInputArea.text!
            if input.contains(",") {
                input = input.replacingOccurrences(of: ",", with: "")
            }
            return input.toDouble()!
        }
    }
    
    /// Add ',' sign at display area
    var displayNumber: String {
        get {
            let num = calculator.checkOkAnswer(from: getNumber)
            var resultStr = num.components(separatedBy: ".")
            var j = 0, count = resultStr[0].count
            for _ in 0..<count {
                j += 1
                if j % 3 == 0 && j != count {
                    let index = resultStr[0].index(resultStr[0].startIndex, offsetBy: count - j)
                    resultStr[0].insert(",", at: index)
                }
            }
            
            if resultStr.count == 2 {
                return "\(resultStr[0]).\(resultStr[1])"
            } else {
                return resultStr[0]
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        calcuBag = calculator.calculationBag    // Get calculation bag model

    }
    
    /// Swipe to right to back one number
    @IBAction func gesBackNumber(_ sender: UISwipeGestureRecognizer) {
        var input = labInputArea.text!
        if input != "0" {
            input.removeLast()
            labInputArea.text = (input.isEmpty ? "0" : input)
            labInputArea.text = displayNumber
        
        }
    }
    /// Clear button is pressed
    @IBAction func btnClearPressed(_ sender: UIButton) {
        print(calcuBag.calcuAry)
        labInputArea.text = "0"
        numberOfClearButton += 1
        
        if numberOfClearButton == 1 {
            let calcuAry = calcuBag.calcuAry
            if calcuAry.count >= 2 {
                focusColor(calcuBag.lastOperation)
                isSwitch = true
                if calcuAry.count == 2 {
                    calcuBag.calcuAry.removeLast()
                    isStart = false
                }
            }
        } else {
            reset()
        }
        
    }
    
    /// Percent(%) button is pressed
    @IBAction func btnPercentPressed(_ sender: UIButton) {
        if labInputArea.text != "0" {
            isCalculating = true
            labInputArea.text = calculator.checkOkAnswer(from: getNumber / 100)
        }
    }
    
    /// Negative(+/-) button is pressed
    @IBAction func btnNegativePressed(_ sender: UIButton) {
        labInputArea.text = calculator.checkOkAnswer(from: -getNumber)
    }
    
    /// Dot(.) button is pressed
    @IBAction func btnDotPressed(_ sender: UIButton) {
        if labInputArea.text!.count < 11 && !(labInputArea.text?.contains("."))! {
            labInputArea.text! += "."
        }
    }
    
    /// Numders(0~9) button is pressed
    @IBAction func btnNumdersPressed(_ sender: UIButton) {
        let inNumder = sender.titleLabel?.text ?? "0"
        let inArea = labInputArea.text!
        if inArea == "0" || isSwitch {
            labInputArea.text = inNumder
            isSwitch = false
            if isCalculating && calcuBag.lastOperation != "" {
                numberOfClearButton = 0
                if calcuBag.calcuAry.last?.toDouble() != nil {
                    calcuBag.calcuAry.append(calcuBag.lastOperation)    // Save last operation sign
                }
                unFocusColor(calcuBag.lastOperation)
//                print("(btnNumdersPressed) calcuBag.calcuAry: \(calcuBag.calcuAry)")
                
                // Check calculated array need cleaning
                isNeedClean = calculator.checkIsNeedClean(calcuBag: calcuBag)
            }
        } else if inArea.count < 12 {
            labInputArea.text! += inNumder
        }
        
        labInputArea.text = displayNumber
        
        calcuBag.lastNumber = getNumber
    }
    
    /// Operation(+,-,×,÷) button is pressed
    @IBAction func btnOperationPressed(_ sender: UIButton) {
        numberOfClearButton = 0
        
        // Cleaning calculated array
        if isNeedClean {
            isNeedClean = false
            calcuBag = calculator.cleanCalculationBag(calcuBag: calcuBag)
        }
        
        unFocusColor(calcuBag.lastOperation)
        calcuBag.lastOperation = (sender.titleLabel?.text!)!    // Update last operation sign.
        focusColor(calcuBag.lastOperation)
        
        // Prevent calculated array duplicate storage
        if !isSwitch {
            isSwitch = true
            calcuBag.calcuAry.append(getNumber.toString())  // Save number
            print("AAA")
        }
        
        if !isStart {
            // Setup first calculation parameter
            isStart = true
            isCalculating = true
            calcuBag.firstOperation = calcuBag.lastOperation    // Update first operation sign.
            print("BBBB")
            if calcuBag.calcuAry.count == 0 {
                calcuBag.calcuAry.append(getNumber.toString())  // Save number
            }
        } else {
            if calcuBag.calcuAry.count >= 3 {   // Wait to calculate array is a reasonable formula. Ex: 5+3, 8*9+6...
                let lastOpe = calcuBag.lastOperation
                if lastOpe == "+" || lastOpe == "-" {
                    let a = calculator.calculatingAll(calcuBag: calcuBag)
                    labInputArea.text = calculator.checkOkAnswer(from: a)
                } else {
                    let firstOpe = calcuBag.firstOperation
                    if firstOpe == "×" || firstOpe == "÷" {
                        let a = calculator.calculatingAllForMult(calcuBag: calcuBag)
                        labInputArea.text = calculator.checkOkAnswer(from: a)
                    } else {
                        let a = calculator.calculatingSmall(calcuBag: calcuBag)
                        labInputArea.text = calculator.checkOkAnswer(from: a)
                    }
                }
            }
            labInputArea.text = displayNumber
        }
    }
    
    /// Equal(=) button is pressed
    @IBAction func btnEqualPressed(_ sender: UIButton) {
        
        if isCalculating {
            unFocusColor(calcuBag.lastOperation)
            if calcuBag.calcuAry.last?.toDouble() != nil {
                calcuBag.calcuAry.append(calcuBag.lastOperation)    // Save last operation sign
            }
            
            isNeedClean = calculator.checkIsNeedClean(calcuBag: calcuBag)
            
            if isNeedClean {
                isNeedClean = false
                calcuBag = calculator.cleanCalculationBag(calcuBag: calcuBag)   // Cleaning calculated array
            }
            
            calcuBag.calcuAry.append(calcuBag.lastNumber.toString())    // Save last input number
            
            let lastAnswer = calculator.calculatingAll(calcuBag: calcuBag)
            let confirmedAnswer = calculator.checkOkAnswer(from: lastAnswer)
            
            labInputArea.text = confirmedAnswer     // Show answer
            labInputArea.text = displayNumber
            
            isSwitch = true
            isStart = false
            numberOfClearButton = 2
        }
        
    }
    
    /// Reset calculator
    func reset() {
        unFocusColor(calcuBag.lastOperation)
        calcuBag.calcuAry.removeAll()
        calcuBag.firstOperation = ""
        calcuBag.lastOperation = ""
        calcuBag.lastNumber = 0
        isCalculating = false
        isStart = false
        isSwitch = true
        isNeedClean = false
        numberOfClearButton = 0
    }
    
    /// Can light focus button.
    /// - Parameter ope: Need light up of the operation sign.
    func focusColor(_ ope: String) {
        for btn in btnOperation {
            if btn.titleLabel?.text == ope {
                btn.backgroundColor = .systemGray2
            }
        }
    }
    
    /// To button operation sign button mode.
    /// - Parameter ope: Need to default of the operation sign.
    func unFocusColor(_ ope: String) {
        for btn in btnOperation {
            if btn.titleLabel?.text == ope {
                btn.backgroundColor = .systemOrange
            }
        }
    }
    
}

