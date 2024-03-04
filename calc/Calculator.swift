//
//  Calculator.swift
//  calc
//
//  Created by Sherlock Zhao on 04/3/24.
//  Copyright © 2024 Sherlock Zhao. All rights reserved.
//

import Foundation

class Calculator {
    
    var currentResult = 0;

    func add(no1: Int, no2: Int) -> Int {
        return no1 + no2;
    }
    
    func subtract(no1: Int, no2: Int) -> Int {
        return no1 - no2
    }
    
    func multiply(no1: Int, no2: Int) -> Int {
        return no1 * no2
    }
    
    func divide(no1: Int, no2: Int) throws -> Int {
        if no2 == 0 {
            throw CalculatorError.divisionByZero
        }
        return no1 / no2
    }
    
    func modulus(no1: Int, no2: Int) -> Int {
        return no1 % no2
    }
    
    // Evaluates an expression given arrays of operands and operators, respecting operator precedence and unary
    func evaluateExpression(operands: [Int], operators: [String]) throws -> Int {
        // Handle case with a single operand and no operators
        if operands.count == 1 && operators.isEmpty {
            return operands.first!  // Directly return the single integer input
        }
        
        // Handle case with a single operand and a unary operator
        if operands.count == 1 && operators.count == 1 {
            let op = operators.first!
            if op == "+" || op == "-" {
                return applyUnaryOperator(op, to: operands.first!)
            } else {
                throw CalculatorError.invalidOperator("Invalid operator for a single operand expression: \(op)")
            }
        }
        
        // Initialize mutable copies for processing
        var currentOperands = operands
        var currentOperators = operators
        
        // Process the expression respecting operator precedence
        try processOperators(&currentOperands, &currentOperators, ["x", "/", "%"])
        try processOperators(&currentOperands, &currentOperators, ["+", "-"])
        
        // After processing, there should be exactly one operand left, which is the result
        guard currentOperands.count == 1 else {
            throw CalculatorError.calculationError("Mismatch in operands and operators after evaluation.")
        }
        
        return currentOperands.first!
    }
    
    // Helper function to process specific operators
    private func processOperators(_ operands: inout [Int], _ operators: inout [String], _ targetOperators: [String]) throws {
        var index = 0
        while index < operators.count {
            if targetOperators.contains(operators[index]) {
                let result = try performOperation(op1: operands[index], op2: operands[index + 1], op: operators[index])
                operands.remove(at: index)
                operands[index] = result  // Replace the operand at index with the result
                operators.remove(at: index)  // Remove the operator that has been processed
            } else {
                index += 1  // Move to the next operator if the current one is not in the target list
            }
        }
    }
    
    // Performs a single operation and returns the result
    private func performOperation(op1: Int, op2: Int, op: String) throws -> Int {
        switch op {
        case "+":
            return add(no1: op1, no2: op2)
        case "-":
            return subtract(no1: op1, no2: op2)
        case "x", "*":
            return multiply(no1: op1, no2: op2)
        case "/":
            return try divide(no1: op1, no2: op2)
        case "%":
            return modulus(no1: op1, no2: op2)
        default:
            throw CalculatorError.invalidOperator("Unsupported operator: \(op)")
        }
    }
    
    // Method to apply unary operators
    private func applyUnaryOperator(_ op: String, to operand: Int) -> Int {
        switch op {
        case "+":
            return operand  // Unary + has no effect
        case "-":
            return -operand  // Unary - negates the operand
        default:
            return operand  // Should not happen, but included for completeness
        }
    }
}
