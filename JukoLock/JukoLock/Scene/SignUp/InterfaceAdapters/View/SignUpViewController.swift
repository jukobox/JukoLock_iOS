//
//  SignUpViewController.swift
//  JukoLock
//
//  Created by 김경호 on 5/28/24.
//

import Combine
import UIKit

final class SignUpViewController: UIViewController {
    // MARK: - Properties
    
    private var subscriptions: Set<AnyCancellable> = []
    private var viewModel: SignUpViewModel
    private let inputSubject: PassthroughSubject<SignUpViewModel.Input, Never> = .init()
    private var pwInvisibleState: Bool = false
    private var pwConfirmInvisibleState: Bool = false
    
    // MARK: - UI Components
    
    private let nameTextLabel: UILabel = {
        let label = UILabel()
        label.text = "이름"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let nameInputTextField: UITextField = {
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
    
    private let emailTextLabel: UILabel = {
        let label = UILabel()
        label.text = "이메일"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailInputTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Email을 입력해주세요."
        textField.autocapitalizationType = .none
        textField.keyboardType = .emailAddress
        textField.layer.cornerRadius = 5
        textField.layer.borderWidth = 1
        textField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 8.0, height: 0.0))
        textField.leftViewMode = .always
        return textField
    }()
    
    private let emailDuplicationCheckButton: UIButton = {
        let button = UIButton()
        button.setTitle("중복체크", for: .normal)
        button.backgroundColor = .lightGray
        button.isEnabled = false
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let emailValidationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .red
        return label
    }()
    
    private let passwordTextLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let passwordInputTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "8자 이상 비밀번호를 입력해주세요."
        textField.isSecureTextEntry = true
        textField.autocapitalizationType = .none
        textField.layer.cornerRadius = 5
        textField.layer.borderWidth = 1
        textField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 8.0, height: 0.0))
        textField.leftViewMode = .always
        textField.rightViewMode = .always
        return textField
    }()
    
    private let pwInvisibleToogleButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20)
        let image = UIImage(systemName: "eye.slash", withConfiguration: imageConfig)
        
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .black
        
        return button
    }()
    
    private let passwordCheckTextLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호 체크"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let pwValidationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .red
        return label
    }()
    
    private let passwordCheckInputTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "PW를 똑같이 입력해주세요."
        textField.isSecureTextEntry = true
        textField.autocapitalizationType = .none
        textField.layer.cornerRadius = 5
        textField.layer.borderWidth = 1
        textField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 8.0, height: 0.0))
        textField.leftViewMode = .always
        textField.rightViewMode = .always
        return textField
    }()
    
    private let pwConfirmInvisibleToogleButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20)
        let image = UIImage(systemName: "eye.slash", withConfiguration: imageConfig)
        
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .black
        
        return button
    }()
    
    private let pwCheckValidationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .red
        return label
    }()
    
    private let signUpCompleteButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.backgroundColor = .lightGray
        button.setTitle("회원가입", for: .normal)
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    // MARK: - Init
    
    init(viewModel: SignUpViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        setUpLayout()
        setUpKeyboardObserver()
        
        passwordInputTextField.rightView = pwInvisibleToogleButton
        passwordCheckInputTextField.rightView = pwConfirmInvisibleToogleButton
    }
}

// MARK: - UI Settings

extension SignUpViewController {
    
    private func setUpLayout() {
        addViews()
        setLayoutConstraints()
        addTargets()
        bind()
    }
    
    private func addViews() {
        [ nameTextLabel, nameInputTextField, emailTextLabel, emailInputTextField, emailDuplicationCheckButton, emailValidationLabel, passwordTextLabel, passwordInputTextField, pwValidationLabel, passwordCheckTextLabel, passwordCheckInputTextField, pwCheckValidationLabel, signUpCompleteButton ].forEach {
            self.view.addSubview($0)
        }
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate ([
            nameTextLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 100),
            nameTextLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            nameTextLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            
            nameInputTextField.topAnchor.constraint(equalTo: nameTextLabel.bottomAnchor),
            nameInputTextField.leadingAnchor.constraint(equalTo: nameTextLabel.leadingAnchor),
            nameInputTextField.trailingAnchor.constraint(equalTo: nameTextLabel.trailingAnchor),
            nameInputTextField.heightAnchor.constraint(equalToConstant: 50),
            
            emailTextLabel.topAnchor.constraint(equalTo: nameInputTextField.bottomAnchor, constant: 20),
            emailTextLabel.leadingAnchor.constraint(equalTo: nameInputTextField.leadingAnchor),
            emailTextLabel.trailingAnchor.constraint(equalTo: nameInputTextField.trailingAnchor),
            
            emailInputTextField.topAnchor.constraint(equalTo: emailTextLabel.bottomAnchor),
            emailInputTextField.leadingAnchor.constraint(equalTo: emailTextLabel.leadingAnchor),
            emailInputTextField.widthAnchor.constraint(equalToConstant: (self.view.frame.width - 20) / 3 * 2),
            emailInputTextField.heightAnchor.constraint(equalToConstant: 50),
            
            emailDuplicationCheckButton.topAnchor.constraint(equalTo: emailInputTextField.topAnchor),
            emailDuplicationCheckButton.leadingAnchor.constraint(equalTo: emailInputTextField.trailingAnchor, constant: 5),
            emailDuplicationCheckButton.trailingAnchor.constraint(equalTo: emailTextLabel.trailingAnchor),
            emailDuplicationCheckButton.heightAnchor.constraint(equalTo: emailInputTextField.heightAnchor),
            
            emailValidationLabel.topAnchor.constraint(equalTo: emailInputTextField.bottomAnchor),
            emailValidationLabel.leadingAnchor.constraint(equalTo: emailInputTextField.leadingAnchor),
            emailValidationLabel.trailingAnchor.constraint(equalTo: emailDuplicationCheckButton.trailingAnchor),
            
            passwordTextLabel.topAnchor.constraint(equalTo: emailInputTextField.bottomAnchor, constant: 20),
            passwordTextLabel.leadingAnchor.constraint(equalTo: emailInputTextField.leadingAnchor),
            passwordTextLabel.trailingAnchor.constraint(equalTo: emailValidationLabel.trailingAnchor),
            
            passwordInputTextField.topAnchor.constraint(equalTo: passwordTextLabel.bottomAnchor),
            passwordInputTextField.leadingAnchor.constraint(equalTo: passwordTextLabel.leadingAnchor),
            passwordInputTextField.trailingAnchor.constraint(equalTo: passwordTextLabel.trailingAnchor),
            passwordInputTextField.heightAnchor.constraint(equalToConstant: 50),
            
            pwValidationLabel.topAnchor.constraint(equalTo: passwordInputTextField.bottomAnchor),
            pwValidationLabel.leadingAnchor.constraint(equalTo: passwordInputTextField.leadingAnchor),
            pwValidationLabel.trailingAnchor.constraint(equalTo: passwordInputTextField.trailingAnchor),
            
            passwordCheckTextLabel.topAnchor.constraint(equalTo: passwordInputTextField.bottomAnchor, constant: 20),
            passwordCheckTextLabel.leadingAnchor.constraint(equalTo: passwordInputTextField.leadingAnchor),
            passwordCheckTextLabel.trailingAnchor.constraint(equalTo: passwordInputTextField.trailingAnchor),
            
            passwordCheckInputTextField.topAnchor.constraint(equalTo: passwordCheckTextLabel.bottomAnchor),
            passwordCheckInputTextField.leadingAnchor.constraint(equalTo: passwordCheckTextLabel.leadingAnchor),
            passwordCheckInputTextField.trailingAnchor.constraint(equalTo: passwordCheckTextLabel.trailingAnchor),
            passwordCheckInputTextField.heightAnchor.constraint(equalToConstant: 50),
            
            pwCheckValidationLabel.topAnchor.constraint(equalTo: passwordCheckInputTextField.bottomAnchor),
            pwCheckValidationLabel.leadingAnchor.constraint(equalTo: passwordCheckInputTextField.leadingAnchor),
            pwCheckValidationLabel.trailingAnchor.constraint(equalTo: passwordCheckInputTextField.trailingAnchor),
            
            signUpCompleteButton.topAnchor.constraint(equalTo: passwordCheckInputTextField.bottomAnchor, constant: 50),
            signUpCompleteButton.leadingAnchor.constraint(equalTo: passwordCheckInputTextField.leadingAnchor),
            signUpCompleteButton.trailingAnchor.constraint(equalTo: passwordCheckInputTextField.trailingAnchor),
            signUpCompleteButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func addTargets() {
        nameInputTextField.addTarget(self, action: #selector(nameTextFieldDidChanged), for: .editingChanged)
        emailInputTextField.addTarget(self, action: #selector(emailTextFieldDidChanged), for: .editingChanged)
        passwordInputTextField.addTarget(self, action: #selector(pwTextFieldDidChanged), for: .editingChanged)
        passwordCheckInputTextField.addTarget(self, action: #selector(pwCheckTextFieldDidChanged), for: .editingChanged)
        signUpCompleteButton.addTarget(self, action: #selector(signupSubmitButtonTouched), for: .touchUpInside)
        emailDuplicationCheckButton.addTarget(self, action: #selector(emailDuplicationCheckButtonTouched), for: .touchUpInside)
        pwInvisibleToogleButton.addTarget(self, action: #selector(changePWInvisibleState), for: .touchUpInside)
        pwConfirmInvisibleToogleButton.addTarget(self, action: #selector(changePWConfirmInvisibleState), for: .touchUpInside)
    }
}

// MARK: - Bind
private extension SignUpViewController {
    func bind() {
        let outputSubject = viewModel.transform(with: inputSubject.eraseToAnyPublisher())
        
        outputSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] output in
                switch output {
                case .emailIsValid:
                    self?.emailDuplicationCheckButton.isEnabled = true
                    self?.emailDuplicationCheckButton.backgroundColor = .blue
                    self?.emailValidationLabel.text = ""
                case .emailIsNotValid:
                    self?.emailDuplicationCheckButton.isEnabled = false
                    self?.emailDuplicationCheckButton.backgroundColor = .lightGray
                    self?.emailValidationLabel.textColor = .red
                    self?.emailValidationLabel.text = "Email이 유효하지 않습니다."
                case let .pwValid(text):
                    self?.pwValidationLabel.text = text
                case let .pwCheckValid(text):
                    self?.pwCheckValidationLabel.text = text
                case .isSignUpPossible:
                    self?.signUpCompleteButton.isEnabled = true
                    self?.signUpCompleteButton.backgroundColor = .blue
                case .isSignUpImpossible:
                    self?.signUpCompleteButton.isEnabled = false
                    self?.signUpCompleteButton.backgroundColor = .lightGray
                case .signUpCompleted:
                    self?.signupCompleted()
                case .signUpFailed:
                    self?.signupFailAlert()
                case .signUpError:
                    self?.signupErrorAlert()
                case .emailNotDuplication:
                    self?.emailNotDuplication()
                case .emailDuplication:
                    self?.emailDuplication()
                }
            }
            .store(in: &subscriptions)
    }
}

// MARK: - Methos

extension SignUpViewController {
    func setUpKeyboardObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc func keyboardWillShow() {
        view.frame.origin.y = -200
    }

    @objc func keyboardWillHide() {
        view.frame.origin.y = 0
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES[c] %@", emailRegex)

        return !email.isEmpty && emailPredicate.evaluate(with: email)
    }
    
    // TODO: Password Rule 제대로 안알려줌
    private func isValidPW(_ pw: String) -> Bool {
        let pwRegex = "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{8,50}"
        let pwPredicate = NSPredicate(format: "SELF MATCHES[c] %@", pwRegex)

        return !pw.isEmpty && pwPredicate.evaluate(with: pw)
    }
    
    private func emailDuplication() {
        let sheet = UIAlertController(title: "중복된 이메일입니다.", message: "다른 이메일을 입력해주세요.", preferredStyle: .alert)
        sheet.addAction(UIAlertAction(title: "확인", style: .default))
        present(sheet, animated: true)
    }
    
    private func emailNotDuplication() {
        self.emailDuplicationCheckButton.backgroundColor = .lightGray
        self.emailDuplicationCheckButton.isEnabled = false
        
        self.emailValidationLabel.textColor = .green
        self.emailValidationLabel.text = "인증되었습니다."
        
        let sheet = UIAlertController(title: "사용가능한 이메일입니다.", message: "", preferredStyle: .alert)
        sheet.addAction(UIAlertAction(title: "확인", style: .default))
        present(sheet, animated: true)
    }
    
    private func signupCompleted() {
        let sheet = UIAlertController(title: "회원가입 성공", message: "", preferredStyle: .alert)
        sheet.addAction(UIAlertAction(title: "확인", style: .default) { (action) in
            self.navigationController?.popViewController(animated: true)
        })
        present(sheet, animated: true)
    }
    
    private func signupFailAlert() {
        let sheet = UIAlertController(title: "회원가입 실패", message: "아이디나 비밀번호를 확인해주세요.", preferredStyle: .alert)
        sheet.addAction(UIAlertAction(title: "확인", style: .default))
        present(sheet, animated: true)
    }
    
    private func signupErrorAlert() {
        let sheet = UIAlertController(title: "회원가입 실패", message: "네트워크 상태를 확인해주세요.", preferredStyle: .alert)
        sheet.addAction(UIAlertAction(title: "확인", style: .default))
        present(sheet, animated: true)
    }
}

// MARK: - objc

extension SignUpViewController: UITextFieldDelegate {
    
    @objc func nameTextFieldDidChanged(_ sender: Any?) {
        guard let name = self.nameInputTextField.text else {
            return
        }
        inputSubject.send(.nameInput(name))
    }
    
    @objc func emailTextFieldDidChanged(_ sender: Any?) {
        self.emailDuplicationCheckButton.isEnabled = true
        self.emailDuplicationCheckButton.backgroundColor = .blue
        
        guard let email = self.emailInputTextField.text else {
            return
        }
        inputSubject.send(.emailInput(email))
    }
    
    @objc func pwTextFieldDidChanged(_ sender: Any?) {
        guard let pw = self.passwordInputTextField.text else {
            return
        }
        inputSubject.send(.passwordInput(pw))
    }
    
    @objc func pwCheckTextFieldDidChanged(_ sender: Any?) {
        guard let pwCheck = self.passwordCheckInputTextField.text else {
            return
        }
        inputSubject.send(.passwordCheckInput(pwCheck))
    }
    
    @objc func signupSubmitButtonTouched(_ sender: Any?) {
        self.inputSubject.send(.signUp)
    }
    
    @objc func emailDuplicationCheckButtonTouched(_ sender: Any?) {
        self.inputSubject.send(.emailDuplicationCheck)
    }
    
    @objc func changePWInvisibleState(_ sender: Any?) {
        pwInvisibleState.toggle()
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20)
        let image = pwInvisibleState ? UIImage(systemName: "eye.slash", withConfiguration: imageConfig) : UIImage(systemName: "eye", withConfiguration: imageConfig)
        pwInvisibleToogleButton.setImage(image, for: .normal)
        passwordInputTextField.isSecureTextEntry = pwInvisibleState
    }
    
    @objc func changePWConfirmInvisibleState(_ sender: Any?) {
        pwConfirmInvisibleState.toggle()
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20)
        let image = pwConfirmInvisibleState ? UIImage(systemName: "eye.slash", withConfiguration: imageConfig) : UIImage(systemName: "eye", withConfiguration: imageConfig)
        pwConfirmInvisibleToogleButton.setImage(image, for: .normal)
        passwordCheckInputTextField.isSecureTextEntry = pwConfirmInvisibleState
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if isBackSpace == -92 {
                return true
            }
        }
        guard textField.text!.count < 20 else { return false } // 20 글자로 제한
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
