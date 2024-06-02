//
//  MainViewController.swift
//  JukoLock
//
//  Created by 김경호 on 5/3/24.
//

import UIKit

final class MainViewController: UIViewController {
    
    // MARK: - Properties
    private var machineLockState: Bool = true // TODO: - 이미지 서버에서 불러오기
    private let datas = ["aa", "a", "a", "a", "a", "te", "sd", "d"]
    let testData: [String] = ["김경호", "a 그룹", "b 그룹"] // TODO: - ViewModel에서 가져오기
    
    // MARK: - UI Components
    
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
    
    private let logButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30)
        let image = UIImage(systemName: "text.bubble.fill", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
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
    
    private let controllMachineButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 150)
        let image = UIImage(systemName: "lock.fill", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
    
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        setUpLayout()
        
        dropDownButton.setTitle("▼ \(testData.first!)", for: .normal)
        dropTableView.dataSource = self
        dropTableView.delegate = self
    }
}


// MARK: - UI Settings

extension MainViewController {
    
    private func setUpLayout() {
        addViews()
        setLayoutConstraints()
        addTargets()
    }
    
    private func addViews() {
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(scrollContentsView)
        [ controllMachineButton, dropTableView ].forEach {
            self.scrollContentsView.addSubview($0)
        }
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: logButton),
            UIBarButtonItem(customView: addMachineButton)
        ]
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: dropDownButton)
    }
    
    private func addTargets() {
        controllMachineButton.addTarget(self, action: #selector(controllMachineButtonTouched), for: .touchUpInside)
        dropDownButton.addTarget(self, action: #selector(groupDropDownButtonTouched), for: .touchUpInside)
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
            
            controllMachineButton.topAnchor.constraint(equalTo: self.scrollContentsView.topAnchor),
            controllMachineButton.leadingAnchor.constraint(equalTo: self.scrollContentsView.leadingAnchor),
            controllMachineButton.trailingAnchor.constraint(equalTo: self.scrollContentsView.trailingAnchor),
            controllMachineButton.bottomAnchor.constraint(equalTo: self.scrollContentsView.bottomAnchor),
            
            dropTableView.topAnchor.constraint(equalTo: self.scrollContentsView.topAnchor, constant: 5),
            dropTableView.leadingAnchor.constraint(equalTo: self.scrollContentsView.leadingAnchor),
            dropTableView.widthAnchor.constraint(equalToConstant: 150),
            dropTableView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
}

// MARK: - Methos

extension MainViewController {
    
    @objc func controllMachineButtonTouched() {
        debugPrint("혹시 몰라서")
        // 이미지 변경
        machineLockState.toggle()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 150)
        let image = machineLockState ? UIImage(systemName: "lock.fill", withConfiguration: imageConfig) : UIImage(systemName: "lock.open.fill", withConfiguration: imageConfig)
        controllMachineButton.setImage(image, for: .normal)
        
        
        // TODO: - 통신 코드 구현
    }
    
    @objc func groupDropDownButtonTouched() { // TODO: - 이름 바꾸기
        self.dropTableView.isHidden = !self.dropTableView.isHidden
    }
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MachineListCell", for: indexPath) as? MachineListCell else {
            fatalError("Failed to load cell!")
        }
        cell.setData()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 20
        let collectionViewSize = collectionView.frame.size.width - padding
        
        return CGSize(width: collectionViewSize / 2, height: collectionViewSize / 2)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = testData[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = testData[indexPath.row]
        debugPrint(selectedItem)
        dropDownButton.setTitle("▼ \(selectedItem)", for: .normal)
        dropTableView.isHidden = !dropTableView.isHidden
    }
}
