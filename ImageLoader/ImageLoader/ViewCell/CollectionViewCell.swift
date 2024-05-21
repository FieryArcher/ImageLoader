//
//  CollectionViewCell.swift
//  ImageLoader
//
//  Created by Nurlan Darzhanov on 20.05.2024.
//

import Foundation
import UIKit
import SnapKit

class CollectionViewCell: UICollectionViewCell {
    
    static var itemID = "CatalogCell"
    
    private var model: ItemModel?
    
    private lazy var image: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    private lazy var title: UILabel = {
        var title = UILabel()
        title.font = .systemFont(ofSize: 16, weight: .semibold)
        title.textColor = .black
        return title
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
//        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        image.frame = contentView.bounds
    }
    
    func setup(with model: ItemModel) {
        self.model = model
        title.text = model.title
        title.numberOfLines = 0
        loadImage(from: URL(string: model.url)!)
        self.backgroundColor = .white
        self.layer.cornerRadius = 10
        
        [image, title].forEach {
            self.contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        image.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        title.snp.makeConstraints { make in
            make.bottom.equalTo(image.snp.bottom).offset(-16)
            make.leading.equalTo(image.snp.leading).offset(16)
            make.trailing.equalTo(image.snp.trailing).offset(-16)
        }
    }
    
    func loadImage(from url: URL) {
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self, let data = data, error == nil else {
                print("Ошибка при загрузке изображения: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            DispatchQueue.main.async {
                self.image.image = UIImage(data: data)
            }
        }
        task.resume()
    }
    
    
}
