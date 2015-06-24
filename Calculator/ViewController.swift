//
//  ViewController.swift
//  Calculator
//
//  Created by Christian Sangle on 2015-05-19.
//  Copyright (c) 2015 Christian Sangle. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var history: UILabel!
    
    var userIsInMiddleOfTypingANumber=false
    var historyStack = Array<String>()
    var decimalAlreadyUsed=false
    var decCount=0
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if(userIsInMiddleOfTypingANumber){
            display.text=display.text! + digit
        }
        else{
            userIsInMiddleOfTypingANumber=true;
            display.text=digit
        }
    }
    
    @IBAction func appendDecimal(sender: UIButton) {
        let decimal=sender.currentTitle!
        display.text="0"
        if(decCount==0){
            display.text=display.text!+decimal
            userIsInMiddleOfTypingANumber=true
            decCount++
        }
        else{
            decCount++
        }
    }
    
    
    var opperandStack = Array<Double>()
    @IBAction func operate(sender: UIButton) {
        let operation=sender.currentTitle!
        if userIsInMiddleOfTypingANumber{
            enter()
        }
        
        /* Swift able to infer because we are passing functions it knows what it should be returning and the type of the arguments (because perform operations) that we dont need to specifiy it here. Just need to write functions in line here  */
        historyStack.append(operation)
        switch operation{
        case "×": performOperation({$0 * $1} )
        case "÷": performOperation({op1,op2 in return op2 / op1})
        case "+": performOperation({op1, op2 in op1 + op2})
        case "−": performOperation { $1 - $0 }
        case "√": performOperation1{ sqrt($0) }
        case "sin": performOperation1{ sin($0)}
        case "cos": performOperation1{ cos($0) }
        case "±": performOperation1{ $0 * -1}
        default: break
        }
    }
    
    func performOperation(operation : (Double, Double)->Double){
        if(opperandStack.count>=2){
            displayValue = operation(opperandStack.removeLast(),opperandStack.removeLast())
            var operationOccuring=historyStack.removeLast()
            historyWith2Args(historyStack.removeLast(), arg2: historyStack.removeLast(), arg3: operationOccuring)
            enter()
            let stringDispVal=historyStack.last!
            display.text="= \(stringDispVal)"
        }
    }
    
    func historyWith2Args(arg1: String,arg2:String,arg3:String){
         history.text=arg2 + arg3+arg1
    }
    
    func historyWith1Args(arg1: String,arg2:String){
        history.text=arg1 + arg2
    }
    
    func performOperation1(operation :Double -> Double){
        if(opperandStack.count>=1){
            displayValue = operation(opperandStack.removeLast())
            historyWith1Args(historyStack.removeLast(),arg2:historyStack.removeLast())
            enter()
            let stringDispVal=historyStack.last!
            display.text="= \(stringDispVal)"
        }
    }
    
    @IBAction func clear() {
        opperandStack.removeAll()
        historyStack.removeAll()
        display.text!="0"
        history.text!=""
    }
    
    @IBAction func enter() {
        userIsInMiddleOfTypingANumber=false
        decCount=0
        if(display.text!=="π"){
            opperandStack.append(M_PI)
        }
        else{
            opperandStack.append(displayValue)
        }
        historyStack.append(display.text!)
        println("opperand stack= \(opperandStack)")
        println("history stack= \(historyStack)")
    }
    
    var displayValue:Double {
        get{
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        
        set{
            display.text = "\(newValue)"
            userIsInMiddleOfTypingANumber=false
        }
    }
}

