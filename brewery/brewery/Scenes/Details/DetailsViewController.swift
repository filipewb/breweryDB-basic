//
//  DetailsViewController.swift
//  brewery
//
//  Created by Filipe Boeck on 20/10/23.
//

import UIKit

class DetailsViewController: UIViewController {
    var selectedItem: Beer?
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()

    private lazy var image: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var labelTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var labelSubTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Detalhes"
        view.backgroundColor = UIColor(cgColor: CGColor(red: 250, green: 250, blue: 250, alpha: 1.0))
        
        if let selectedItem = selectedItem {
            labelTitle.text = selectedItem.name
            labelSubTitle.text = selectedItem.tagline
            descriptionLabel.text = selectedItem.description
            
            if let imageURL = selectedItem.imageURL {
                URLSession.shared.dataTask(with: imageURL) { data, response, error in
                    if let data = data {
                        DispatchQueue.main.async {
                            if let image = UIImage(data: data) {
                                self.image.image = image
                            } else {
                                self.image.image = UIImage(named: "placeholder.png")
                            }
                        }
                    } else if let error = error {
                        print("Erro ao carregar imagem: \(error.localizedDescription)")
                        self.image.image = UIImage(named: "placeholder.png")
                    }
                }.resume()
            } else {
                self.image.image = UIImage(named: "placeholder.png")
            }
        }
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = .white
        self.navigationItem.leftBarButtonItem = backButton
        
        let favoriteButton = UIBarButtonItem(image: UIImage(systemName: "star"), style: .plain, target: self, action: #selector(favoriteButtonTapped))
        favoriteButton.tintColor = .white
        self.navigationItem.rightBarButtonItem = favoriteButton
        
        if let selectedItem = selectedItem {
            if selectedItem.isFavorite {
                self.navigationItem.rightBarButtonItem?.image = UIImage(systemName: "star.fill")
            } else {
                self.navigationItem.rightBarButtonItem?.image = UIImage(systemName: "star")
            }
        }
        
        if let selectedItem = selectedItem {
            var updatedBeer = selectedItem
            updatedBeer.isFavorite = isBeerFavorite(item: selectedItem)
            self.selectedItem = updatedBeer
            updateFavoriteButtonUI()
            saveFavoriteBeers()
        }
        
        setupView()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        updateFavoriteButtonUI()
    }
    
    private func setupView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(image)
        contentView.addSubview(labelTitle)
        contentView.addSubview(labelSubTitle)
        contentView.addSubview(descriptionLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            image.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            image.widthAnchor.constraint(equalToConstant: 160),
            image.heightAnchor.constraint(equalToConstant: 160),
            
            labelTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 35),
            labelTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            labelTitle.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 15),
            
            labelSubTitle.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 10),
            labelSubTitle.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 15),
            labelSubTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            descriptionLabel.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 30),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func favoriteButtonTapped() {
        selectedItem?.isFavorite.toggle()
        updateFavoriteButtonUI()

        saveFavoriteBeers()
    }

    func updateFavoriteButtonUI() {
        if selectedItem?.isFavorite ?? false {
            self.navigationItem.rightBarButtonItem?.image = UIImage(systemName: "star.fill")
        } else {
            self.navigationItem.rightBarButtonItem?.image = UIImage(systemName: "star")
        }
    }

    func saveFavoriteBeers() {
        var favoriteBeerIds = UserDefaults.standard.array(forKey: "favoriteBeerIds") as? [Int] ?? []

        if let selectedItem = selectedItem {
            if selectedItem.isFavorite {
                if !favoriteBeerIds.contains(selectedItem.id) {
                    favoriteBeerIds.append(selectedItem.id)
                }
            } else {
                if let index = favoriteBeerIds.firstIndex(of: selectedItem.id) {
                    favoriteBeerIds.remove(at: index)
                }
            }

            UserDefaults.standard.set(favoriteBeerIds, forKey: "favoriteBeerIds")
            
            UserDefaults.standard.synchronize()
        }
    }
    
    func isBeerFavorite(item: Beer) -> Bool {
        if let favoriteBeerIds = UserDefaults.standard.array(forKey: "favoriteBeerIds") as? [Int] {
            return favoriteBeerIds.contains(item.id)
        }
        return false
    }
}
