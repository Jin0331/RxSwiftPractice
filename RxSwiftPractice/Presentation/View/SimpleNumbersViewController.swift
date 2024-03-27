//
//  SimpleNumbersViewController.swift
//  RxSwiftPractice
//
//  Created by JinwooLee on 3/27/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class SimpleNumbersViewController: BaseViewController {

    let disposeBag = DisposeBag()
    
    let textField1 = UITextField().then {
        $0.textAlignment = .right
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.black.cgColor
    }
    let textField2 = UITextField().then {
        $0.textAlignment = .right
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.black.cgColor
    }
    let textField3 = UITextField().then {
        $0.textAlignment = .right
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.black.cgColor
    }
    
    let addLabel = UILabel().then {
        $0.text = "+"
        $0.textAlignment = .right
        $0.font = .systemFont(ofSize: 22, weight: .heavy)
    }
    let resultLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Observable.combineLatest(textField1.rx.text.orEmpty, textField2.rx.text.orEmpty, textField3.rx.text.orEmpty) { textValue1, textValue2, textValue3 -> Int in
                return (Int(textValue1) ?? 0) + (Int(textValue2) ?? 0) + (Int(textValue3) ?? 0)
            }
            .map { $0.description }
            .bind(to: resultLabel.rx.text)
            .disposed(by: disposeBag)
        
    }
    
    override func configureHierarchy() {
        [textField1,textField2,textField3,addLabel,resultLabel]
            .forEach { view.addSubview($0)}
    }
    
    override func configureLayout() {
        textField1.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-100)
            make.horizontalEdges.equalToSuperview().inset(130)
            make.height.equalTo(40)
        }
        
        textField2.snp.makeConstraints { make in
            make.top.equalTo(textField1.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(textField1)
            make.height.equalTo(textField1)
        }
        
        textField3.snp.makeConstraints { make in
            make.top.equalTo(textField2.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(textField2)
            make.height.equalTo(textField2)
        }
        
        addLabel.snp.makeConstraints { make in
            make.centerY.equalTo(textField3)
            make.trailing.equalTo(textField3.snp.leading).offset(-5)
        }
        
        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(textField3.snp.bottom).offset(15)
            make.horizontalEdges.equalTo(textField3)
            make.height.equalTo(textField3)
        }
        
    }

}
