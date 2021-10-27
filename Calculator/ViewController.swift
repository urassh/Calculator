//
//  ViewController.swift
//  Calculator
//
//  Created by 浦山秀斗 on 2021/10/20.
//
import UIKit

class ViewController: UIViewController {

    enum CalculateStatus {
        case none, plus, minus, multiplication, division
    }

    var calculateStatus: CalculateStatus = .none
    var firstNumber = ""
    var secoundNumber = ""

    let numbers = [
        ["C","%","$","÷"],
        ["7","8","9","×"],
        ["4","5","6","-"],
        ["1","2","3","+"],
        ["0",".","="],
    ]

    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var calculatorCollectionView: UICollectionView!
    @IBOutlet weak var calculatorHeightConstraint: NSLayoutConstraint!

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
}

extension ViewController:  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
            //数字の部分の背景色はdarkGrayに指定する。
            if "0"..."9" ~= numberString || numberString.description == "."{
                cell.numberLabel.backgroundColor = .darkGray
            //"C", "%", "$" の部分は明るい灰色にする。
            } else if numberString == "C" || numberString == "%" || numberString == "$"{
                cell.numberLabel.backgroundColor = UIColor.init(white: 1, alpha: 0.7)
                cell.numberLabel.textColor = .black
            }
        }
        return cell
    }

    //セルがクリックされたときの処理
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let number = numbers[indexPath.section][indexPath.row]

        switch calculateStatus {
        case .none:
            switch number {
            case "0"..."9":
                firstNumber += number
                numberLabel.text = firstNumber
                if firstNumber.hasPrefix("0"){
                    firstNumber = ""
                }
            case ".":
                if !confirmIncludeDecimalPoint(numberString: firstNumber) {
                    firstNumber += number
                    numberLabel.text = firstNumber
                }
            case "+":
                calculateStatus = .plus
            case "-":
                calculateStatus = .minus
            case "×":
                calculateStatus = .multiplication
            case "÷":
                calculateStatus = .division
            case "C":
                clear()
            default:
                break
            }
        case .plus, .minus, .multiplication, .division:
            switch number {
            case "0"..."9":
                secoundNumber += number
                numberLabel.text = secoundNumber
                if firstNumber.hasPrefix("0"){
                    firstNumber = ""
                }
            case ".":
                if !confirmIncludeDecimalPoint(numberString: secoundNumber) {
                    secoundNumber += number
                    numberLabel.text = secoundNumber
                }
            case "=":
                let firstNum = Double(firstNumber) ?? 0
                let secoundNum = Double(secoundNumber) ?? 0
                var resultString: String?

                switch calculateStatus {
                case .plus:
                    resultString = String(firstNum + secoundNum)
                    numberLabel.text = resultString
                case .minus:
                    resultString = String(firstNum - secoundNum)
                    numberLabel.text = resultString
                case .multiplication:
                    resultString = String(firstNum * secoundNum)
                    numberLabel.text = resultString
                case .division:
                    resultString = String(firstNum / secoundNum)
                    numberLabel.text = resultString
                default:
                    break
                }
                
                if let result = resultString, result.hasSuffix(".0") {
                    resultString = result.replacingOccurrences(of: ".0", with: "")
                }
                numberLabel.text = resultString
                firstNumber = ""
                secoundNumber = ""
                
                firstNumber += resultString ?? ""
                calculateStatus = .none
            case "C":
                clear()
            default:
                break
            }
        }
    }
    //"C"クリアボタンが押されたときの処理
    private func clear() {
        firstNumber = ""
        secoundNumber = ""
        numberLabel.text = "0"
        calculateStatus = .none
    }
    
    private func confirmIncludeDecimalPoint (numberString: String) -> Bool{
        if numberString.range(of: ".") !=  nil || numberString.count == 0 {
            return true
        } else {
            return false
        }
    }
}
//セルの中身についてにクラス
class CalculatorViewCell: UICollectionViewCell {
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                self.numberLabel.alpha = 0.3
            } else {
                self.numberLabel.alpha = 1
            }
        }
    }

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
