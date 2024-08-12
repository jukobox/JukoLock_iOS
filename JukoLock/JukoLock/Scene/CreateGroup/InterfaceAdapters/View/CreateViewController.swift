//
//  CreateViewController.swift
//  JukoLock
//
//  Created by 김경호 on 8/5/24.
//

import Combine
import UIKit

final class CreateViewController: UIViewController {
    
    // MARK: - Properties
    
    private var subscriptions: Set<AnyCancellable> = []
    private var viewModel: CreateViewModel
    private let inputSubject: PassthroughSubject<CreateViewModel.Input, Never> = .init()

    // MARK: - UI Components
    
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
    
    private let groupNameInputTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "그룹 이름을 입력해주세요."
        textField.autocapitalizationType = .none
        textField.layer.cornerRadius = 5
        textField.layer.borderWidth = 1
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
        textField.leftViewMode = .always
        
        return textField
    }()
    
    private let followListTableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.cornerRadius = 5
        tableView.layer.borderWidth = 1
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    // TODO: - 이름값 필터링으로 버튼 활성화 여부
    private let completeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 10
        button.setTitle("완료", for: .normal)
        button.tintColor = UIColor.white
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    // MARK: - Init
    
    init(viewModel: CreateViewModel) {
        self.viewModel = viewModel
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
        
        groupNameInputTextField.delegate = self
    }
    
}

// MARK: - UI Settings

extension CreateViewController {
    
    private func addViews() {
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(scrollContentsView)
        
        [ groupNameInputTextField, followListTableView, completeButton ].forEach {
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
            scrollContentsView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor),
            scrollContentsView.heightAnchor.constraint(equalToConstant: 1000),
            
            groupNameInputTextField.topAnchor.constraint(equalTo: scrollContentsView.topAnchor, constant: 10),
            groupNameInputTextField.leadingAnchor.constraint(equalTo: scrollContentsView.leadingAnchor, constant: 10),
            groupNameInputTextField.trailingAnchor.constraint(equalTo: scrollContentsView.trailingAnchor, constant: -10),
            groupNameInputTextField.heightAnchor.constraint(equalToConstant: 50),
            
            followListTableView.topAnchor.constraint(equalTo: groupNameInputTextField.bottomAnchor, constant: 10),
            followListTableView.leadingAnchor.constraint(equalTo: scrollContentsView.leadingAnchor, constant: 10),
            followListTableView.trailingAnchor.constraint(equalTo: scrollContentsView.trailingAnchor, constant: -10),
            followListTableView.heightAnchor.constraint(equalToConstant: 600),
            
            completeButton.topAnchor.constraint(equalTo: followListTableView.bottomAnchor, constant: 20),
            completeButton.leadingAnchor.constraint(equalTo: groupNameInputTextField.leadingAnchor),
            completeButton.trailingAnchor.constraint(equalTo: groupNameInputTextField.trailingAnchor),
            completeButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func addTargets() {
        groupNameInputTextField.addTarget(self, action: #selector(groupNameInputTextFieldDidChanged), for: .editingChanged)
        completeButton.addTarget(self, action: #selector(groupCreateCompleteButtonTouched), for: .touchUpInside)
    }
    
    private func setUpLayout() {
        addViews()
        setLayoutConstraints()
        addTargets()
    }
}

// MARK: - Bind
private extension CreateViewController {
    func bind() {
        let outputSubject = viewModel.transform(with: inputSubject.eraseToAnyPublisher())
        
        outputSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] output in
                switch output {
                case .groupCreateComplete:
                    // TODO: - Alert 만들기
                    debugPrint("Group Create Complete")
                    self?.dismiss(animated: true)
                case .groupCreateFail:
                    // TODO: - Alert 만들기
                    debugPrint("Group Create Fail")
                    self?.dismiss(animated: true)
                }
            }
            .store(in: &subscriptions)
    }
}

// MARK: - Methods
extension CreateViewController: UITextFieldDelegate {
    @objc func groupNameInputTextFieldDidChanged(_ sender: Any?) {
        guard let groupName = self.groupNameInputTextField.text else {
            return
        }
        
        inputSubject.send(.groupNameInput(groupName: groupName))
    }
}

extension CreateViewController {
    @objc func groupCreateCompleteButtonTouched(_ sender: Any?) {
        inputSubject.send(.groupCreateCompleteButtonTouched)
    }
}
