//
//  ReuseableCell.swift
//  Upupme
//
//  Created by Duong Khong on 7/22/16.
//  Copyright © 2016 Upupme. All rights reserved.
//

import Foundation
import UIKit

// MARK: ReusableView

/**
 Handy extension which help us create reuse identifier for UITableViewCell, UICollectionViewCell
 base on their class name
*/
protocol ReusableView: class {}
extension ReusableView where Self: UIView {
    
    /// reuseIDentifier base on String from class name
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReusableView {}
extension UITableViewHeaderFooterView: ReusableView {}
extension UICollectionViewCell: ReusableView {}



// MARK: NibLoadableView
/**
 Handy extension which help us create nib name for UITableViewCell, UICollectionViewCell
 base on their class name
 */
protocol NibLoadableView: class { }
extension NibLoadableView where Self: UIView {
    
    /// NibName base on String from class name
    static var NibName: String {
        return String(describing: self)
    }
}

extension UITableViewCell: NibLoadableView {}
extension UITableViewHeaderFooterView: NibLoadableView {}
extension UICollectionViewCell: NibLoadableView {}



extension UITableView {
    func register<T: UITableViewCell>(_: T.Type) where T: ReusableView, T: NibLoadableView {
        let bundle = Bundle(for: T.self)
        let Nib = UINib(nibName: T.NibName, bundle: bundle)
        register(Nib, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    func register<T: UITableViewHeaderFooterView>(_: T.Type) where T: ReusableView, T: NibLoadableView {
        let bundle = Bundle(for: T.self)
        let Nib = UINib(nibName: T.NibName, bundle: bundle)
        register(Nib, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T where T: ReusableView {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }
    
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T where T: ReusableView {
        guard let cell = dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as? T else {
            fatalError("Could not dequeue header footer with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }
}



extension UICollectionView {
    func register<T: UICollectionViewCell>(_: T.Type) where T: ReusableView, T: NibLoadableView {
        let bundle = Bundle(for: T.self)
        let Nib = UINib(nibName: T.NibName, bundle: bundle)
        register(Nib, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T where T: ReusableView {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }
}




