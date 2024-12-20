//
//  UITableviewExt.swift
//  live
//
//  Created by Maulik Shah on 12/19/24.
//

import UIKit

public extension UITableView {
    func register<T: UITableViewCell>(cellType: T.Type, bundle: Bundle? = nil) {
        let className = cellType.className
        let nib = UINib(nibName: className, bundle: bundle)
        register(nib, forCellReuseIdentifier: className)
    }
    
    func register<T: UITableViewCell>(cellTypes: [T.Type], bundle: Bundle? = nil) {
        cellTypes.forEach { register(cellType: $0, bundle: bundle) }
    }
    
    
    func dequeueReusableCell<T: UITableViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withIdentifier: type.className, for: indexPath) as! T
    }
    
    /* use like this
    tableView.register(cellType: MyCell.self)
    tableView.register(cellTypes: [MyCell1.self, MyCell2.self])

    let cell = tableView.dequeueReusableCell(with: MyCell.self, for: indexPath)
    */
    
       func layoutTableHeaderView() {

           guard let headerView = self.tableHeaderView else { return }
           headerView.translatesAutoresizingMaskIntoConstraints = false

           let headerWidth = headerView.bounds.size.width
           let temporaryWidthConstraint = headerView.widthAnchor.constraint(equalToConstant: headerWidth)

           headerView.addConstraint(temporaryWidthConstraint)

           headerView.setNeedsLayout()
           headerView.layoutIfNeeded()

           let headerSize = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
           let height = headerSize.height
           var frame = headerView.frame

           frame.size.height = height
           headerView.frame = frame

           self.tableHeaderView = headerView

           headerView.removeConstraint(temporaryWidthConstraint)
           headerView.translatesAutoresizingMaskIntoConstraints = true
       }
}

class DynamicSizeTableView: UITableView {

    var maxHeight = CGFloat.infinity

       override var contentSize: CGSize {
           didSet {
               invalidateIntrinsicContentSize()
               setNeedsLayout()
           }
       }

       override var intrinsicContentSize: CGSize {
           self.layoutIfNeeded()
           let height = min(maxHeight, contentSize.height)
           return CGSize(width: contentSize.width, height: height)
       }
    
    override func reloadData() {
       super.reloadData()
       self.invalidateIntrinsicContentSize()
        self.layoutIfNeeded()
     }
    
}



 
