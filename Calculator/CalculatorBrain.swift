//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Abiodun Shuaib on 17/04/2016.
//  Copyright © 2016 Abiodun Shuaib. All rights reserved.
//

import Foundation

class CalculatorBrain {
    private var opStack = [Op]()
    private enum Op{
        case Operand(Double)
        case TernaryOperator(String, (Double, Double) -> Double)
        case UnaryOperator(String, Double -> Double)
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .TernaryOperator(let op, _):
                    return "\(op)"
                case .UnaryOperator(let op, _):
                    return "\(op)"
                }
            }
        }
        
    }
    // var knownOps = Dictionary<String, Op>() a better way yay!
    private var knowOps = [String:Op]()
    

    
    init(){
        knowOps["√"] = Op.UnaryOperator("√", sqrt)
        knowOps["-"] = Op.TernaryOperator("-") {$1 - $0 }
        knowOps["/"] = Op.TernaryOperator("/") {$1 - $0 }
        knowOps["*"] = Op.TernaryOperator("*", *)
        knowOps["+"] = Op.TernaryOperator("+", +)
    }
    func addOperand(operand: Double) -> Double?{
        opStack.append(Op.Operand(operand))
        return evaluate()
        
    }
    func performOperation(symbol: String) -> Double?{
        if let operation = knowOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
    typealias someobject = AnyObject
    var program : someobject{
        get{
            return opStack.map {$0.description}
        }
        set {
            if let opSymbols = newValue as? Array<String> {
                var newOpStack = [Op]()
                for symbol in opSymbols{
                    if let op = knowOps[symbol]{
                        newOpStack.append(op)
                    } else if let operand = NSNumberFormatter().numberFromString(symbol)?.doubleValue {
                        newOpStack.append(Op.Operand(operand))
                    }
                }
                opStack =  newOpStack
            }
        }
    }
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]){
        if !ops.isEmpty{
            var remaingOps = ops
            let op = remaingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remaingOps)
            case .TernaryOperator(_, let operation):
                let op1Evaluation = evaluate(remaingOps)
                if let op1 = op1Evaluation.result {
                    let op2evaluation = evaluate(op1Evaluation.remainingOps)
                    if let op2 = op2evaluation.result{
                        return (operation(op1, op2), op2evaluation.remainingOps)
                    }
                }
            case .UnaryOperator(_, let operation):
                let opEvaluation = evaluate(remaingOps)
                if let op = opEvaluation.result{
                    return(operation(op), opEvaluation.remainingOps)
                }
                
            }
        }
        
        return (nil, ops)
    }
    func evaluate() -> Double?{
        let (result, _) = evaluate(opStack)
        return result
    }
}