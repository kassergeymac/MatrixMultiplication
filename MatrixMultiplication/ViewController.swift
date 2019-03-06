//
//  ViewController.swift
//  MatrixMultiplication
//
//  Created by kassergey on 3/6/19.
//  Copyright © 2019 kassergey. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tfMatrixSize: UITextField!
    @IBOutlet weak var lblStartTime: UILabel!
    @IBOutlet weak var lblEndTime: UILabel!
    @IBOutlet weak var lblDurationSeconds: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func onTouchUpMultiplicate(_ sender: Any) {
        let matrixSize = Int(tfMatrixSize.text ?? "0") ?? 0
        let matrix1 = self.generateMatrixWithMatrixSize(matrixSize)
        let matrix2 = self.generateMatrixWithMatrixSize(matrixSize)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let startDate = Date()
        self.lblStartTime.text = dateFormatter.string(from: startDate)
        MatrixCalculator().multiplyMatrices(matrix1: matrix1,
                                            matrix2: matrix2) { [weak self]_ in
                                                let endDate = Date()
                                                self?.lblEndTime.text = dateFormatter.string(from: endDate)
                                                self?.lblDurationSeconds.text = String(endDate.timeIntervalSince1970-startDate.timeIntervalSince1970)
        }
    }
    
    @IBAction func onTouchUpMultiplicateParallel(_ sender: Any) {
        let matrixSize = Int(tfMatrixSize.text ?? "0") ?? 0
        let matrix1 = self.generateMatrixWithMatrixSize(matrixSize)
        let matrix2 = self.generateMatrixWithMatrixSize(matrixSize)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let startDate = Date()
        self.lblStartTime.text = dateFormatter.string(from: startDate)
        MatrixCalculator().parallelMultiplyMatrices(matrix1: matrix1,
                                                    matrix2: matrix2) { [weak self]_ in
                                                        let endDate = Date()
                                                        self?.lblEndTime.text = dateFormatter.string(from: endDate)
                                                        self?.lblDurationSeconds.text = String(endDate.timeIntervalSince1970-startDate.timeIntervalSince1970)
        }
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
}

