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
            DispatchQueue.main.async {
                completion(resultMatrix)
            }
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
        let resultMatrixQueue = DispatchQueue(label: "com.kassergey.matrixCalculator.resultMatrix")
        let dispatchGroup = DispatchGroup()
        let threads = 5
        let partialMatrixSize = Int(matrixSize/threads)
        for z in 0..<threads {
            DispatchQueue.global(qos: .userInteractive).async(group: dispatchGroup) {
                for i in (z*partialMatrixSize)..<((z+1)*partialMatrixSize) {
                    let local_i = i
                    var resultMatrixLine = Array<Int>(repeating: 0,
                                                      count: matrixSize)
                    for j in 0..<matrixSize {
                        var value = 0
                        for k in 0..<matrixSize {
                            value += matrix1[local_i][k] * matrix2[k][j]
                        }
                        resultMatrixLine[j] = value
                    }
                    resultMatrixQueue.async(group: dispatchGroup,
                                            flags: .barrier,
                                            execute: {
                                                resultMatrix[local_i] = resultMatrixLine
                    })
                }
            }
        }
        dispatchGroup.notify(queue: DispatchQueue.main) {
            completion(resultMatrix)
        }
    }
    
}
