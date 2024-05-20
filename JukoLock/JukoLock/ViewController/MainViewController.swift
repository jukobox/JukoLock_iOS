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
    
    // MARK: - UI Components
    
    private let logButton: UIBarButtonItem = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30)
        let image = UIImage(systemName: "text.bubble.fill", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        let barButton = UIBarButtonItem(customView: button)
        return barButton
    }()
    
    private let addMachineButton: UIBarButtonItem = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30)
        let image = UIImage(systemName: "plus.circle", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        let barButton = UIBarButtonItem(customView: button)
        return barButton
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
    
    // MARK: - Init
    
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setUpLayout()
        
        machineListCollectionView.dataSource = self
        machineListCollectionView.delegate = self
        controllMachineButton.addTarget(self, action: #selector(controllMachineButtonTouched), for: .touchUpInside)
    }
}


// MARK: - UI Settings

extension MainViewController {
    
    private func addViews() {
        [ controllMachineButton, machineListCollectionView].forEach {
            self.view.addSubview($0)
        }
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            controllMachineButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            controllMachineButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            controllMachineButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            controllMachineButton.heightAnchor.constraint(equalToConstant: 200),
            
            machineListCollectionView.topAnchor.constraint(equalTo: controllMachineButton.bottomAnchor),
            machineListCollectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            machineListCollectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            machineListCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setUpLayout() {
        addViews()
        setLayoutConstraints()
        self.navigationItem.rightBarButtonItems = [logButton, addMachineButton]
    }
}

// MARK: - Methos

extension MainViewController {
    
    @objc func controllMachineButtonTouched() {
        // 이미지 변경
        machineLockState.toggle()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 150)
        let image = machineLockState ? UIImage(systemName: "lock.fill", withConfiguration: imageConfig) : UIImage(systemName: "lock.open.fill", withConfiguration: imageConfig)
        controllMachineButton.setImage(image, for: .normal)
        
        
        // TODO: - 통신 코드 구현
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
