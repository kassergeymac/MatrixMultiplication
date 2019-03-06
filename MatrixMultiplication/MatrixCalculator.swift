//
//  MatrixCalculator.swift
//  MatrixMultiplication
//
//  Created by kassergey on 3/6/19.
//  Copyright © 2019 kassergey. All rights reserved.
//

import Foundation

typealias Matrix = [[Int]]

class MatrixCalculator {
    let dispatchGroup = DispatchGroup()

    func multiplyMatrices(matrix1: Matrix, matrix2: Matrix, completion: @escaping ((Matrix?) -> Void)) {
        guard matrix1.count == matrix2.count else {
            return
        }
        let matrixSize = matrix1.count
        var resultMatrix = Array<Array<Int>>(repeating: Array<Int>(repeating: 0,
                                                                   count: matrixSize),
                                             count: matrixSize)
        DispatchQueue.global(qos: .userInteractive).async {
            for i in 0..<matrixSize {
                for j in 0..<matrixSize {
                    var value = 0
                    for k in 0..<matrixSize {
                        value += matrix1[i][k] * matrix2[k][j]
                    }
                    resultMatrix[i][j] = value
                }
            }
            completion(resultMatrix)
        }
    }
    
    func parallelMultiplyMatrices(matrix1: Matrix, matrix2: Matrix, completion: @escaping ((Matrix?) -> Void)) {
        guard matrix1.count == matrix2.count else {
            return
        }
        let matrixSize = matrix1.count
        var resultMatrix = Array<Array<Int>>(repeating: Array<Int>(repeating: 0,
                                                                   count: matrixSize),
                                             count: matrixSize)
        for i in 0..<matrixSize {
            DispatchQueue.global(qos: .userInteractive).async(group: dispatchGroup) {
                resultMatrix[i] = self.partialMultiplyBlock(withI: i,
                                                            matrixSize: matrixSize,
                                                            for: matrix1,
                                                            for: matrix2)
            }
        }
        dispatchGroup.notify(queue: DispatchQueue.main) {
            completion(resultMatrix)
        }
    }
    
    private func partialMultiplyBlock(withI i: Int,
                                      matrixSize: Int,
                                      for matrix1:Matrix,
                                      for matrix2:Matrix) -> [Int] {
        var resultLine = Array<Int>(repeating: 0, count: matrixSize)
        for j in 0..<matrixSize {
            var value = 0
            for k in 0..<matrixSize {
                value += matrix1[i][k] * matrix2[k][j]
            }
            resultLine[j] = value
        }
        return resultLine
    }
    
}
