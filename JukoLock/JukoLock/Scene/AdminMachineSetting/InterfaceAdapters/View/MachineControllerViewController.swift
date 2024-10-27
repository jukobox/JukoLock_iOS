//
//  AdminMachineSettingViewController.swift
//  JukoLock
//
//  Created by 김경호 on 6/5/24.
//

import Combine
import UIKit

final class MachineControllerViewController: UIViewController {
    
    // MARK: - Properties
    
    private var subscriptions: Set<AnyCancellable> = []
    private var viewModel: MachineControllerViewModel
    private let inputSubject: PassthroughSubject<MachineControllerViewModel.Input, Never> = .init()
    
    // MARK: - Init
    
    init(viewModel: MachineControllerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Machine Setting ViewController init(coder:) has not been implemented")
    }
    
    // MARK: - UI Components
    private let machineControllerTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let machineControllerHeaderView: MachineControllerHeaderView = MachineControllerHeaderView()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        
        setUpLayout()
        
        machineControllerTableView.delegate = self
        machineControllerTableView.dataSource = self
        machineControllerTableView.register(UITableViewCell.self, forCellReuseIdentifier: "sectionTableViewCell")
        machineControllerHeaderView.setName(viewModel.machine.nickname)
    }
}

// MARK: - UI Settings


extension MachineControllerViewController {
    
    private func setUpLayout() {
        machineControllerHeaderView.translatesAutoresizingMaskIntoConstraints = false
        
        addViews()
        setLayoutConstraints()
        bind()
    }
    
    private func addViews() {
        [machineControllerHeaderView, machineControllerTableView].forEach {
            self.view.addSubview($0)
        }
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate ([
            machineControllerHeaderView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            machineControllerHeaderView.heightAnchor.constraint(equalToConstant: 50),
            machineControllerHeaderView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            
            
            machineControllerTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            machineControllerTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Padding.tableViewSide),
            machineControllerTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Padding.tableViewSide),
            machineControllerTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Padding.tableViewBottom)
        ])
    }
}

// MARK: - Bind
private extension MachineControllerViewController {
    func bind() {
        let outputSubject = viewModel.transform(with: inputSubject.eraseToAnyPublisher())
        
        outputSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] output in
                switch output {
                case let .machineRenameSuccess(newName):
                    self?.machineResultAlert(result: "기기 이름 성공", message: "기기 이름을 변경하였습니다.")
                    self?.machineControllerHeaderView.setName(newName)
                    // TODO: - Main 화면도 변경되도록 수정
                case .machineReanmeFailure:
                    self?.machineResultAlert(result: "기기 이름 실패", message: "기기 이름 변경에 실패하였습니다.")
                case .isOpenSignalSentSuccess:
                    self?.machineResultAlert(result: "기기 열기 신호 보내기 성공", message: "기기 열기 신호를 보냈습니다.")
                case .isOpenSignalSentFailure:
                    self?.machineResultAlert(result: "기기 열기 신호 보내기 실패", message: "잠시 후 다시 시도해주세요.")
                case .userPasswordSetSuccess:
                    self?.machineResultAlert(result: "기기 비밀번호 설정 성공", message: "")
                case .userPasswordSetFailure:
                    self?.machineResultAlert(result: "기기 비밀번호 설정 실패", message: "")
                }
            }
            .store(in: &subscriptions)
    }
}

// MARK: - Methos

extension MachineControllerViewController {
    func machineResultAlert(result: String, message: String) {
        let sheet = UIAlertController(title: result, message: message, preferredStyle: .alert)
        sheet.addAction(UIAlertAction(title: "확인", style: .default))
        present(sheet, animated: true)
    }

    func openMachine() {
        self.inputSubject.send(.openMachine)
    }
    
    func machineRename() {
        let sheet = UIAlertController(title: "이름", message: "수정할 이름을 입력해주세요.", preferredStyle: .alert)
        sheet.addTextField()
        
        let setNameAction = UIAlertAction(title: "확인", style: .default) { _ in
            self.inputSubject.send(.machineRename(sheet.textFields?.first?.text ?? ""))
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        sheet.addAction(setNameAction)
        sheet.addAction(cancelAction)
        
        present(sheet, animated: true)
    }
    
    func logCheck() {
        let provider = APIProvider(session: URLSession.shared)
        let useCases = MachineLogUseCases(provider: provider)
        let viewModel = MachineLogViewModel(machineLogUsecases: useCases, uuid: viewModel.machine.uuid)
        let viewController = MachineLogViewController(viewModel: viewModel)
        self.present(viewController, animated: true)
    }
    
    func setUserPassword() {
        let sheet = UIAlertController(title: "유저 비밀번호", message: "비밀번호를 입력해주세요.", preferredStyle: .alert)
        sheet.addTextField { passwordField in
            passwordField.delegate = self
            passwordField.placeholder = "비밀번호"
            passwordField.isSecureTextEntry = true
            passwordField.keyboardType = .numberPad
            passwordField.returnKeyType = .done
        }
        
        let setPasswordAction = UIAlertAction(title: "확인", style: .default) { _ in
            self.inputSubject.send(.setUserPassword(sheet.textFields?.first?.text ?? ""))
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        sheet.addAction(setPasswordAction)
        sheet.addAction(cancelAction)
        
        present(sheet, animated: true)
    }
}

extension MachineControllerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 186
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 1
        default: return viewModel.isAdmin ? viewModel.adminControllerMenuList.count - 1: viewModel.userControllerMenuList.count - 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = machineControllerTableView.dequeueReusableCell(withIdentifier: "sectionTableViewCell", for: indexPath)

        cell.backgroundColor = UIColor(named: "BackgroundColor")
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        
        switch indexPath.section {
        case 0:
            cell.addSubview(machineControllerHeaderView)
            cell.backgroundColor = .white
            
            NSLayoutConstraint.activate([
                machineControllerHeaderView.topAnchor.constraint(equalTo: cell.topAnchor),
                machineControllerHeaderView.heightAnchor.constraint(equalToConstant: 186),
                machineControllerHeaderView.centerXAnchor.constraint(equalTo: cell.centerXAnchor)
            ])
            
            cell.accessoryType = .none
        case 1: cell.textLabel?.text = viewModel.adminControllerMenuList[indexPath.row]
        default: cell.textLabel?.text = viewModel.adminControllerMenuList[indexPath.row + 1]
        }
        
        let isStartOfSection = indexPath.row == 0
        let numberOfRowsInSection = tableView.numberOfRows(inSection: indexPath.section)
        let isEndOfSection = indexPath.row == numberOfRowsInSection - 1
        
        if isStartOfSection && isEndOfSection {
            cell.layer.maskedCorners = [.layerMinXMinYCorner,
                                        .layerMaxXMinYCorner,
                                        .layerMinXMaxYCorner,
                                        .layerMaxXMaxYCorner]
            cell.layer.cornerRadius = 10
        } else if isStartOfSection {
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            cell.layer.cornerRadius = 10
        } else if isEndOfSection {
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            cell.layer.cornerRadius = 10
        }
        
        if !isEndOfSection {
            let separateLine: UIView = {
                let view = UIView()
                view.translatesAutoresizingMaskIntoConstraints = false
                view.backgroundColor = UIColor(named: "SecondaryMint")
                return view
            }()
            
            cell.addSubview(separateLine)
            NSLayoutConstraint.activate([
                separateLine.widthAnchor.constraint(equalToConstant: cell.bounds.width - 36),
                separateLine.heightAnchor.constraint(equalToConstant: 1),
                separateLine.topAnchor.constraint(equalTo: cell.bottomAnchor),
                separateLine.centerXAnchor.constraint(equalTo: cell.centerXAnchor)
            ])
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0: // 기기 이름 변경
            machineRename()
        case 1: // 기기 열기
            openMachine()
        default:
            if viewModel.isAdmin {
                switch indexPath.row {
                case 0: // 기기 비밀번호 설정
                    debugPrint("기기 비밀번호 설정")
                case 1: // 기기 유저 비밀번호 설정
                    setUserPassword()
                case 2: // 로그 확인
                    let provider = APIProvider(session: URLSession.shared)
                    let useCases = MachineLogUseCases(provider: provider)
                    let viewModel = MachineLogViewModel(machineLogUsecases: useCases, uuid: viewModel.machine.uuid)
                    let viewController = MachineLogViewController(viewModel: viewModel)
                    self.present(viewController, animated: true)
                default: // 삭제하기
                    debugPrint("삭제하기")
                }
            } else {
                setUserPassword()
            }
        }
    }
}

extension MachineControllerViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if isBackSpace == -92 {
                return true
            }
        }
        
        guard Int(string) != nil || string == "" else { return false }
        guard textField.text!.count < 9 else { return false }
            
        return true
    }
}

extension MachineControllerViewController {
    enum Padding {
        static let tableViewTop: CGFloat = 10
        static let tableViewSide: CGFloat = 38
        static let tableViewBottom: CGFloat = 75
    }
    
    enum KeychainKey {
        static let accessToken: String = "AccessToken"
        static let authorizationCode: String = "AuthorizationCode"
        static let identityToken: String = "IdentityToken"
    }
}
