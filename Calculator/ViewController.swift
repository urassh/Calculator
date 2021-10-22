//
//  ViewController.swift
//  Calculator
//
//  Created by 浦山秀斗 on 2021/10/20.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var calculatorCollectionView: UICollectionView!
    @IBOutlet weak var calculatorHeightConstraint: NSLayoutConstraint!
    let numbers = [
        ["1","2","3","4"],
        ["1","2","3","4"],
        ["1","2","3","4"],
        ["1","2","3","4"],
        ["1","2","3","4"],
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calculatorCollectionView.delegate = self
        calculatorCollectionView.dataSource = self
        calculatorCollectionView.register(CalculatorViewCell.self, forCellWithReuseIdentifier: "sellId")
        //collectionViewの高さ調整
        calculatorHeightConstraint.constant = view.frame.width * 1.4
    }
    
    //ヘッダーの大きさを変更できる。
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: collectionView.frame.width, height: 10)
    }
    
    //セルの大きさ
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //隙間の分も考慮している。
        let width = (collectionView.frame.width - 3 * 10) / 4
        return .init(width: width, height: width)
    }
    
    //セルと隙間の調整
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    //セルの縦の数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        //print("numbers.countは\(numbers.count)")
        return numbers.count
    }
    
    //セルの横の数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //print("numbers[section].countは\(numbers[section].count)")
        return numbers[section].count
    }
    
    //セルの中身についての関数
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //結びつけたcollectionViewの変数とセルを結びつける。
        let cell = calculatorCollectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! CalculatorViewCell
        //cell.backgroundColor = .blue
        return cell
    }
    
    //セルの中身についてにクラス
    class CalculatorViewCell: UICollectionViewCell {
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            backgroundColor = .black
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
}

