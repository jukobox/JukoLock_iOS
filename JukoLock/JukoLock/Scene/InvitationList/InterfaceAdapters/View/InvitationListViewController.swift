//
//  InvitationList.swift
//  JukoLock
//
//  Created by 김경호 on 8/13/24.
//

import Combine
import UIKit

final class InvitationListViewController: UIViewController {
    
    // MARK: - Properties
    
    private var subscriptions: Set<AnyCancellable> = []
    private var viewModel: InvitationListViewModel
    private let inputSubject: PassthroughSubject<InvitationListViewModel.Input, Never> = .init()
    
    // MARK: - UI Components
    
    private let invitationListTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    // MARK: - Init
    
    init(viewModel: InvitationListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        invitationListTableView.register(GroupListCell.self, forCellReuseIdentifier: "GroupListCell")
        invitationListTableView.delegate = self
        invitationListTableView.dataSource = self
        
        setUpLayout()
    }
    
}

// MARK: - UI Settings

extension InvitationListViewController {
    
    private func addViews() {
        self.view.addSubview(invitationListTableView)
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate ([
            invitationListTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            invitationListTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            invitationListTableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            invitationListTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setUpLayout() {
        addViews()
        setLayoutConstraints()
        addTargets()
        bind()
    }
    
    private func addTargets() {
        
    }
}

// MARK: - Bind

private extension InvitationListViewController {
    func bind() {
        let outputSubject = viewModel.transform(with: inputSubject.eraseToAnyPublisher())
        
        outputSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] output in
                switch output {
                case .invitationAcceptSuccess:
                    self?.invitationResult(message: "초대 수락 성공")
                case .invitationAcceptFail:
                    self?.invitationResult(message: "초대 수락 실패")
                case .invitationAcceptError:
                    self?.invitationResult(message: "초대 수락 에러")
                }
            }
            .store(in: &subscriptions)
    }
}

// MARK: - Methos

extension InvitationListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.noties.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupListCell", for: indexPath) as? GroupListCell else {
            return MyProfileMenuCell(frame: .zero)
        }
        
        cell.setGroupName(viewModel.noties[indexPath.row].group.name)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sheet = UIAlertController(title: "초대를 수락", message: "초대를 수락하겠습니까?", preferredStyle: .alert)
        sheet.addAction(UIAlertAction(title: "수락", style: .default, handler: {_ in 
            self.inputSubject.send(.invitationAccept(index: indexPath.row))
        }))
        sheet.addAction(UIAlertAction(title: "취소", style: .cancel))
        present(sheet, animated: true)
    }
}

extension InvitationListViewController {
    private func invitationResult(message: String) {
        let sheet = UIAlertController(title: "", message: message, preferredStyle: .alert)
        sheet.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
            self.invitationListTableView.reloadData()
        }))
        
        present(sheet, animated: true)
    }
}

