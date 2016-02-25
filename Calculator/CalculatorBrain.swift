//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Nan Huang on 2016-02-03.
//  Copyright © 2016 Nan Huang. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    private enum Op: CustomStringConvertible {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        case Variable(String)
        
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                case .Variable(let symbol):
                    return symbol
                }
            }
        }
    }
    
    init() {
        func learnOp(op: Op) {
            knownOps[op.description] = op
        }
        
        knownOps["✕"] = Op.BinaryOperation("✕", *)
        knownOps["÷"] = Op.BinaryOperation("÷") {$1 / $0}
        knownOps["+"] = Op.BinaryOperation("+", +)
        knownOps["−"] = Op.BinaryOperation("-") {$1 - $0}
        knownOps["√"] = Op.UnaryOperation("√") {sqrt($0)}
        knownOps["Sin"] = Op.UnaryOperation("Sin") {sin($0)}
        knownOps["Cos"] = Op.UnaryOperation("Cos") {cos($0)}
    }
    
    private var opStack = [Op]()
    
    private var knownOps = [String: Op]()
    
    var variableValues = [String: Double]()
    
    var description: String {
        get {
            var (result, ops) = ("", opStack)
            repeat {
                var desc: String?
                (desc, ops) = description(ops)
                if (result == "") {
                    result = desc!
                } else {
                    result = "\(desc!) \(result)"
                }
            }while ops.count > 0
            
            return result
        }
    }
    
    private func description(ops: [Op]) -> (result: String?, remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand.description, remainingOps)
            case .UnaryOperation(let symbol, _):
                let opDesc = description(remainingOps)
                if let desc = opDesc.result {
                    return ("\(symbol)(\(desc))", opDesc.remainingOps)
                }
            case .BinaryOperation(let symbol, _):
                let op1Desc = description(remainingOps)
                if let desc1 = op1Desc.result {
                    let op2Desc = description(op1Desc.remainingOps)
                    if let desc2 = op2Desc.result {
                        return ("(\(desc2) \(symbol) \(desc1))", op2Desc.remainingOps)
                    }
                }
            case .Variable(let symbol):
                return ("\(variableValues[symbol])", remainingOps)
            }
        }
        return (nil, ops)
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]){
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            case .Variable(let symbol):
                return (variableValues[symbol], remainingOps)
            }
        }
        return (nil, ops)
    }
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        print("\(opStack) = \(result!) with \(remainder) left over")
        print("Description: \(description)")
        return result
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func pushOperand(symbol: String) -> Double? {
        opStack.append(Op.Variable(symbol))
        
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
    
    func clearStack() {
        opStack = [Op]()
    }
}