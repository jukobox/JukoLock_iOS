//
//  SelectedGroupPageViewController.swift
//  JukoLock
//
//  Created by 김경호 on 9/8/24.
//

import Combine
import UIKit

final class SelectedGroupPageViewController: UIViewController {
    
    // MARK: - Properties
    
    private var subscriptions: Set<AnyCancellable> = []
    private var viewModel: SelectedGroupPageViewModel
    private let inputSubject: PassthroughSubject<SelectedGroupPageViewModel.Input, Never> = .init()
    
    // MARK: - UI Components
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.keyboardDismissMode = .onDrag
        
        return scrollView
    }()
    
    private let scrollContentsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let groupNameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let addEmailInputTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "추가할 이메일을 입력해주세요."
        textField.autocapitalizationType = .none
        textField.layer.cornerRadius = 5
        textField.layer.borderWidth = 1
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
        textField.leftViewMode = .always
        
        return textField
    }()
    
    private let addEmailButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .lightGray
        button.isEnabled = false
        button.layer.cornerRadius = 10
        button.setTitle("추가", for: .normal)
        button.tintColor = UIColor.white
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let groupUserListTableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.cornerRadius = 5
        tableView.layer.borderWidth = 1
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    // MARK: - Init
    
    init(viewModel: SelectedGroupPageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        groupUserListTableView.delegate = self
        groupUserListTableView.dataSource = self
        groupUserListTableView.register(GroupListCell.self, forCellReuseIdentifier: "GroupListCell")
        setUpLayout()
        inputSubject.send(.getUserList)
        scrollEditingEnd()
    }
    
}

// MARK: - UI Settings

extension SelectedGroupPageViewController {
    
    private func setUpLayout() {
        self.view.backgroundColor = .white
        addViews()
        setLayoutConstraints()
        bind()
        addTargets()
    }
    
    private func addViews() {
        self.view.addSubview(scrollView)
        scrollView.addSubview(scrollContentsView)
        [ groupNameLabel, addEmailInputTextField, addEmailButton, groupUserListTableView ].forEach {
            scrollContentsView.addSubview($0)
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
            scrollContentsView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            scrollContentsView.heightAnchor.constraint(equalToConstant: 800),
            
            groupNameLabel.topAnchor.constraint(equalTo: scrollContentsView.topAnchor, constant: 10),
            groupNameLabel.leadingAnchor.constraint(equalTo: scrollContentsView.leadingAnchor, constant: 10),
            groupNameLabel.trailingAnchor.constraint(equalTo: scrollContentsView.trailingAnchor, constant: -10),
            groupNameLabel.heightAnchor.constraint(equalToConstant: 50),
            
            addEmailInputTextField.topAnchor.constraint(equalTo: groupNameLabel.bottomAnchor, constant: 10),
            addEmailInputTextField.leadingAnchor.constraint(equalTo: scrollContentsView.leadingAnchor, constant: 10),
            addEmailInputTextField.widthAnchor.constraint(equalToConstant: 300),
            addEmailInputTextField.heightAnchor.constraint(equalToConstant: 50),
            
            addEmailButton.topAnchor.constraint(equalTo: groupNameLabel.bottomAnchor, constant: 10),
            addEmailButton.leadingAnchor.constraint(equalTo: addEmailInputTextField.trailingAnchor, constant: 10),
            addEmailButton.trailingAnchor.constraint(equalTo: scrollContentsView.trailingAnchor, constant: -10),
            addEmailButton.heightAnchor.constraint(equalToConstant: 50),
            
            groupUserListTableView.topAnchor.constraint(equalTo: addEmailButton.bottomAnchor, constant: 10),
            groupUserListTableView.leadingAnchor.constraint(equalTo: scrollContentsView.leadingAnchor, constant: 10),
            groupUserListTableView.trailingAnchor.constraint(equalTo: scrollContentsView.trailingAnchor, constant: -10),
            groupUserListTableView.heightAnchor.constraint(equalToConstant: 600)
        ])
    }
    
    private func addTargets() {
        addEmailInputTextField.addTarget(self, action: #selector(emailInputTextFieldDidChanged), for: .editingChanged)
        addEmailButton.addTarget(self, action: #selector(addEmailButtonTouched), for: .touchUpInside)
    }
}

// MARK: - Bind

private extension SelectedGroupPageViewController {
    func bind() {
        let outputSubject = viewModel.transform(with: inputSubject.eraseToAnyPublisher())
        
        outputSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] output in
                switch output {
                case .getUserListSuccess:
                    self?.groupUserListTableView.reloadData()
                case .addEmailPossible:
                    self?.addEmailButton.isEnabled = true
                    self?.addEmailButton.backgroundColor = .blue
                case .addEmailImpossible:
                    self?.addEmailButton.isEnabled = false
                    self?.addEmailButton.backgroundColor = .systemGray
                case .addEmailInputSuccess:
                    self?.addEmailInputSuccess()
                case .addEmailInputFail:
                    self?.addEmailInputFail()
                }
            }
            .store(in: &subscriptions)
    }
}

// MARK: - Methos

extension SelectedGroupPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.groupUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupListCell", for: indexPath) as? GroupListCell else {
            return MyProfileMenuCell(frame: .zero)
        }
        
        cell.setGroupName(viewModel.groupUsers[indexPath.row].email)
        cell.selectionStyle = .none
        
        return cell
    }
}

extension SelectedGroupPageViewController: UITextFieldDelegate {
    @objc func emailInputTextFieldDidChanged(_ sender: Any?) {
        guard let email = self.addEmailInputTextField.text else {
            return
        }
        
        inputSubject.send(.addEmailInput(email: email))
    }
    
    @objc func addEmailButtonTouched(_ sender: Any?) {
        inputSubject.send(.addEmailButtonTouched)
    }
    
    private func addEmailInputSuccess() {
        let sheet = UIAlertController(title: "유저 초대 성공", message: "유저 초대에 성공했습니다!", preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default) { _ in
            self.inputSubject.send(.getUserList)
            self.addEmailInputTextField.text = ""
        }
        sheet.addAction(action)
        self.present(sheet, animated: true)
    }
    
    private func addEmailInputFail() {
        let sheet = UIAlertController(title: "유저 초대 실패", message: "이메일이나 네트워크 상태를 다시 확인해보세요.", preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default) { _ in
            self.groupUserListTableView.reloadData()
            self.addEmailInputTextField.text = ""
        }
        sheet.addAction(action)
        self.present(sheet, animated: true)
    }
    
    @objc func editingEnd(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    private func scrollEditingEnd() {
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(editingEnd))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(singleTapGestureRecognizer)
    }
}
