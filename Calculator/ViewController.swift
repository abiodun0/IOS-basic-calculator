//
//  ViewController.swift
//  Calculator
//
//  Created by Abiodun Shuaib on 16/04/2016.
//  Copyright © 2016 Abiodun Shuaib. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var displayText: UILabel!
    var userIsInTheMiddleOfWritingNumbers = false
    let brain = CalculatorBrain()

    @IBAction func numberPressed(sender: UIButton) {
        if !userIsInTheMiddleOfWritingNumbers{
            displayText.text = "\(sender.currentTitle!)"
            userIsInTheMiddleOfWritingNumbers = true
        }
        else{
            displayText.text = displayText.text! + "\(sender.currentTitle!)"
        }
    }
    @IBAction func enter() {
        userIsInTheMiddleOfWritingNumbers = false
        if let result = brain.addOperand(displayValue){
            displayValue = result
        }else {
            displayValue = 0
        }
        
    }
    @IBAction func mathOperation(sender: UIButton) {
        if userIsInTheMiddleOfWritingNumbers {
            enter()
        }
        if let result = brain.performOperation(sender.currentTitle!){
            displayValue = result
        } else {
            displayValue = 0
        }

    }
    
    var displayValue : Double {
        get{
            return Double(displayText.text!)!
        }
        set {
            displayText.text = "\(newValue)"
        }
    }

}

