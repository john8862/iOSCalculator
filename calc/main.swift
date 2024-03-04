//
//  main.swift
//  calc
//
//  Created by Sherlock Zhao on 04/03/2024.
//  Copyright © 2024 Sherlock Zhao. All rights reserved.
//

import Foundation

// Error Types for the Calculator
enum CalculatorError: Error {
    case invalidInput(String)
    case divisionByZero
    case invalidOperator(String)
    case calculationError(String)
}

// Extend the String type to check if it's an integer
extension String {
    var isInteger: Bool {
        return Int(self) != nil
    }
}

// Function to validate and parse command-line arguments
func parseArguments(args: [String]) throws -> (operands: [Int], operators: [String]) {
    var operands = [Int]()
    var operators = [String]()

    for arg in args {
        if arg.isInteger {
            if let operand = Int(arg), arg.isInteger {
                operands.append(operand)
            }
        } else if ["+", "-", "x", "/", "%"].contains(arg) {
            operators.append(arg)
        } else {
            throw CalculatorError.invalidOperator("Unsupported operator: \(arg)")
        }
    }

    // Allow expressions without any operators (single integer inputs)
    if operands.isEmpty || (operands.count != operators.count + 1 && !operators.isEmpty) {
        throw CalculatorError.invalidInput("Invalid expression. Ensure it's in the correct format.")
    }

    return (operands, operators)
}

// Starts the main execution here
var args = ProcessInfo.processInfo.arguments
args.removeFirst() // remove the name of the program

// Initialize a Calculator object
let calculator = Calculator();

do {
    let (operands, operators) = try parseArguments(args: args)
    let calculator = Calculator()

    // Placeholder for result, assuming a method evaluateExpression exists
    let result = try calculator.evaluateExpression(operands: operands, operators: operators)
    
    print(result)
} catch CalculatorError.invalidInput(let message) {
    print("Error: Invalid input. \(message)")
    exit(1)
} catch CalculatorError.divisionByZero {
    print("Error: Division by zero is not allowed.")
    exit(1)
} catch CalculatorError.invalidOperator(let message) {
    print("Error: \(message)")
    exit(1)
} catch CalculatorError.calculationError(let message) {
    print("Error: \(message)")
    exit(1)
} catch {
    print("An unexpected error occurred.")
    exit(1)
}
