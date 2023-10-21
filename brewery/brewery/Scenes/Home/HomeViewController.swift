//
//  HomeViewController.swift
//  brewery
//
//  Created by Filipe Boeck on 20/10/23.
//

import UIKit

private enum Section: Hashable {
    case main
}

private enum Item: Hashable {
    case beer(Beer)
}

final class HomeViewController: UIViewController {
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout.init())
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .none
        view.register(BeerCollectionViewCell.self, forCellWithReuseIdentifier: BeerCollectionViewCell.cellIdentifier())
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        view.backgroundColor = UIColor(cgColor: CGColor(red: 244, green: 244, blue: 244, alpha: 1.0))
        setupDataSource()
        setupLayout()
        setupConstraint()
        
        var recentsSnapshot = NSDiffableDataSourceSectionSnapshot<Item>()
        recentsSnapshot.append([Item.beer(Beer(id: 1, name: "teste", tagline: "teste", description: "testew", imageURL: "teste"))])
        
        self.dataSource?.apply(recentsSnapshot, to: .main, animatingDifferences: false)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let sectionLayout: NSCollectionLayoutSection
            
            let itemSize: NSCollectionLayoutSize = .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(101))
            let item: NSCollectionLayoutItem = .init(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            
            let groupSize: NSCollectionLayoutSize = .init(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let group: NSCollectionLayoutGroup = .vertical(layoutSize: groupSize, subitems: [item])
            
            sectionLayout = NSCollectionLayoutSection(group: group)
            
            return sectionLayout
        }
        
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }
    
    private func setupDataSource() {
        self.dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: Item) -> UICollectionViewCell? in
            
            switch item {
                
            case .beer:
                
                let cell: BeerCollectionViewCell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: BeerCollectionViewCell.cellIdentifier(),
                    for: indexPath
                ) as! BeerCollectionViewCell
                
                return cell
            }
        }
    }
    
    private func setupLayout() {
        view.addSubview(collectionView)
        collectionView.collectionViewLayout = createLayout()
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}
