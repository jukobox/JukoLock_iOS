//
//  LoginViewController.swift
//  JukoLock
//
//  Created by 김경호 on 5/2/24.
//

import UIKit

final class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    private var emailText: String?
    private var pwText: String?
    private var isValidEmailState: Bool = false {
        didSet(newState) {
            self.emailValidationLabel.text = newState ? "" : "Email이 유효하지 않습니다."
            self.isLoginPossible = isValidEmailState && isValidPWState
            debugPrint("email : ", newState)
        }
    }
    private var isValidPWState: Bool = false {
        didSet(newState) {
            self.pwValidationLabel.text = newState ? "" : "PW가 유효하지 않습니다."
            self.isLoginPossible = isValidEmailState && isValidPWState
            debugPrint("pw : ", newState)
        }
    }
    private var pwInvisibleState: Bool = true
    private var isLoginPossible: Bool = false {
        didSet(newState) {
            debugPrint("login Possible : ", newState)
            loginButton.isEnabled = newState
            loginButton.setTitleColor(newState ? .black : .white, for: .normal)
        }
    }
    
    // MARK: - UI Components
    
    private let firstTextTitle: UILabel = {
        let text = UILabel()
        text.text = "스마트하게"
        text.textAlignment = .left
        text.translatesAutoresizingMaskIntoConstraints = false
        
        text.font = UIFont.systemFont(ofSize: 50)
        
        return text
    }()
    
    private let secondTextTitle: UILabel = {
        let text = UILabel()
        text.text = "내 안전을"
        text.textAlignment = .right
        text.translatesAutoresizingMaskIntoConstraints = false
        
        text.font = UIFont.systemFont(ofSize: 50)
        
        return text
    }()
    
    private let thirdTextTitle: UILabel = {
        let text = UILabel()
        text.text = "관리하세요"
        text.textAlignment = .left
        text.translatesAutoresizingMaskIntoConstraints = false
        text.font = UIFont.systemFont(ofSize: 50)
        return text
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
    
    private let emailValidationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .red
        return label
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
    
    private let pwValidationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .red
        return label
    }()
    
    private let pwInputTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "PW를 입력해주세요."
        textField.isSecureTextEntry = true
        textField.autocapitalizationType = .none
        textField.layer.cornerRadius = 5
        textField.layer.borderWidth = 1
        textField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 8.0, height: 0.0))
        textField.leftViewMode = .always
        textField.rightViewMode = .always
        return textField
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .green
        button.layer.cornerRadius = 10
        button.setTitle("Login", for: .normal)
        button.tintColor = UIColor.white
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    // MARK: - Init
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setUpLayout()
        emailInputTextField.delegate = self
        pwInputTextField.delegate = self
    }
    
}

// MARK: - UI Settings

extension LoginViewController {
    
    private func addViews() {
        [ firstTextTitle, secondTextTitle, thirdTextTitle, emailInputTextField, pwInputTextField, loginButton, emailValidationLabel, pwValidationLabel].forEach {
            self.view.addSubview($0)
        }
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate ([
            firstTextTitle.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 80),
            firstTextTitle.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            firstTextTitle.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            
            secondTextTitle.topAnchor.constraint(equalTo: firstTextTitle.bottomAnchor),
            secondTextTitle.leadingAnchor.constraint(equalTo: firstTextTitle.leadingAnchor),
            secondTextTitle.trailingAnchor.constraint(equalTo: firstTextTitle.trailingAnchor),
            
            thirdTextTitle.topAnchor.constraint(equalTo: secondTextTitle.bottomAnchor),
            thirdTextTitle.leadingAnchor.constraint(equalTo: secondTextTitle.leadingAnchor),
            thirdTextTitle.trailingAnchor.constraint(equalTo: secondTextTitle.trailingAnchor),
            
            emailInputTextField.topAnchor.constraint(equalTo: thirdTextTitle.bottomAnchor, constant: 100),
            emailInputTextField.leadingAnchor.constraint(equalTo: thirdTextTitle.leadingAnchor),
            emailInputTextField.trailingAnchor.constraint(equalTo: thirdTextTitle.trailingAnchor),
            emailInputTextField.heightAnchor.constraint(equalToConstant: 50),
            
            emailValidationLabel.topAnchor.constraint(equalTo: emailInputTextField.bottomAnchor),
            emailValidationLabel.leadingAnchor.constraint(equalTo: emailInputTextField.leadingAnchor, constant: 10),
            emailValidationLabel.trailingAnchor.constraint(equalTo: emailInputTextField.trailingAnchor),
            
            pwInputTextField.topAnchor.constraint(equalTo: emailInputTextField.bottomAnchor, constant: 20),
            pwInputTextField.leadingAnchor.constraint(equalTo: emailInputTextField.leadingAnchor),
            pwInputTextField.trailingAnchor.constraint(equalTo: emailInputTextField.trailingAnchor),
            pwInputTextField.heightAnchor.constraint(equalToConstant: 50),
            
            pwValidationLabel.topAnchor.constraint(equalTo: pwInputTextField.bottomAnchor),
            pwValidationLabel.leadingAnchor.constraint(equalTo: pwInputTextField.leadingAnchor, constant: 10),
            pwValidationLabel.trailingAnchor.constraint(equalTo: pwInputTextField.trailingAnchor),
            
            loginButton.topAnchor.constraint(equalTo: pwInputTextField.bottomAnchor, constant: 50),
            loginButton.leadingAnchor.constraint(equalTo: pwInputTextField.leadingAnchor),
            loginButton.trailingAnchor.constraint(equalTo: pwInputTextField.trailingAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setUpLayout() {
        addViews()
        setLayoutConstraints()
        addTargets()
        pwInputTextField.rightView = pwInvisibleToogleButton
    }
    
    private func addTargets() {
        loginButton.addTarget(self, action: #selector(loginSubmitButtonTouched), for: .touchUpInside)
        emailInputTextField.addTarget(self, action: #selector(emailTextFieldDidChanged(_:)), for: .editingChanged)
        pwInputTextField.addTarget(self, action: #selector(pwTextFiledDidChanged(_:)), for: .editingChanged)
        pwInvisibleToogleButton.addTarget(self, action: #selector(changePWInvisibleState(_:)), for: .touchUpInside)
    }
}

// MARK: - Methos

extension LoginViewController {
    
    @objc func loginSubmitButtonTouched() {
        emailText = emailInputTextField.text
        pwText = pwInputTextField.text
        
        guard let email = emailInputTextField.text, let pw = pwInputTextField.text else { return }
        
        guard !email.isEmpty, !pw.isEmpty else {
            // TODO: - ID & PW 미입력 알러트 출력
            debugPrint("아이디와 비밀번호를 모두 입력해주세요.")
            return
        }
        
        guard isValidEmail(email) else {
            return
        }
        
        guard isValidPW(pw) else {
            return
        }
        
        // TODO: - Login 전송
        debugPrint("Login 전송")
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    // TODO: - 옵저버블 패턴 넣을려다가 꼬임 이 부분을 여기서 처리해주면 안될거 같음
    @objc func emailTextFieldDidChanged(_ sender: Any?) {
        guard let email = self.emailInputTextField.text, email != "" else {
            self.emailValidationLabel.text = ""
            return
        }
        
        isValidEmailState = isValidEmail(email)
    }
    
    @objc func pwTextFiledDidChanged(_ sender: Any?) {
        guard let pw = self.pwInputTextField.text, pw != "" else {
            self.pwValidationLabel.text = ""
            return
        }
        
        isValidPWState = isValidPW(pw)
    }
    
    @objc func changePWInvisibleState(_ sender: Any?) {
        pwInvisibleState.toggle()
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20)
        let image = pwInvisibleState ? UIImage(systemName: "eye.slash", withConfiguration: imageConfig) : UIImage(systemName: "eye", withConfiguration: imageConfig)
        pwInvisibleToogleButton.setImage(image, for: .normal)
        pwInputTextField.isSecureTextEntry = pwInvisibleState
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
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES[c] %@", emailRegex)

        return !email.isEmpty && emailPredicate.evaluate(with: email)
    }
    
    private func isValidPW(_ pw: String) -> Bool {
        let pwRegex = "^[A-Za-z0-9!_@$%^&+=]{8,20}$"
        let pwPredicate = NSPredicate(format: "SELF MATCHES[c] %@", pwRegex)

        return !pw.isEmpty && pwPredicate.evaluate(with: pw)
    }
}
