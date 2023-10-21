//
//  BeerCollectionViewCell.swift
//  brewery
//
//  Created by Filipe Boeck on 20/10/23.
//

import UIKit

final class BeerCollectionViewCell: UICollectionViewCell {
    
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "placeholder.png")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var labelTitle: UILabel = {
        let label = UILabel()
        label.text = "Titulo"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var labelSubTitle: UILabel = {
        let label = UILabel()
        label.text = "Subtitulo"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemGray6
        
        self.setupView()
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addSubview(imageView)
        contentView.addSubview(labelTitle)
        contentView.addSubview(labelSubTitle)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80),
            
            labelTitle.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 25),
            labelTitle.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -15),
            labelTitle.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 15),
            
            labelSubTitle.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 10),
            labelSubTitle.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 15),
            labelSubTitle.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -15),
        ])
    }
}
