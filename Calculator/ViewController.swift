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
        ["C","%","$","÷"],
        ["7","8","9","×"],
        ["4","5","6","-"],
        ["1","2","3","+"],
        ["0",".","="],
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calculatorCollectionView.delegate = self
        calculatorCollectionView.dataSource = self
        calculatorCollectionView.register(CalculatorViewCell.self, forCellWithReuseIdentifier: "cellId")
        //collectionViewの高さ調整
        calculatorHeightConstraint.constant = view.frame.width * 1.4
        calculatorCollectionView.backgroundColor = .clear
        calculatorCollectionView.contentInset = .init(top: 0, left: 14, bottom: 0, right: 14)
        
        view.backgroundColor = .black
    }
    
    //ヘッダーの大きさを変更できる。
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: collectionView.frame.width, height: 10)
    }
    
    //セルの大きさ
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var width: CGFloat = 0
        width = ((collectionView.frame.width - 10) - 14 * 5) / 4
        let height  = width
        
        if indexPath.section == 4 && indexPath.row == 0 {
            width = width * 2 + 14 + 9
        }
        
        return .init(width: width, height: height)
    }
    
    //セルと隙間の調整
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 14
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
        cell.numberLabel.text = numbers[indexPath.section][indexPath.row]
        numbers[indexPath.section][indexPath.row].forEach{ (numberString) in
            if "0"..."9" ~= numberString || numberString.description == "."{
                cell.numberLabel.backgroundColor = .darkGray
            } else if numberString == "C" || numberString == "%" || numberString == "$"{
                cell.numberLabel.backgroundColor = UIColor.init(white: 1, alpha: 0.7)
                cell.numberLabel.textColor = .black
            }
        }
        
        return cell
    }
    
    //セルの中身についてにクラス
    class CalculatorViewCell: UICollectionViewCell {
        
        let numberLabel: UILabel = {
            let label = UILabel()
            label.textColor = .white
            label.textAlignment = .center
            label.text = "nil"
            label.font = .boldSystemFont(ofSize: 32)
            label.backgroundColor = .orange
            label.clipsToBounds = true
            return label
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            addSubview(numberLabel)
            numberLabel.frame.size = self.frame.size
            numberLabel.layer.cornerRadius = self.frame.height / 2
//            backgroundColor = .black
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
}

