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
    @IBOutlet weak var history: UILabel!
    
    var userIsInTheMiddleOfTypingANumber = false
    var hasFloatingPoint = false
    
    var brain = CalculatorBrain()
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            display.text = display.text! + digit
            history.text = history.text! + digit
        } else {
            display.text = digit
            history.text = history.text! + " " + digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    @IBAction func appendPi(sender: UIButton) {
        let pi = "\(M_PI)"
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        display.text = pi
        history.text = history.text! + " π"
        enter()
    }
    
    @IBAction func floatingPoint(sender: UIButton) {
        if !hasFloatingPoint {
            if !userIsInTheMiddleOfTypingANumber {
                display.text = "0"
                userIsInTheMiddleOfTypingANumber = true
            }
            display.text = display.text! + sender.currentTitle!
            history.text = history.text! + " ."
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
            history.text = history.text! + " " + operation
        }
    }
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        hasFloatingPoint = false
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        } else {
            displayValue = 0
        }
        history.text = history.text! + " ⏎"
    }
    
    @IBAction func clearAll(sender: UIButton) {
        history.text = ""
        display.text = "0"
        brain.clearStack()
        userIsInTheMiddleOfTypingANumber = false
        hasFloatingPoint = false
    }
    
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
}

