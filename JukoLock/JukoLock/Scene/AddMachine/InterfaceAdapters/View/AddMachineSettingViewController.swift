//
//  AddMachineSettingViewController.swift
//  JukoLock
//
//  Created by 김경호 on 9/22/24.
//

import Combine
import UIKit

final class AddMachineSettingViewController: UIViewController {
    
    // MARK: - Properties
    
    private var subscriptions: Set<AnyCancellable> = []
    private var viewModel: AddMachineViewModel
    private let inputSubject: PassthroughSubject<AddMachineViewModel.Input, Never> = .init()
    
    // MARK: - UI Components
    
    private let machineNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "기기 이름을 입력해주세요."
        textField.autocapitalizationType = .none
        textField.layer.cornerRadius = 5
        textField.layer.borderWidth = 1
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let groupSelectPicker: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        return pickerView
    }()
    
    private let addMachineSubmitButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.layer.cornerRadius = 10
        button.setTitle("완료", for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Init
    
    init(viewModel: AddMachineViewModel) {
        self.viewModel = viewModel
        machineNameTextField.text = viewModel.machineName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        setUpLayout()
        super.viewDidLoad()
    }
}

// MARK: - UI Settings

extension AddMachineSettingViewController {
    private func setUpLayout() {
        addViews()
        setLayoutConstraints()
        addTargets()
        
        groupSelectPicker.delegate = self
        groupSelectPicker.dataSource = self
        machineNameTextField.delegate = self
    }
    
    private func addViews() {
        [ machineNameTextField, groupSelectPicker, addMachineSubmitButton ].forEach {
            self.view.addSubview($0)
        }
    }
    
    private func addTargets() {
        self.addMachineSubmitButton.addTarget(self, action: #selector(addMachineSettingCompleteButtonTouched), for: .touchUpInside)
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            machineNameTextField.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 100),
            machineNameTextField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            machineNameTextField.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            machineNameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            groupSelectPicker.topAnchor.constraint(equalTo: self.machineNameTextField.bottomAnchor, constant: 10),
            groupSelectPicker.centerXAnchor.constraint(equalTo: self.machineNameTextField.centerXAnchor),
            
            addMachineSubmitButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            addMachineSubmitButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            addMachineSubmitButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            addMachineSubmitButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

// MARK: - Methos

extension AddMachineSettingViewController {
    @objc func addMachineSettingCompleteButtonTouched(_ sender: Any?) {
        self.dismiss(animated: true) {
            self.inputSubject.send(.addMachineSettingCompleted)
        }
    }
}

extension AddMachineSettingViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.viewModel.groupList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.viewModel.groupList[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        debugPrint(row)
        inputSubject.send(.groupSelected(selectedRow: row))
    }
}

extension AddMachineSettingViewController: UITextFieldDelegate {
    @objc func nameTextFieldDidChanged(_ sender: Any?) {
        guard let name = self.machineNameTextField.text else {
            return
        }
        
        inputSubject.send(.machineNameInput(name: name))
    }
}
