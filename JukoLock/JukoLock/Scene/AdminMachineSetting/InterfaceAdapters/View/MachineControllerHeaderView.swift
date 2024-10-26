//
//  MachineControllerHeaderView.swift
//  JukoLock
//
//  Created by 김경호 on 10/26/24.
//

import UIKit

final class MachineControllerHeaderView: UICollectionReusableView {
    
    // MARK: - UI Conponents
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 60
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor(named: "BrandColor")?.cgColor
        imageView.layer.borderWidth = 1
        imageView.image = UIImage(systemName: "lock.fill")
        imageView.tintColor = UIColor(named: "BrandColor")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - UI Settings

private extension MachineControllerHeaderView {
    private func setUpLayout() {
        addViews()
        setLayoutConstraints()
    }
    
    private func addViews() {
        self.addSubview(imageView)
        self.addSubview(nameLabel)
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.widthAnchor.constraint(equalToConstant: Metrics.imageWidth),
            imageView.heightAnchor.constraint(equalToConstant: Metrics.imageHeight),
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: Padding.labelTop),
            nameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
}

extension MachineControllerHeaderView {
    func setName(_ name: String) {
        self.nameLabel.text = name
    }
}

// MARK: - LayoutMetrics

extension MachineControllerHeaderView {
    enum Metrics {
            static let imageWidth: CGFloat = 120
            static let imageHeight: CGFloat = 120
            static let nameLabelWidth: CGFloat = 100
            static let nameLabelHeight: CGFloat = 46
        }
        enum Padding {
            static let imageTop: CGFloat = 40
            static let labelTop: CGFloat = 20
        }
}
