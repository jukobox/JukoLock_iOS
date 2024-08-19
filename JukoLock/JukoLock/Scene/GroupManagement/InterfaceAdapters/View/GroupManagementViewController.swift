//
//  GroupManagementViewController.swift
//  JukoLock
//
//  Created by 김경호 on 8/4/24.
//

import Combine
import UIKit

final class GroupManagementViewController: UIViewController {
    
    // MARK: - Properties
    
    private var subscriptions: Set<AnyCancellable> = []
    private var viewModel: GroupManagementViewModel
    private let inputSubject: PassthroughSubject<GroupManagementViewModel.Input, Never> = .init()
    
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
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private let createGroupButton: UIButton = {
        let button = UIButton()
        button.setTitle("새로운 그룹 생성", for: .normal)
        button.backgroundColor = .green
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    // MARK: - Init
    
    init(viewModel: GroupManagementViewModel) {
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
        updateTableViewHeight()
        
        // TODO: - 수정할 것
        tableView.register(GroupListCell.self, forCellReuseIdentifier: "GroupListCell")
        tableView.dataSource = self
        tableView.delegate = self
        
        self.inputSubject.send(.getGroupList)
    }
    
}

// MARK: - UI Settings

extension GroupManagementViewController {
    
    private func addViews() {
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(scrollContentsView)
        
        [ tableView, createGroupButton ].forEach {
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
            // 없으면 버튼 터치 안됨
            scrollContentsView.heightAnchor.constraint(equalToConstant: 800),
            
            tableView.topAnchor.constraint(equalTo: scrollContentsView.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: scrollContentsView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: scrollContentsView.trailingAnchor),
            
            createGroupButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 10),
            createGroupButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            createGroupButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            createGroupButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setUpLayout() {
        addViews()
        setLayoutConstraints()
        addTargets()
    }
    
    private func addTargets() {
        self.createGroupButton.addTarget(self, action: #selector(createGroupButtonTouched), for: .touchUpInside)
    }
}

// MARK: - Bind

private extension GroupManagementViewController {
    func bind() {
        let outputSubject = viewModel.transform(with: inputSubject.eraseToAnyPublisher())
        
        outputSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] output in
                switch output {
                case .listGetComplete:
                    self?.listGetComplete()
                }
            }
            .store(in: &subscriptions)
    }
}

// MARK: - Methos

extension GroupManagementViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.groupList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupListCell", for: indexPath) as? GroupListCell else {
            return MyProfileMenuCell(frame: .zero)
        }
        
        cell.setGroupName(viewModel.groupList[indexPath.row].name)
        cell.selectionStyle = .none
        
        return cell
    }
    
    // TableView의 높이를 콘텐츠 크기에 맞게 조정
    func updateTableViewHeight() {
        tableView.reloadData()
        tableView.layoutIfNeeded()
        let height = tableView.contentSize.height * 10
        tableView.heightAnchor.constraint(equalToConstant: height).isActive = true
        scrollView.contentSize = CGSize(width: view.frame.width, height: height)
    }
}

extension GroupManagementViewController {
    @objc func createGroupButtonTouched(_ sender: Any?) {
        let createGroupViewController = CreateViewController(viewModel: CreateViewModel(createGroupUseCase: CreateGroupUseCase(provider: APIProvider(session: URLSession.shared))))
        self.present(createGroupViewController, animated: true)
    }
    
    private func listGetComplete() {
        self.tableView.reloadData()
    }
}

