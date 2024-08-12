//
//  MyProfileViewController.swift
//  JukoLock
//
//  Created by 김경호 on 6/1/24.
//

import UIKit

final class MyProfileViewController: UIViewController {
    
    // MARK: - Properties

    private let menu = ["친구 관리", "그룹 설정", "앱 설정"]
    private let menuSymbol = ["person.circle.fill", "lock.square.stack", "tray.and.arrow.up.fill"]
    
    // MARK: - UI Components
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Init
    
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemGray6
        
        tableView.register(MyProfileMenuCell.self, forCellReuseIdentifier: "MyProfileMenuCell")
        tableView.dataSource = self
        tableView.delegate = self
        
        setUpLayout()
    }
}


// MARK: - UI Settings

extension MyProfileViewController {
    
    private func setUpLayout() {
        addViews()
        setLayoutConstarints()
        addTargets()
    }
    
    private func addViews() {
        self.view.addSubview(tableView)
        
    }
    
    private func addTargets() {
        
    }
    
    private func setLayoutConstarints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - Methos

extension MyProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "프로필"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyProfileMenuCell", for: indexPath) as? MyProfileMenuCell else {
            return MyProfileMenuCell(frame: .zero)
        }
        
        cell.setMenuName(menu[indexPath.row], menuSymbol[indexPath.row])
        cell.selectionStyle = .none
        
        return cell
    }
    
    // TODO: - 추후 개발하여 페이지 연결
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 { // 친구 관리
            debugPrint("친구 관리")
        }
        else if indexPath.row == 1 { // 그룹 관리
            let groupManagementViewController = GroupManagementViewController(viewModel: GroupManagementViewModel(groupManagementUseCase: GroupManagementUseCase(provider: APIProvider(session: URLSession.shared))))
            self.navigationController?.present(groupManagementViewController, animated: true)
        }
        else { // 앱 설정
            debugPrint("앱 설정")
        }
    }
}
