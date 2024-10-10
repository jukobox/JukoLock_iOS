//
//  MachineSettingViewController.swift
//  JukoLock
//
//  Created by 김경호 on 6/5/24.
//

import Combine
import UIKit

final class MachineSettingViewController: UIViewController {
    
    // MARK: - Properties
    
    private var subscriptions: Set<AnyCancellable> = []
    private var viewModel: MachineSettingViewModel
    private let inputSubject: PassthroughSubject<MachineSettingViewModel.Input, Never> = .init()
    
    // MARK: - Init
    
    init(viewModel: MachineSettingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Machine Setting ViewController init(coder:) has not been implemented")
    }
    
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
    
    private let machineImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "lock.fill")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "별명  "
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let machineRenameButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let lastLogNameLabel: UILabel = {
        let label = UILabel()
        label.text = "사용 시간"
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let lastLogLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let permissionSettingButton: UIButton = {
        let button = UIButton()
        button.setTitle("권한 설정", for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let logCheckButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그 확인", for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let machineDeleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("삭제하기", for: .normal)
        button.backgroundColor = .red
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        self.machineRenameButton.setTitle(viewModel.machine.nickname, for: .normal)
        self.lastLogLabel.text = viewModel.machine.udate
        setUpLayout()
    }
}

// MARK: - UI Settings


extension MachineSettingViewController {
    
    private func setUpLayout() {
        addViews()
        setLayoutConstraints()
        addTargets()
        bind()
    }
    
    private func addViews() {
        self.view.addSubview(scrollView)
        scrollView.addSubview(scrollContentsView)
        
        [ machineImageView, nameLabel, machineRenameButton, lastLogNameLabel, lastLogLabel, permissionSettingButton, logCheckButton, machineDeleteButton ].forEach {
            self.scrollContentsView.addSubview($0)
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
            
            machineImageView.topAnchor.constraint(equalTo: scrollContentsView.topAnchor, constant: 20),
            machineImageView.centerXAnchor.constraint(equalTo: scrollContentsView.centerXAnchor),
            machineImageView.leadingAnchor.constraint(equalTo: scrollContentsView.leadingAnchor, constant: 20),
            machineImageView.trailingAnchor.constraint(equalTo: scrollContentsView.trailingAnchor, constant: -20),
            machineImageView.heightAnchor.constraint(equalToConstant: self.view.frame.width - 50),
            
            nameLabel.topAnchor.constraint(equalTo: machineImageView.bottomAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: self.machineImageView.leadingAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 50),
            nameLabel.widthAnchor.constraint(equalToConstant: 80),
            
            machineRenameButton.topAnchor.constraint(equalTo: nameLabel.topAnchor),
            machineRenameButton.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 10),
            machineRenameButton.trailingAnchor.constraint(equalTo: scrollContentsView.trailingAnchor, constant: -20),
            machineRenameButton.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            
            lastLogNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            lastLogNameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            lastLogNameLabel.heightAnchor.constraint(equalToConstant: 50),
            lastLogNameLabel.widthAnchor.constraint(equalToConstant: 80),
            
            lastLogLabel.topAnchor.constraint(equalTo: lastLogNameLabel.topAnchor),
            lastLogLabel.leadingAnchor.constraint(equalTo: lastLogNameLabel.trailingAnchor, constant: 10),
            lastLogLabel.trailingAnchor.constraint(equalTo: scrollContentsView.trailingAnchor, constant: -20),
            lastLogLabel.bottomAnchor.constraint(equalTo: lastLogNameLabel.bottomAnchor),
            
            permissionSettingButton.topAnchor.constraint(equalTo: lastLogNameLabel.bottomAnchor, constant: 30),
            permissionSettingButton.leadingAnchor.constraint(equalTo: scrollContentsView.leadingAnchor, constant: 20),
            permissionSettingButton.trailingAnchor.constraint(equalTo: scrollContentsView.trailingAnchor, constant: -20),
            permissionSettingButton.heightAnchor.constraint(equalToConstant: 50),
            
            logCheckButton.topAnchor.constraint(equalTo: permissionSettingButton.bottomAnchor, constant: 20),
            logCheckButton.leadingAnchor.constraint(equalTo: scrollContentsView.leadingAnchor, constant: 20),
            logCheckButton.trailingAnchor.constraint(equalTo: scrollContentsView.trailingAnchor, constant: -20),
            logCheckButton.heightAnchor.constraint(equalToConstant: 50),
            
            machineDeleteButton.topAnchor.constraint(equalTo: logCheckButton.bottomAnchor, constant: 20),
            machineDeleteButton.leadingAnchor.constraint(equalTo: scrollContentsView.leadingAnchor, constant: 20),
            machineDeleteButton.trailingAnchor.constraint(equalTo: scrollContentsView.trailingAnchor, constant: -20),
            machineDeleteButton.bottomAnchor.constraint(equalTo: scrollContentsView.bottomAnchor),
            machineDeleteButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func addTargets() {
        self.machineRenameButton.addTarget(self, action: #selector(machineRenameButtonTouched), for: .touchUpInside)
        self.logCheckButton.addTarget(self, action: #selector(logCheckButtonTouched), for: .touchUpInside)
    }
}

// MARK: - Bind
private extension MachineSettingViewController {
    func bind() {
        let outputSubject = viewModel.transform(with: inputSubject.eraseToAnyPublisher())
        
        outputSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] output in
                switch output {
                case let .machineRenameSuccess(newName):
                    self?.machineRenameResult(result: "기기 이름 성공", message: "기기 이름을 변경하였습니다.")
                    self?.machineRenameButton.setTitle(newName, for: .normal)
                    self?.machineRenameButton.reloadInputViews()
                    // TODO: - Main도 변경되도록 수정
                case .machineReanmeFailure:
                    self?.machineRenameResult(result: "기기 이름 실패", message: "기기 이름 변경에 실패하였습니다.")
                }
            }
            .store(in: &subscriptions)
    }
}

// MARK: - Methos

extension MachineSettingViewController {
    func machineRenameResult(result: String, message: String) {
        let sheet = UIAlertController(title: result, message: message, preferredStyle: .alert)
        sheet.addAction(UIAlertAction(title: "확인", style: .default))
        present(sheet, animated: true)
    }
}

// MARK: - objc

private extension MachineSettingViewController {
    @objc func machineRenameButtonTouched(_ sender: Any) {
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
    
    @objc func logCheckButtonTouched(_ sender: Any) {
        let viewModel = MachineLogViewModel()
        let viewController = MachineLogViewController(viewModel: viewModel)
        self.present(viewController, animated: true)
    }
}
