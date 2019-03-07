//
//  MatrixMultiplicationTests.swift
//  MatrixMultiplicationTests
//
//  Created by kassergey on 3/6/19.
//  Copyright © 2019 kassergey. All rights reserved.
//

import XCTest
@testable import MatrixMultiplication

class MatrixMultiplicationTests: XCTestCase {
    let matrixSize = 200
    var matrix1:Matrix = Matrix()
    var matrix2:Matrix = Matrix()
    
    override func setUp() {
        self.matrix1 = generateMatrixWithMatrixSize(matrixSize)
        self.matrix2 = generateMatrixWithMatrixSize(matrixSize)
    }
    
    private func generateMatrixWithMatrixSize(_ matrixSize: Int) -> [[Int]] {
        var generatedMatrix = Array<Array<Int>>(repeating: Array<Int>(repeating: 0,
                                                                      count: matrixSize),
                                                count: matrixSize)
        for i in 0..<matrixSize {
            for j in 0..<matrixSize {
                generatedMatrix[i][j] = Int.random(in: 0...100)
            }
        }
        return generatedMatrix
    }
    
    func testPerformanceExample() {
        self.measureMetrics([XCTPerformanceMetric.wallClockTime], automaticallyStartMeasuring: true) {
            let taskFinished = self.expectation(description: "finished")
            let mc = MatrixCalculator()
            mc.multiplyMatrices(matrix1: self.matrix1,
                                matrix2: self.matrix2, completion: { (_) in
                                    taskFinished.fulfill()
            })
            self.waitForExpectations(timeout: 500, handler: { (_) in
                self.stopMeasuring()
            })
        }
    }
    
    func testPerformanceExampleParallel() {
        self.measureMetrics([XCTPerformanceMetric.wallClockTime], automaticallyStartMeasuring: true) {
            let taskFinished = self.expectation(description: "finished")
            let mc = MatrixCalculator()
            mc.parallelMultiplyMatrices(matrix1: self.matrix1,
                                        matrix2: self.matrix2, completion: { (_) in
                                            taskFinished.fulfill()
            })
            self.waitForExpectations(timeout: 500, handler: { (_) in
                self.stopMeasuring()
            })
        }
    }
    
    func testResultParallel() {
        let matrix1 = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
        let matrix2 = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
        let expectedMatrix = [[30, 36, 42], [66, 81, 96], [102, 126, 150]]
        let mc = MatrixCalculator()
        mc.parallelMultiplyMatrices(matrix1: matrix1,
                                    matrix2: matrix2, completion: { (resultMatrix) in
                                        XCTAssertEqual(resultMatrix, expectedMatrix)
        })
    }
    
    func testResult() {
        let matrix1 = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
        let matrix2 = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
        let expectedMatrix = [[30, 36, 42], [66, 81, 96], [102, 126, 150]]
        let mc = MatrixCalculator()
        mc.multiplyMatrices(matrix1: matrix1,
                            matrix2: matrix2, completion: { (resultMatrix) in
                                XCTAssertEqual(resultMatrix, expectedMatrix)
        })
    }

}
