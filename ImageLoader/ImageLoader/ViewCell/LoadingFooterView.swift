//
//  LoadingView.swift
//  ImageLoader
//
//  Created by Nurlan Darzhanov on 20.05.2024.
//

import Foundation
import UIKit

class LoadingFooterView: UICollectionReusableView {
    static let reuseIdentifier = "LoadingFooterView"
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        loadingIndicator.startAnimating()
    }
}
