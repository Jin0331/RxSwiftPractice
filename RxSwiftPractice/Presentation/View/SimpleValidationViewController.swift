//
//  SimpleValidationViewController.swift
//  RxSwiftPractice
//
//  Created by JinwooLee on 3/27/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class SimpleValidationViewController: BaseViewController {

    let minimalUsernameLength = 5
    let minimalPasswordLength = 5
    let disposeBag = DisposeBag()
    
    let usernameOutlet = UITextField()
    let usernameValidOutlet = UILabel()
    let passwordOutlet = UITextField()
    let passwordValidOutlet = UILabel()
    let doSomethingOutlet = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        usernameValidOutlet.text = "Username has to be at least \(minimalUsernameLength) characters"
        passwordValidOutlet.text = "Password has to be at least \(minimalPasswordLength) characters"
        
        let usernameValid = usernameOutlet.rx.text.orEmpty
            .map { [self] in $0.count >= minimalUsernameLength }
            .share(replay: 1) // without this map would be executed once for each binding, rx is stateless by default

        let passwordValid = passwordOutlet.rx.text.orEmpty
            .map { [self] in $0.count >= minimalPasswordLength }
            .share(replay: 1)

        let everythingValid = Observable.combineLatest(usernameValid, passwordValid) { $0 && $1 }
            .share(replay: 1)
        
        usernameValid
            .bind(to: passwordOutlet.rx.isEnabled)
            .disposed(by: disposeBag)

        usernameValid
            .bind(to: usernameValidOutlet.rx.isHidden)
            .disposed(by: disposeBag)

        passwordValid
            .bind(to: passwordValidOutlet.rx.isHidden)
            .disposed(by: disposeBag)

        everythingValid
            .bind(to: doSomethingOutlet.rx.isEnabled)
            .disposed(by: disposeBag)

        doSomethingOutlet.rx.tap
            .subscribe(onNext: { [weak self] _ in self?.showAlert() })
            .disposed(by: disposeBag)
     
    }
    
    func showAlert() {
        let alert = UIAlertController(
            title: "RxExample",
            message: "This is wonderful",
            preferredStyle: .alert
        )
        let defaultAction = UIAlertAction(title: "Ok",
                                          style: .default,
                                          handler: nil)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
    
    override func configureHierarchy() {
        [usernameOutlet, usernameValidOutlet, passwordOutlet, passwordValidOutlet, doSomethingOutlet].forEach{ view.addSubview($0) }
    }
    
    override func configureLayout() {
        usernameOutlet.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        
        usernameValidOutlet.snp.makeConstraints { make in
            make.top.equalTo(usernameOutlet.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(usernameOutlet)
            make.height.equalTo(usernameOutlet)
        }
        passwordOutlet.snp.makeConstraints { make in
            make.top.equalTo(usernameValidOutlet.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(usernameValidOutlet)
            make.height.equalTo(usernameValidOutlet)
        }
        passwordValidOutlet.snp.makeConstraints { make in
            make.top.equalTo(passwordOutlet.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(passwordOutlet)
            make.height.equalTo(passwordOutlet)
        }
        doSomethingOutlet.snp.makeConstraints { make in
            make.top.equalTo(passwordValidOutlet.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(passwordValidOutlet)
            make.height.equalTo(passwordValidOutlet)
        }
        
    }
    

}
