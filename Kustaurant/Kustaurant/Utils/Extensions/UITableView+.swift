//
//  UITableView+.swift
//  Kustaurant
//
//  Created by 류연수 on 7/31/24.
//

import UIKit

extension Ku where Self: UITableView {
    
    func registerCell(
        ofType cellType: UITableViewCell.Type,
        withReuseIdentifier identifier: String? = nil
    ) {
        let reuseIdentifier = identifier ?? String(describing: cellType.self)
        self.register(cellType, forCellReuseIdentifier: reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(
        withReuseIdentifier identifier: String? = nil,
        for indexPath: IndexPath
    ) -> T {
        let reuseIdentifier = identifier ?? String(describing: T.self)
        
        guard let cell = self.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? T
        else { return .init() }
        
        return cell
    }
    
    func registerHeaderFooterView(
        ofType viewType: UICollectionReusableView.Type,
        withReuseIdentifier identifier: String? = nil
    ) {
        let reuseIdentifier = identifier ?? String(describing: viewType.self)
        self.register(viewType, forHeaderFooterViewReuseIdentifier: reuseIdentifier)
    }
    
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(
        withReuseIdentifier identifier: String? = nil
    ) -> T {
        let reuseIdentifier = identifier ?? String(describing: T.self)
        
        guard let view = self.dequeueReusableHeaderFooterView(withIdentifier: reuseIdentifier) as? T
        else { fatalError("dequeueReusableSupplementaryView(identifier:) can not dequeue \(reuseIdentifier)") }
        
        return view
    }
}
