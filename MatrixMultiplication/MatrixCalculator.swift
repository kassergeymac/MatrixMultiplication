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
        let resultMatrixQueue = DispatchQueue(label: "com.kassergey.matrixCalculator.resultMatrix", attributes: .concurrent)
        for i in 0..<matrixSize {
            DispatchQueue.global(qos: .userInteractive).async {
                let local_i = i
                for j in 0..<matrixSize {
                    var value = 0
                    for k in 0..<matrixSize {
                        value += matrix1[local_i][k] * matrix2[k][j]
                    }
                    //this is for fixing crash
                    resultMatrixQueue.async(group: self.dispatchGroup,
                                            qos: .userInteractive,
                                            flags: .barrier,
                                            execute: {
                                                resultMatrix[local_i][j] = value
                    })
                }
            }
        }
        dispatchGroup.notify(queue: DispatchQueue.main) {
            completion(resultMatrix)
        }
    }
    
}
