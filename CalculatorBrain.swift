//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Christian Sangle on 2015-06-24.
//  Copyright (c) 2015 Christian Sangle. All rights reserved.
//

import Foundation

class CalculatorBrain{
    
    enum Op{
        case UnaryOperation (String,Double->Double)
        case BinaryOperation(String, (Double,Double)->Double)
        case Operand (Double)
    }
    var opStack = [Op]()
    
    func pushOpperand(operand:Double){
        opStack.append(Op.Operand(operand))
    }
}