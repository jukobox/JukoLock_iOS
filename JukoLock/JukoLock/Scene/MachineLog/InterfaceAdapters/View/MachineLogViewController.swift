//
//  MachineLogViewController.swift
//  JukoLock
//
//  Created by 김경호 on 9/7/24.
//

import Combine
import UIKit

final class MachineLogViewController: UIViewController {
    
    // MARK: - Properties
    
    private var subscriptions: Set<AnyCancellable> = []
    private var viewModel: MachineLogViewModel
    private let inputSubject: PassthroughSubject<MachineLogViewModel.Input, Never> = .init()
    
    // MARK: - Init
    
    init(viewModel: MachineLogViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Machine Setting ViewController init(coder:) has not been implemented")
    }
    
    // MARK: - UI Components
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(MachineLogTableViewCell.self, forCellReuseIdentifier: MachineLogTableViewCell.id)

        setUpLayout()
    }
}

// MARK: - UI Settings


extension MachineLogViewController {
    
    private func setUpLayout() {
        addViews()
        setLayoutConstraints()
        bind()
        inputSubject.send(.MachineLogGet)
    }
    
    private func addViews() {
        self.view.addSubview(self.tableView)
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate ([
            self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 10),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 10)
        ])
    }
}

// MARK: - Bind
private extension MachineLogViewController {
    func bind() {
        let outputSubject = viewModel.transform(with: inputSubject.eraseToAnyPublisher())
        
        outputSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] output in
                switch output {
                case .MachineLogGetSuccess:
                    self?.tableView.reloadData()
                case .MachineLogGetFail:
                    self?.getLogFaile()
                }
            }
            .store(in: &subscriptions)
    }
}

// MARK: - Methos
extension MachineLogViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.logs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MachineLogTableViewCell.id, for: indexPath) as? MachineLogTableViewCell else {
            return MachineLogTableViewCell(frame: .zero)
        }
        
        cell.setData(log: viewModel.logs[indexPath.row])
        return cell
    }
}

private extension MachineLogViewController {
    func getLogFaile() {
        let sheet = UIAlertController(title: "로그 연결 실패", message: "로그 받아오는대 실패하였습니다.\n잠시 후 다시 시도해주세요.", preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default) {_ in 
            self.dismiss(animated: true)
        }
        sheet.addAction(action)
        present(sheet, animated: true, completion: nil)
    }
}
