//
//  ViewController.swift
//  ImageLoader
//
//  Created by Nurlan Darzhanov on 20.05.2024.
//

import UIKit

class ViewController: UIViewController {

    var collectionView: UICollectionView!
    
    var models: [ItemModel] = []
    //Pagination
    var paginationModels: [ItemModel] = []
    var currentPage = 0
    let pageSize = 12
    var isLoading = false
    
    let loadingIndicator = UIActivityIndicatorView(style: .large)
    
    private lazy var dataService = DataService.shared
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.dataService.getItems(completion: { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                self.models = data
                self.paginationModels = Array(models.prefix(self.pageSize))
                self.currentPage = 1
                
                DispatchQueue.main.async{
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print(String(describing: error))
            }
        })
            
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.itemID)
        collectionView.register(LoadingFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: LoadingFooterView.reuseIdentifier)

        self.view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
}


extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return paginationModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.itemID, for: indexPath) as! CollectionViewCell
        cell.backgroundColor = .blue
        let item = paginationModels[indexPath.item]
        cell.setup(with: item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedURL = paginationModels[indexPath.item].url // Здесь получаем картинку из данных
        
        let imageViewController = ImageViewController()
        imageViewController.modalPresentationStyle = .fullScreen
        imageViewController.url = selectedURL
        
        present(imageViewController, animated: true, completion: nil)
    }
    
}


extension ViewController: UICollectionViewDelegateFlowLayout {
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { (context) in
            self.collectionView.collectionViewLayout.invalidateLayout()
        }, completion: nil)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let isPortrait = screenWidth < screenHeight
        let itemsPerRow: CGFloat = isPortrait ? 1 : 3
        let paddingSpace = 10 * (itemsPerRow + 1) // Assuming 10 points spacing between items
        let availableWidth = collectionView.bounds.width - paddingSpace
        let widthPerItem: CGFloat
        let heightPerItem: CGFloat
        
        if isPortrait {
            widthPerItem = availableWidth
            heightPerItem = widthPerItem / 1.5 // Assuming width is 1.5 times greater than height in portrait mode
        } else {
            let squareSide = availableWidth / itemsPerRow
            widthPerItem = squareSide
            heightPerItem = squareSide
        }
        
        return CGSize(width: widthPerItem, height: heightPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10 // Spacing between rows
    }
//    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10 // Spacing between items
    }
}


extension ViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if shouldLoadMoreData() && !isLoading {
//            collectionView.reloadSections(IndexSet(integer: 0))  // Force the collection view to update the footer
            loadMoreData()
        }
    }
    
    
    func loadMoreData() {
        guard !isLoading, shouldLoadMoreData() else { return }

        isLoading = true

        DispatchQueue.global().asyncAfter(deadline: .now() + 2.0) {
            let startIndex = self.currentPage * self.pageSize
            let endIndex = min(startIndex + self.pageSize, self.models.count)
            let newData = Array(self.models[startIndex..<endIndex])
            
//            self.paginationModels.append(contentsOf: newData)
            self.currentPage += 1
            
            DispatchQueue.main.async {
                self.paginationModels.append(contentsOf: newData)
                self.collectionView.reloadSections(IndexSet(integer: 0))  // Update the footer view visibility
                self.isLoading = false
            }
        }
    }

    func shouldLoadMoreData() -> Bool {
        guard let collectionView = collectionView else { return false }
        let contentOffsetY = collectionView.contentOffset.y
        let contentHeight = collectionView.contentSize.height
        let frameHeight = collectionView.frame.size.height
        return contentOffsetY > contentHeight - frameHeight
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return isLoading ? CGSize(width: collectionView.bounds.width, height: 50) : CGSize.zero
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: LoadingFooterView.reuseIdentifier, for: indexPath) as! LoadingFooterView
            return footerView
        }
        return UICollectionReusableView()
    }
}


