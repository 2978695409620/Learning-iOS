//
//  ViewController.swift
//  Calculator
//
//  Created by Nan Huang on 2016-01-31.
//  Copyright © 2016 Nan Huang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var desc: UILabel!
    
    var userIsInTheMiddleOfTypingANumber = false
    var hasFloatingPoint = false
    
    var brain = CalculatorBrain()
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    @IBAction func appendPi(sender: UIButton) {
        let pi = "\(M_PI)"
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        display.text = pi
        enter()
    }
    
    @IBAction func floatingPoint(sender: UIButton) {
        if !hasFloatingPoint {
            if !userIsInTheMiddleOfTypingANumber {
                display.text = "0"
                userIsInTheMiddleOfTypingANumber = true
            }
            display.text = display.text! + sender.currentTitle!
            hasFloatingPoint = true
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = 0
            }
        }
        desc.text = brain.description + " ="
    }
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        hasFloatingPoint = false
        if let result = brain.pushOperand(displayValue!) {
            displayValue = result
        } else {
            displayValue = 0
        }
    }
    
    @IBAction func setM(sender: UIButton) {
        userIsInTheMiddleOfTypingANumber = false
        if displayValue != nil {
            brain.variableValues["M"] = displayValue!
            if let result = brain.evaluate() {
                displayValue = result
            }
            else {
                displayValue = nil
            }
        }
    }
    
    @IBAction func pushM(sender: UIButton) {
        if (userIsInTheMiddleOfTypingANumber) {
            enter()
        }
        
        if let result = brain.pushOperand(sender.currentTitle!) {
            displayValue = result
        }
        else {
            displayValue = nil
        }
    }
    
    
    @IBAction func clearAll(sender: UIButton) {
        desc.text = " "
        display.text = "0"
        brain.clearStack()
        userIsInTheMiddleOfTypingANumber = false
        hasFloatingPoint = false
    }
    
    var displayValue: Double? {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue!)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
}

