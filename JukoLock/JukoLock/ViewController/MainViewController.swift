//
//  MainViewController.swift
//  JukoLock
//
//  Created by 김경호 on 5/3/24.
//

import UIKit

final class MainViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - UI Components
    
    private let logButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30)
        let image = UIImage(systemName: "text.bubble.fill", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let addMachineButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30)
        let image = UIImage(systemName: "plus.circle", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let controllMachineButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 150)
        let image = UIImage(systemName: "lock.fill", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let machineListScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
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

extension MainViewController {
    
    private func addViews() {
        [ logButton, addMachineButton, controllMachineButton, machineListScrollView].forEach {
            self.view.addSubview($0)
        }
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            addMachineButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 30),
            addMachineButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            addMachineButton.heightAnchor.constraint(equalToConstant: 50),
            addMachineButton.widthAnchor.constraint(equalToConstant: 50),
            
            logButton.topAnchor.constraint(equalTo: addMachineButton.topAnchor),
            logButton.trailingAnchor.constraint(equalTo: addMachineButton.leadingAnchor, constant: -10),
            logButton.heightAnchor.constraint(equalToConstant: 50),
            logButton.widthAnchor.constraint(equalToConstant: 50),
            
            controllMachineButton.topAnchor.constraint(equalTo: addMachineButton.bottomAnchor, constant: 20),
            controllMachineButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            controllMachineButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            controllMachineButton.heightAnchor.constraint(equalToConstant: 200),
            
            machineListScrollView.topAnchor.constraint(equalTo: controllMachineButton.bottomAnchor),
            machineListScrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            machineListScrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            machineListScrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setUpLayout() {
        addViews()
        setLayoutConstraints()
    }
}

// MARK: - Methos

extension MainViewController {
    
}
