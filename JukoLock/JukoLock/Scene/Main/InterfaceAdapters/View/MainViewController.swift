//
//  MainViewController.swift
//  JukoLock
//
//  Created by 김경호 on 5/3/24.
//

import Lottie
import Combine
import UIKit

final class MainViewController: UIViewController {
    
    // MARK: - Properties
    private var subscriptions: Set<AnyCancellable> = []
    private var viewModel: MainViewModel
    private let inputSubject: PassthroughSubject<MainViewModel.Input, Never> = .init()
    
    // MARK: - UI Components
    
    private let loadingView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let loadingAnimation: LottieAnimationView = {
        let animation = LottieAnimationView(name: "loading")
        animation.loopMode = .loop
        animation.play()
        animation.translatesAutoresizingMaskIntoConstraints = false
        return animation
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isUserInteractionEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let scrollContentsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let dropDownButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.lightGray, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let invitationListButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30)
        let image = UIImage(systemName: "text.bubble.fill", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        button.tintColor = .systemGray
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let addMachineButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30)
        let image = UIImage(systemName: "plus.circle", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome to\nJukoLock"
        label.textAlignment = .left
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 50)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let carouselView: UICollectionView = {
        // CollectionViewFlowLayout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CarouselConst.itemSize
        layout.minimumLineSpacing = CarouselConst.itemSpacing
        layout.minimumInteritemSpacing = 0
        
        // CollectionView
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = true
        collectionView.backgroundColor = .clear
        collectionView.clipsToBounds = true
        collectionView.register(CarouselViewCell.self, forCellWithReuseIdentifier: "CarouselViewCell")
        collectionView.isPagingEnabled = false
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.contentInset = CarouselConst.collectionViewContentInset
        collectionView.decelerationRate = .fast
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let machineListCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 10
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(MachineListCell.self, forCellWithReuseIdentifier: "MachineListCell")
        return collectionView
    }()
    
    private let dropTableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Init
    
    init(viewModel: MainViewModel) {
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
        
        setUpLayout()
        
        dropTableView.dataSource = self
        dropTableView.delegate = self
        carouselView.dataSource = self
        carouselView.delegate = self
        machineListCollectionView.dataSource = self
        machineListCollectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        inputSubject.send(.checkInvite)
        inputSubject.send(.mainPageInit)
    }
}


// MARK: - UI Settings

extension MainViewController {
    
    private func setUpLayout() {
        addViews()
        setLayoutConstraints()
        addTargets()
        bind()
    }
    
    private func addViews() {
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(scrollContentsView)
        [ dropDownButton, invitationListButton, addMachineButton, welcomeLabel, carouselView, dropTableView, machineListCollectionView ].forEach {
            self.scrollContentsView.addSubview($0)
        }
        
        self.view.addSubview(loadingView)
        loadingView.addSubview(loadingAnimation)
    }
    
    private func addTargets() {
        dropDownButton.addTarget(self, action: #selector(groupDropDownButtonTouched), for: .touchUpInside)
        invitationListButton.addTarget(self, action: #selector(invitationListButtonTouched), for: .touchUpInside)
        addMachineButton.addTarget(self, action: #selector(addMachineButtonTouched), for: .touchUpInside)
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            
            scrollContentsView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            scrollContentsView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            scrollContentsView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
            scrollContentsView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            scrollContentsView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor),
            
            dropDownButton.topAnchor.constraint(equalTo: self.scrollContentsView.topAnchor),
            dropDownButton.leadingAnchor.constraint(equalTo: self.scrollContentsView.leadingAnchor, constant: 20),
            
            addMachineButton.topAnchor.constraint(equalTo: self.scrollContentsView.topAnchor),
            addMachineButton.trailingAnchor.constraint(equalTo: self.scrollContentsView.trailingAnchor, constant: -20),
            
            invitationListButton.topAnchor.constraint(equalTo: self.scrollContentsView.topAnchor),
            invitationListButton.trailingAnchor.constraint(equalTo: addMachineButton.leadingAnchor),
            
            dropTableView.topAnchor.constraint(equalTo: dropDownButton.bottomAnchor, constant: 5),
            dropTableView.leadingAnchor.constraint(equalTo: dropDownButton.leadingAnchor),
            dropTableView.widthAnchor.constraint(equalToConstant: 150),
            dropTableView.heightAnchor.constraint(equalToConstant: 150),
            
            welcomeLabel.topAnchor.constraint(equalTo: dropDownButton.bottomAnchor, constant: 20),
            welcomeLabel.leadingAnchor.constraint(equalTo: self.scrollContentsView.leadingAnchor, constant: 20),
            welcomeLabel.trailingAnchor.constraint(equalTo: self.scrollContentsView.trailingAnchor, constant: 20),
            
            carouselView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 20),
            carouselView.leadingAnchor.constraint(equalTo: self.scrollContentsView.leadingAnchor),
            carouselView.trailingAnchor.constraint(equalTo: self.scrollContentsView.trailingAnchor),
            carouselView.heightAnchor.constraint(equalToConstant: 120),
            
            machineListCollectionView.topAnchor.constraint(equalTo: carouselView.bottomAnchor, constant: 20),
            machineListCollectionView.leadingAnchor.constraint(equalTo: scrollContentsView.leadingAnchor, constant: 20),
            machineListCollectionView.trailingAnchor.constraint(equalTo: scrollContentsView.trailingAnchor, constant: -20),
            machineListCollectionView.bottomAnchor.constraint(equalTo: scrollContentsView.bottomAnchor),
            machineListCollectionView.heightAnchor.constraint(equalToConstant: 1200),
            
            loadingView.topAnchor.constraint(equalTo: self.view.topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            loadingAnimation.topAnchor.constraint(equalTo: self.loadingView.topAnchor),
            loadingAnimation.leadingAnchor.constraint(equalTo: self.loadingView.leadingAnchor),
            loadingAnimation.trailingAnchor.constraint(equalTo: self.loadingView.trailingAnchor),
            loadingAnimation.bottomAnchor.constraint(equalTo: self.loadingView.bottomAnchor)
        ])
    }
}

// MARK: - Bind
extension MainViewController {
    func bind() {
        let outputSubject = viewModel.transform(with: inputSubject.eraseToAnyPublisher())
        
        outputSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] output in
                switch output {
                case .isInvitationReceived:
                    self?.invitationListButton.tintColor = .blue
                    self?.invitationListButton.isEnabled = true
                case .isInvitationNotReceived:
                    self?.invitationListButton.tintColor = .systemGray
                    self?.invitationListButton.isEnabled = false
                case .getGroupListSuccess:
                    self?.dropTableView.reloadData()
                    self?.dropDownButton.setTitle("▼ \(self?.viewModel.groupList.first?.name ?? "")", for: .normal)
                    self?.inputSubject.send(.getMachineList)
                case .getMachineListSuccess:
                    self?.machineListCollectionView.reloadData()
                    self?.carouselView.reloadData()
                    self?.loadingView.isHidden = true
                case let .setGroup(groupName):
                    self?.dropDownButton.setTitle("▼ \(groupName)", for: .normal)
                }
            }
            .store(in: &subscriptions)
    }
}

// MARK: - Methos

extension MainViewController {
    @objc func groupDropDownButtonTouched() {
        self.dropTableView.isHidden = !self.dropTableView.isHidden
    }
    
    func updateScrollViewHeight() {
        let newHeight = machineListCollectionView.collectionViewLayout.collectionViewContentSize.height + 200
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: newHeight)
        scrollContentsView.frame = CGRect(x: 0, y: 0, width: scrollView.frame.width, height: newHeight)
    }
    
    @objc func invitationListButtonTouched(_ sender: Any?) {
        let invitationListViewController = InvitationListViewController(viewModel: InvitationListViewModel(invitationListUseCase: InvitationListUseCase(provider: APIProvider(session: URLSession.shared)), noties: viewModel.noties))
        self.navigationController?.present(invitationListViewController, animated: true)
    }
    
    @objc func addMachineButtonTouched(_ sender: Any?) {
        let provider = APIProvider(session: URLSession.shared)
        let useCase = AddMachineUseCase(provider: provider)
        let viewModel = AddMachineViewModel(addMachineUseCase: useCase, groupList: self.viewModel.groupList, userName: "test")
        let addMachineViewController = AddMachineViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(addMachineViewController, animated: true)
    }
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.machines.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == machineListCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MachineListCell", for: indexPath) as? MachineListCell else {
                fatalError("Failed to load cell!")
            }
            
            cell.setData(machine: viewModel.machines[indexPath.row])
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarouselViewCell", for: indexPath) as? CarouselViewCell else {
                fatalError("Failed to load cell!")
            }
            
            cell.setData(name: viewModel.machines[indexPath.row].nickname, log: viewModel.machines[indexPath.row].udate)
            return cell
        }
    }
    
    // cell 크기 지정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == machineListCollectionView {
            let padding: CGFloat = 20
            let collectionViewSize = collectionView.frame.size.width - padding
            return CGSize(width: collectionViewSize / 2, height: collectionViewSize / 2)
        } else {
            let padding: CGFloat = CarouselConst.padding
            return CGSize(width: collectionView.frame.size.width - padding, height: collectionView.frame.size.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == machineListCollectionView {
            let provider = APIProvider(session: URLSession.shared)
            let adminMachineSettingViewModel = AdminMachineSettingViewModel(machine: viewModel.machines[indexPath.row], machineSettingUseCase: AdminMachineSettingUseCases(provider: provider))
            let viewController = AdminMachineSettingViewController(viewModel: adminMachineSettingViewModel)
            self.present(viewController, animated: true)
        }
    }
    
    func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        let scrolledOffsetX = targetContentOffset.pointee.x + scrollView.contentInset.left
        let cellWidth = CarouselConst.itemSize.width + (CarouselConst.itemSpacing / 2)
        let index = round(scrolledOffsetX / cellWidth)
        targetContentOffset.pointee = CGPoint(x: index * carouselView.frame.width, y: scrollView.contentInset.top)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.groupList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = viewModel.groupList[indexPath.row].name
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        inputSubject.send(.selectGroup(index: indexPath.row))
        dropDownButton.setTitle("▼ \(viewModel.groupList.first?.name ?? "")", for: .normal)
        dropTableView.isHidden = !dropTableView.isHidden
    }
}

// MARK: - Const

extension MainViewController {
    private enum CarouselConst {
        static let itemSize = CGSize(width: UIScreen.main.bounds.width, height: 400)
        static let itemSpacing = 24.0
        static let padding: CGFloat = 20
        
        static var collectionViewContentInset: UIEdgeInsets {
            UIEdgeInsets(top: 0, left: padding / 2, bottom: 0, right: padding / 2)
        }
    }
}
