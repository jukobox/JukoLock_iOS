//
//  LoginViewController.swift
//  JukoLock
//
//  Created by 김경호 on 5/2/24.
//

import Combine
import UIKit

final class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    private var emailText: String?
    private var pwText: String?
    private var subscriptions: Set<AnyCancellable> = []
    private var viewModel: LoginViewModel
    private let inputSubject: PassthroughSubject<LoginViewModel.Input, Never> = .init()
    private let loginStateSubject: CurrentValueSubject<LoginState, Never>
    private var pwInvisibleState: Bool = true
    
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
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 10
        button.setTitle("Login", for: .normal)
        button.tintColor = UIColor.white
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("아이디가 없으신가요?", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.textAlignment = .left
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Init
    
    init(viewModel: LoginViewModel, loginStateSubject: CurrentValueSubject<LoginState, Never>) {
        self.viewModel = viewModel
        self.loginStateSubject = loginStateSubject
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        self.view.backgroundColor = .white
        setUpLayout()
        emailInputTextField.delegate = self
        pwInputTextField.delegate = self
    }
    
}

// MARK: - UI Settings

extension LoginViewController {
    
    private func addViews() {
        [ firstTextTitle, secondTextTitle, thirdTextTitle, emailTextLabel, emailInputTextField, passwordTextLabel, pwInputTextField, loginButton, emailValidationLabel, pwValidationLabel, signUpButton].forEach {
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
            
            emailTextLabel.topAnchor.constraint(equalTo: thirdTextTitle.bottomAnchor, constant: 100),
            emailTextLabel.leadingAnchor.constraint(equalTo: thirdTextTitle.leadingAnchor),
            emailTextLabel.trailingAnchor.constraint(equalTo: thirdTextTitle.trailingAnchor),
            
            emailInputTextField.topAnchor.constraint(equalTo: emailTextLabel.bottomAnchor),
            emailInputTextField.leadingAnchor.constraint(equalTo: emailTextLabel.leadingAnchor),
            emailInputTextField.trailingAnchor.constraint(equalTo: emailTextLabel.trailingAnchor),
            emailInputTextField.heightAnchor.constraint(equalToConstant: 50),
            
            emailValidationLabel.topAnchor.constraint(equalTo: emailInputTextField.bottomAnchor),
            emailValidationLabel.leadingAnchor.constraint(equalTo: emailInputTextField.leadingAnchor, constant: 10),
            emailValidationLabel.trailingAnchor.constraint(equalTo: emailInputTextField.trailingAnchor),
            
            passwordTextLabel.topAnchor.constraint(equalTo: emailInputTextField.bottomAnchor, constant: 20),
            passwordTextLabel.leadingAnchor.constraint(equalTo: emailInputTextField.leadingAnchor),
            passwordTextLabel.trailingAnchor.constraint(equalTo: emailInputTextField.trailingAnchor),
            
            pwInputTextField.topAnchor.constraint(equalTo: passwordTextLabel.bottomAnchor),
            pwInputTextField.leadingAnchor.constraint(equalTo: passwordTextLabel.leadingAnchor),
            pwInputTextField.trailingAnchor.constraint(equalTo: passwordTextLabel.trailingAnchor),
            pwInputTextField.heightAnchor.constraint(equalToConstant: 50),
            
            pwValidationLabel.topAnchor.constraint(equalTo: pwInputTextField.bottomAnchor),
            pwValidationLabel.leadingAnchor.constraint(equalTo: pwInputTextField.leadingAnchor, constant: 10),
            pwValidationLabel.trailingAnchor.constraint(equalTo: pwInputTextField.trailingAnchor),
            
            loginButton.topAnchor.constraint(equalTo: pwInputTextField.bottomAnchor, constant: 50),
            loginButton.leadingAnchor.constraint(equalTo: pwInputTextField.leadingAnchor),
            loginButton.trailingAnchor.constraint(equalTo: pwInputTextField.trailingAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            
            signUpButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 10),
            signUpButton.leadingAnchor.constraint(equalTo: loginButton.leadingAnchor),
            signUpButton.trailingAnchor.constraint(equalTo: loginButton.trailingAnchor)
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
        signUpButton.addTarget(self, action: #selector(signupButtonTouched), for: .touchUpInside)
    }
}

// MARK: - Bind
private extension LoginViewController {
    func bind() {
        let outputSubject = viewModel.transform(with: inputSubject.eraseToAnyPublisher())
        
        outputSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] output in
                switch output {
                case .loginCompleted:
                    self?.loginStateSubject.send(.loggedIn)
                case .loginFailed:
                    self?.loginFailAlert()
                case .loginError:
                    self?.loginErrorAlert()
                case let .emailValid(text):
                    self?.emailValidationLabel.text = text
                case let .pwValid(text):
                    self?.pwValidationLabel.text = text
                case .isLoginPossible:
                    self?.loginButton.isEnabled = true
                    self?.loginButton.backgroundColor = .blue
                case .isLoginImpossible:
                    self?.loginButton.isEnabled = false
                    self?.loginButton.backgroundColor = .lightGray
                }
            }
            .store(in: &subscriptions)
    }
}

// MARK: - Methos

extension LoginViewController {
    
    @objc func loginSubmitButtonTouched() {
        self.inputSubject.send(.loginButtonTouched)
    }
    
    @objc func signupButtonTouched() {
        let provider = APIProvider(session: URLSession.shared)
        let signUpUseCase = SignUpUseCase(provider: provider)
        let signUpViewModel = SignUpViewModel(signUpUseCase: signUpUseCase)
        let signViewController = SignUpViewController(viewModel: signUpViewModel)
        
        self.navigationController?.pushViewController(signViewController, animated: true)
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    @objc func emailTextFieldDidChanged(_ sender: Any?) {
        guard let email = self.emailInputTextField.text else {
            return
        }
        inputSubject.send(.emailInput(email: email))
    }
    
    @objc func pwTextFiledDidChanged(_ sender: Any?) {
        guard let pw = self.pwInputTextField.text else {
            return
        }
        inputSubject.send(.passwordInput(pw: pw))
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
    
    private func loginFailAlert() {
        let sheet = UIAlertController(title: "로그인 실패", message: "아이디나 비밀번호를 확인해주세요.", preferredStyle: .alert)
        sheet.addAction(UIAlertAction(title: "확인", style: .default))
        present(sheet, animated: true)
    }
    
    private func loginErrorAlert() {
        let sheet = UIAlertController(title: "로그인 실패", message: "네트워크 상태를 확인해주세요.", preferredStyle: .alert)
        sheet.addAction(UIAlertAction(title: "확인", style: .default))
        present(sheet, animated: true)
    }
}
