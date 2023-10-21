//
//  BeerCollectionViewCell.swift
//  brewery
//
//  Created by Filipe Boeck on 20/10/23.
//

import UIKit

final class BeerCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .yellow
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
        ])
    }
    
}
