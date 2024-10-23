//
//  extensionCollectionView.swift
//  JukoLock
//
//  Created by 김경호 on 10/23/24.
//

import UIKit

extension UICollectionView {
    func setEmptyView(_ message: String) {
        let emptyView = UIView(frame: self.bounds)
        
        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.textColor = .lightGray
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = .preferredFont(forTextStyle: .body)
        messageLabel.sizeToFit()
        
        emptyView.addSubview(messageLabel)
        messageLabel.center = emptyView.center
        
        self.backgroundView = emptyView
    }

    func restoreCollectionView() {
        self.backgroundView = nil
    }
}
