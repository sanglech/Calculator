//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Christian Sangle on 2015-06-24.
//  Copyright (c) 2015 Christian Sangle. All rights reserved.
//

import Foundation

class CalculatorBrain{
    
    private enum Op : CustomStringConvertible{
        case UnaryOperation (String,Double->Double)
        case BinaryOperation(String, (Double,Double)->Double)
        case Operand (Double)
        var description: String {
        get {
            switch self{
            case .Operand(let operand):
                return ("\(operand)")
            case .UnaryOperation(let symbol, _):
                return symbol
            case .BinaryOperation(let symbol, _):
                return symbol
            }
        }
    }
    
    }
    private var opStack = [Op]()
    
    /*Declare a dictionary same as Dictionary<String,Op>() */
    //(key,value)
    
    private var knownOps = [String:Op]()
    
    /* When calculator brain gets called, this init gets called.*/
    init(){
        func learnOp(op: Op){
            knownOps[op.description]=op
        }
        learnOp(Op.BinaryOperation("×", *))
        learnOp(Op.BinaryOperation("÷") {$1 / $0})
        learnOp(Op.BinaryOperation("+", +))
        learnOp(Op.BinaryOperation("−") {$1 - $0})
        learnOp(Op.UnaryOperation("√", sqrt))
        
    }

    /* Read only when passing values that are not classes (makes copy). 
    Note: implicit let for vlues that are passed in.*/
   private func evaluate(ops:[Op])->(result:Double?,remainingOps:[Op]){
        if !ops.isEmpty{
            var remaingOps=ops
            let op = remaingOps.removeLast()
            switch op{
            case .Operand(let operand):
                return(operand,remaingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation=evaluate(remaingOps)
                if let operand=operandEvaluation.result{
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation=evaluate(remaingOps)
                if let operand1=op1Evaluation.result{
                    let op2Evaluation=evaluate(op1Evaluation.remainingOps)
                    if let operand2=op2Evaluation.result{
                        return(operation(operand1,operand2),op2Evaluation.remainingOps)
                    }
                }
            }
        }
        return (nil, ops)
    }
    //use OPtional/return when you want to return null/nill
    func evaluate() ->Double? {
    let (result, remainder)=evaluate(opStack)
        if let _=result{
            print("\(opStack) = \(result!) with \(remainder) left over")
        }
        else{
            print ("Should clear history")
        }
        return result
    }
    
    func pushOpperand(operand:Double) ->Double?{
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol:String) -> Double?{
        if let operation=knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
    
    func clearStack(){
        while(opStack.count>0){
            opStack.removeLast()
        }
        print("opstack is \(opStack)")
    }
}