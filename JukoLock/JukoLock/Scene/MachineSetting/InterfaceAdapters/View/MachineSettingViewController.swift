//
//  MachineSettingViewController.swift
//  JukoLock
//
//  Created by 김경호 on 6/5/24.
//

import Combine
import UIKit

final class MachineSettingViewController: UIViewController {
    
    // MARK: - Properties
    
    private var subscriptions: Set<AnyCancellable> = []
//    private var viewModel: SignUpViewModel
//    private let inputSubject: PassthroughSubject<SignUpViewModel.Input, Never> = .init()
    
    // MARK: - UI Components
    // TODO: - adminButton 추가하기
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let scrollContentsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let machineImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .blue
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "별명  "
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "이름을 입력해주세요."
        textField.autocapitalizationType = .none
        textField.keyboardType = .emailAddress
        textField.layer.cornerRadius = 5
        textField.layer.borderWidth = 1
        textField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 8.0, height: 0.0))
        textField.leftViewMode = .always
        return textField
    }()
    
    private let adminLabel: UILabel = {
        let label = UILabel()
        label.text = "관리자 "
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let adminSelectedButton: UIButton = {
        let button = UIButton()
        button.setTitle("김경호", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호"
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "기계 비밀번호 입력해주세요."
        textField.autocapitalizationType = .none
        textField.keyboardType = .emailAddress
        textField.layer.cornerRadius = 5
        textField.layer.borderWidth = 1
        textField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 8.0, height: 0.0))
        textField.leftViewMode = .always
        return textField
    }()
    
    private let permissionSettingButton: UIButton = {
        let button = UIButton()
        button.setTitle("권한 설정", for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let logCheckButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그 확인", for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let machineDeleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("삭제하기", for: .normal)
        button.backgroundColor = .red
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        setUpLayout()
    }
}

// MARK: - UI Settings


extension MachineSettingViewController {
    
    private func setUpLayout() {
        addViews()
        setLayoutConstraints()
        addTargets()
        bind()
    }
    
    private func addViews() {
        self.view.addSubview(scrollView)
        scrollView.addSubview(scrollContentsView)
        
        [ machineImageView, nameLabel, nameTextField, adminLabel, adminSelectedButton, passwordLabel, passwordTextField, permissionSettingButton, logCheckButton, machineDeleteButton ].forEach {
            self.scrollContentsView.addSubview($0)
        }
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate ([
            scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            
            scrollContentsView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollContentsView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollContentsView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollContentsView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollContentsView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor),
            
            machineImageView.topAnchor.constraint(equalTo: scrollContentsView.topAnchor, constant: 20),
            machineImageView.centerXAnchor.constraint(equalTo: scrollContentsView.centerXAnchor),
            machineImageView.leadingAnchor.constraint(equalTo: scrollContentsView.leadingAnchor, constant: 20),
            machineImageView.trailingAnchor.constraint(equalTo: scrollContentsView.trailingAnchor, constant: -20),
            machineImageView.heightAnchor.constraint(equalToConstant: self.view.frame.width - 50),
            
            nameLabel.topAnchor.constraint(equalTo: machineImageView.bottomAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: self.machineImageView.leadingAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 50),
            nameLabel.widthAnchor.constraint(equalToConstant: 80),
            
            nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor),
            nameTextField.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 10),
            nameTextField.trailingAnchor.constraint(equalTo: scrollContentsView.trailingAnchor, constant: -20),
            nameTextField.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            
            adminLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            adminLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            adminLabel.heightAnchor.constraint(equalToConstant: 50),
            adminLabel.widthAnchor.constraint(equalToConstant: 80),
            
            adminSelectedButton.topAnchor.constraint(equalTo: adminLabel.topAnchor),
            adminSelectedButton.leadingAnchor.constraint(equalTo: adminLabel.trailingAnchor, constant: 10),
            adminSelectedButton.trailingAnchor.constraint(equalTo: scrollContentsView.trailingAnchor, constant: -20),
            adminSelectedButton.bottomAnchor.constraint(equalTo: adminLabel.bottomAnchor),
            
            passwordLabel.topAnchor.constraint(equalTo: adminLabel.bottomAnchor, constant: 10),
            passwordLabel.leadingAnchor.constraint(equalTo: adminLabel.leadingAnchor),
            passwordLabel.heightAnchor.constraint(equalToConstant: 50),
            passwordLabel.widthAnchor.constraint(equalToConstant: 80),
            
            passwordTextField.topAnchor.constraint(equalTo: passwordLabel.topAnchor),
            passwordTextField.leadingAnchor.constraint(equalTo: passwordLabel.trailingAnchor, constant: 10),
            passwordTextField.trailingAnchor.constraint(equalTo: scrollContentsView.trailingAnchor,constant: -20),
            passwordTextField.bottomAnchor.constraint(equalTo: passwordLabel.bottomAnchor),
            
            permissionSettingButton.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 30),
            permissionSettingButton.leadingAnchor.constraint(equalTo: scrollContentsView.leadingAnchor, constant: 20),
            permissionSettingButton.trailingAnchor.constraint(equalTo: scrollContentsView.trailingAnchor, constant: -20),
            permissionSettingButton.heightAnchor.constraint(equalToConstant: 50),
            
            logCheckButton.topAnchor.constraint(equalTo: permissionSettingButton.bottomAnchor, constant: 20),
            logCheckButton.leadingAnchor.constraint(equalTo: scrollContentsView.leadingAnchor, constant: 20),
            logCheckButton.trailingAnchor.constraint(equalTo: scrollContentsView.trailingAnchor, constant: -20),
            logCheckButton.heightAnchor.constraint(equalToConstant: 50),
            
            machineDeleteButton.topAnchor.constraint(equalTo: logCheckButton.bottomAnchor, constant: 20),
            machineDeleteButton.leadingAnchor.constraint(equalTo: scrollContentsView.leadingAnchor, constant: 20),
            machineDeleteButton.trailingAnchor.constraint(equalTo: scrollContentsView.trailingAnchor, constant: -20),
            machineDeleteButton.bottomAnchor.constraint(equalTo: scrollContentsView.bottomAnchor),
            machineDeleteButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func addTargets() {
//        nameInputTextField.addTarget(self, action: #selector(nameTextFieldDidChanged), for: .editingChanged)
//        emailInputTextField.addTarget(self, action: #selector(emailTextFieldDidChanged), for: .editingChanged)
//        passwordInputTextField.addTarget(self, action: #selector(pwTextFieldDidChanged), for: .editingChanged)
//        passwordCheckInputTextField.addTarget(self, action: #selector(pwCheckTextFieldDidChanged), for: .editingChanged)
//        signUpCompleteButton.addTarget(self, action: #selector(signupSubmitButtonTouched), for: .touchUpInside)
//        emailDuplicationCheckButton.addTarget(self, action: #selector(emailDuplicationCheckButtonTouched), for: .touchUpInside)
    }
}

// MARK: - Bind
private extension MachineSettingViewController {
    func bind() {
//        let outputSubject = viewModel.transform(with: inputSubject.eraseToAnyPublisher())
        
//        outputSubject
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] output in
//                switch output {
//                case let .nameValid(text):
//                    debugPrint("name : ", text)
//                case let .emailValid(text):
//                    self?.emailValidationLabel.textColor = .red
//                    self?.emailValidationLabel.text = text
//                case let .pwValid(text):
//                    self?.pwValidationLabel.text = text
//                case let .pwCheckValid(text):
//                    self?.pwCheckValidationLabel.text = text
//                case .isSignUpPossible:
//                    self?.signUpCompleteButton.isEnabled = true
//                    self?.signUpCompleteButton.backgroundColor = .blue
//                case .isSignUpImpossible:
//                    self?.signUpCompleteButton.isEnabled = false
//                    self?.signUpCompleteButton.backgroundColor = .lightGray
//                case .signUpCompleted:
//                    self?.signupCompleted()
//                case .signUpFailed:
//                    self?.signupFailAlert()
//                case .signUpError:
//                    self?.signupErrorAlert()
//                case .emailNotDuplication:
//                    self?.emailNotDuplication()
//                case .emailDuplication:
//                    self?.emailDuplication()
//                }
//            }
//            .store(in: &subscriptions)
    }
}

// MARK: - Methos

extension MachineSettingViewController {
    
}

// MARK: - objc

//extension MachineSettingViewController: UITextFieldDelegate {
//
//    @objc func nameTextFieldDidChanged(_ sender: Any?) {
//        guard let name = self.nameInputTextField.text else {
//            return
//        }
//        inputSubject.send(.nameInput(name))
//    }
//
//    @objc func emailTextFieldDidChanged(_ sender: Any?) {
//        self.emailDuplicationCheckButton.isEnabled = true
//        self.emailDuplicationCheckButton.backgroundColor = .blue
//
//        guard let email = self.emailInputTextField.text else {
//            return
//        }
//        inputSubject.send(.emailInput(email))
//    }
//
//    @objc func pwTextFieldDidChanged(_ sender: Any?) {
//        guard let pw = self.passwordInputTextField.text else {
//            return
//        }
//        inputSubject.send(.passwordInput(pw))
//    }
//
//    @objc func pwCheckTextFieldDidChanged(_ sender: Any?) {
//        guard let pwCheck = self.passwordCheckInputTextField.text else {
//            return
//        }
//        inputSubject.send(.passwordCheckInput(pwCheck))
//    }
//
//    @objc func signupSubmitButtonTouched(_ sender: Any?) {
//        self.inputSubject.send(.signUp)
//    }
//
//    @objc func emailDuplicationCheckButtonTouched(_ sender: Any?) {
//        self.inputSubject.send(.emailDuplicationCheck)
//    }
//
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if let char = string.cString(using: String.Encoding.utf8) {
//            let isBackSpace = strcmp(char, "\\b")
//            if isBackSpace == -92 {
//                return true
//            }
//        }
//        guard textField.text!.count < 20 else { return false } // 20 글자로 제한
//        return true
//    }
//}
