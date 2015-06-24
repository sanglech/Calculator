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
    var userIsInMiddleOfTypingANumber=false
    var brain=CalculatorBrain()
    
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
    
    @IBAction func operate(sender: UIButton) {
        let operation=sender.currentTitle!
        if userIsInMiddleOfTypingANumber{
            enter()
        }
        
        /* Swift able to infer because we are passing functions it knows what it should be returning and the type of the arguments (because perform operations) that we dont need to specifiy it here. Just need to write functions in line here  */
        if let operation=sender.currentTitle{
            if let result=brain.performOperation(operation){
                displayValue=result
            }
            else{
                displayValue=0
            }
        }
    }
    
    
    @IBAction func clear() {
        display.text!="0"
    }
    
    @IBAction func enter() {
        userIsInMiddleOfTypingANumber=false
        if let result=brain.pushOpperand(displayValue){
            displayValue=result
        }
        else{
            displayValue=0
        }
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

