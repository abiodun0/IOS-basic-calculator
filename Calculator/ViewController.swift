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
    var numbersEntered = [Double]()

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
        numbersEntered.append(Double(displayText.text!)!)
        print(numbersEntered)
    }
    @IBAction func mathOperation(sender: UIButton) {
        if userIsInTheMiddleOfWritingNumbers {
            enter()
        }
        switch sender.currentTitle! {
        case "+":
            // Different ways of passing in anonimous function
            performOperation({(op1: Double, op2: Double) -> Double in return op1 + op2})
        case "-":
        // Which can also be re-written like this
            performOperation({(op1, op2) in return op2 - op1})
        case "/":
            // If it's not the last paraeter
            performOperation() {$1 / $0}
        case "*":
            performOperation {$1 * $0}
            //if its the last paraemeter
        case "√":
            performOperation({ (op1) -> Double in
                 sqrt(op1)
            })
            //or
            // performOperation { sqrt($0)}
      default: break
            
        }
    }
    func performOperation(operation: (Double) -> Double){
        if numbersEntered.count >= 1{
            displayText.text = "\(operation(numbersEntered.removeLast()))"
            enter()
        }
        
    }
    @nonobjc
    func performOperation(operation: (Double, Double) -> Double){
        if numbersEntered.count >= 2{
            displayText.text = "\(operation(numbersEntered.removeLast(), numbersEntered.removeLast()))"
            enter()
        }
        
    }

}

