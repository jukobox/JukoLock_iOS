//
//  LoginViewController.swift
//  JukoLock
//
//  Created by 김경호 on 5/2/24.
//

import UIKit

final class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    private let titleFont: UIFont = {
        let font = UIFont()
        
        return font
    }()
    
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
    
    private let myEmailLogin: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.layer.cornerRadius = 10
        button.titleLabel?.text = "내 이메일로 시작하기"
        button.titleLabel?.textColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let googleLogin: UIButton = {
        let button = UIButton()
        button.backgroundColor = .brown
        button.layer.cornerRadius = 10
        button.titleLabel?.text = "Google로 시작하기"
        button.titleLabel?.textColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let appleLogin: UIButton = {
        let button = UIButton()
        button.backgroundColor = .yellow
        button.layer.cornerRadius = 10
        button.titleLabel?.text = "Apple로 시작하기"
        button.titleLabel?.textColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    // MARK: - Init
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setUpLayout()
    }
    
}

// MARK: - UI Settings

extension LoginViewController {
    
    private func addViews() {
        [ firstTextTitle, secondTextTitle, thirdTextTitle, myEmailLogin, googleLogin, appleLogin].forEach {
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
            
            myEmailLogin.topAnchor.constraint(equalTo: thirdTextTitle.bottomAnchor, constant: 150),
            myEmailLogin.leadingAnchor.constraint(equalTo: thirdTextTitle.leadingAnchor),
            myEmailLogin.trailingAnchor.constraint(equalTo: thirdTextTitle.trailingAnchor),
            myEmailLogin.heightAnchor.constraint(equalToConstant: 50),
            
            googleLogin.topAnchor.constraint(equalTo: myEmailLogin.bottomAnchor, constant: 30),
            googleLogin.leadingAnchor.constraint(equalTo: myEmailLogin.leadingAnchor),
            googleLogin.trailingAnchor.constraint(equalTo: myEmailLogin.trailingAnchor),
            googleLogin.heightAnchor.constraint(equalToConstant: 50),
            
            appleLogin.topAnchor.constraint(equalTo: googleLogin.bottomAnchor, constant: 30),
            appleLogin.leadingAnchor.constraint(equalTo: googleLogin.leadingAnchor),
            appleLogin.trailingAnchor.constraint(equalTo: googleLogin.trailingAnchor),
            appleLogin.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setUpLayout() {
        addViews()
        setLayoutConstraints()
    }
}

// MARK: - Methos

extension LoginViewController {
    
}
