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
    }
    
}

// MARK: - UI Settings

extension CreateViewController {
    
    private func addViews() {

    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate ([

        ])
    }
    
    private func setUpLayout() {
        addViews()
        setLayoutConstraints()
        addTargets()
    }
    
    private func addTargets() {

    }
}

// MARK: - Bind
private extension CreateViewController {
    func bind() {

    }
}
