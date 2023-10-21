//
//  UICollectionReusableView.swift
//  brewery
//
//  Created by Filipe Boeck on 20/10/23.
//

import UIKit

extension UICollectionReusableView {
    class func cellIdentifier() -> String {
        identifier
    }

    final class func nib() -> UINib {
        aNib
    }

    /// Swift only
    private static var identifier: String {
        String(describing: self)
    }

    private static var aNib: UINib {
        let bundle = Bundle(for: self)

        let nib = UINib(
            nibName: identifier,
            bundle: bundle
        )

        return nib
    }
}
