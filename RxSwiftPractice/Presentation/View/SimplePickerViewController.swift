//
//  SimplePickerViewController.swift
//  RxSwiftPractice
//
//  Created by JinwooLee on 3/27/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class SimplePickerViewController: BaseViewController {

    let pickerView1 = UIPickerView().then {
        $0.backgroundColor = .clear
    }
    let pickerView2 = UIPickerView().then {
        $0.backgroundColor = .clear
    }
    let pickerView3 = UIPickerView().then {
        $0.backgroundColor = .clear
    }
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        Observable.just([1, 2, 3])
            .bind(to: pickerView1.rx.itemTitles) { _, item in
                return "\(item)"
            }
            .disposed(by: disposeBag)
        
        pickerView1.rx.modelSelected(Int.self)
            .subscribe(onNext: { models in
                print("models selected 1: \(models)")
            })
            .disposed(by: disposeBag)
        
        Observable.just([1, 2, 3])
            .bind(to: pickerView2.rx.itemAttributedTitles) { _, item in
                return NSAttributedString(string: "\(item)",
                                          attributes: [
                                            NSAttributedString.Key.foregroundColor: UIColor.cyan,
                                            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.double.rawValue
                                        ])
            }
            .disposed(by: disposeBag)
        
        pickerView2.rx.modelSelected(Int.self)
            .subscribe(onNext: { models in
                print("models selected 2: \(models)")
            })
            .disposed(by: disposeBag)
        
        Observable.just([UIColor.red, UIColor.green, UIColor.blue])
            .bind(to: pickerView3.rx.items) { _, item, _ in
                let view = UIView()
                view.backgroundColor = item
                
                return view
            }
            .disposed(by: disposeBag)
        
        pickerView3.rx.modelSelected(UIColor.self)
            .subscribe(onNext: { models in
                print("models selected 3: \(models)")
            })
            .disposed(by: disposeBag)
            
        
    }
    
    override func configureHierarchy() {
        view.addSubview(pickerView1)
        view.addSubview(pickerView2)
        view.addSubview(pickerView3)
    }
    
    override func configureLayout() {
        pickerView1.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.height / 3)
        }
        
        pickerView2.snp.makeConstraints { make in
            make.top.equalTo(pickerView1.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.height / 3)
        }
        
        pickerView3.snp.makeConstraints { make in
            make.top.equalTo(pickerView2.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.height / 3)
        }

    }

}
