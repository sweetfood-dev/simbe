//
//  CalcuratorBrain.swift
//  simbe
//
//  Created by 권지수 on 2020/11/07.
//

import Foundation

class CalcuratorBrain {
    
    private var accumulator = 0
    
    func setOperand(operand: Int){
        accumulator = operand
    }
    
    var operation: Dictionary<String, Operation> = [
        "+" : Operation.BinaryOperation({$0 + $1}),
        "-" : Operation.BinaryOperation({$0 - $1}),
        "*" : Operation.BinaryOperation({$0 * $1}),
        "/" : Operation.BinaryOperation({$0 / $1}),
        "=" : Operation.Equals
    ]
    enum Operation {
        case BinaryOperation((Int, Int) -> (Int))
        case Equals
    }
    
    func performOperation(symbol: String){ // 실제 연산 수행
        if let operation = operation[symbol] {
            switch operation {
            case .BinaryOperation(let funcion):
                binaryOperation()
                info = BinaryOperationInfo(binaryFunction: funcion, firstOperand: accumulator)
            case .Equals:
                binaryOperation()
            }
        }
    }
    
    private func binaryOperation(){
        if info != nil {
            accumulator = info!.binaryFunction(info!.firstOperand, accumulator)
            info = nil
        }
    }
    
    private var info: BinaryOperationInfo?
    
    struct BinaryOperationInfo {
        var binaryFunction: (Int, Int) -> Int
        var firstOperand: Int
    }
    var result: Int {
        get {
            return accumulator
        }
    }
}
