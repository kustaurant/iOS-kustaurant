//
//  UIView+AutoLayout.swift
//  Kustaurant
//
//  Created by 류연수 on 7/31/24.
//

import UIKit

extension UIView: Ku {
    var ku: Self { self }
    
    enum Layout {
        case top(CGFloat)
        case leading(CGFloat)
        case bottom(CGFloat)
        case trailing(CGFloat)
        
        case topSafeArea(constant: CGFloat)
        case leadingSafeArea(constant: CGFloat)
        case bottomSafeArea(constant: CGFloat)
        case trailingSafeArea(constant: CGFloat)
        
        case topEqual(to: UIView, constant: CGFloat)
        case leadingEqual(to: UIView, constant: CGFloat)
        case bottomEqual(to: UIView, constant: CGFloat)
        case trailingEqual(to: UIView, constant: CGFloat)
        
        case widthEqual(to: UIView, constant: CGFloat)
        case heightEqual(to: UIView, constant: CGFloat)
        
        case topNext(to: UIView, constant: CGFloat)
        case leadingNext(to: UIView, constant: CGFloat)
        case trailingNext(to: UIView, constant: CGFloat)
        
        case centerX(CGFloat)
        case centerY(CGFloat)
        case center(CGFloat)
        
        case width(CGFloat)
        case height(CGFloat)
        
        case fillX(CGFloat)
        case fillY(CGFloat)
        case fill(CGFloat)
        
        case bottomKeyboard(CGFloat)
    }
    
    enum SizeLayout {
        case width(CGFloat)
        case height(CGFloat)
        
        case widthEqual(to: UIView, constant: CGFloat)
        case heightEqual(to: UIView, constant: CGFloat)
    }
}

extension Ku where Self: UIView {
    
    func addSubview(_ view: UIView, autoLayout: [UIView.Layout] = []) {
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        
        let layouts = autoLayout.map({ layout in
            switch layout {
            case .top(let constant): [view.topAnchor.constraint(equalTo: self.topAnchor, constant: constant)]
            case .leading(let constant): [view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: constant)]
            case .bottom(let constant): [view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -constant)]
            case .trailing(let constant): [view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -constant)]
                
            case .topSafeArea(let constant): [view.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: constant)]
            case .leadingSafeArea(let constant): [view.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: constant)]
            case .bottomSafeArea(let constant): [view.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -constant)]
            case .trailingSafeArea(let constant): [view.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -constant)]
                
            case .topEqual(let to, let constant): [view.topAnchor.constraint(equalTo: to.topAnchor, constant: constant)]
            case .leadingEqual(let to, let constant): [view.leadingAnchor.constraint(equalTo: to.leadingAnchor, constant: constant)]
            case .bottomEqual(let to, let constant): [view.bottomAnchor.constraint(equalTo: to.bottomAnchor, constant: -constant)]
            case .trailingEqual(let to, let constant): [view.trailingAnchor.constraint(equalTo: to.trailingAnchor, constant: -constant)]
                
            case .widthEqual(let to, let constant): [view.widthAnchor.constraint(equalTo: to.widthAnchor, constant: constant)]
            case .heightEqual(let to, let constant): [view.heightAnchor.constraint(equalTo: to.heightAnchor, constant: constant)]
                
            case .topNext(let to, let constant): [view.topAnchor.constraint(equalTo: to.bottomAnchor, constant: constant)]
            case .leadingNext(let to, let constant): [view.leadingAnchor.constraint(equalTo: to.trailingAnchor, constant: constant)]
            case .trailingNext(let to, let constant): [view.trailingAnchor.constraint(equalTo: to.leadingAnchor, constant: -constant)]
                
            case .centerX(let constant): [view.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: constant)]
            case .centerY(let constant): [view.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: constant)]
            case .center(let constant): [
                view.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: constant),
                view.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: constant)
            ]
                
            case .width(let constant): [view.widthAnchor.constraint(equalToConstant: constant)]
            case .height(let constant): [view.heightAnchor.constraint(equalToConstant: constant)]
                
            case .fillX(let constant): [
                view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: constant),
                view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -constant)
            ]
            case .fillY(let constant): [
                view.topAnchor.constraint(equalTo: self.topAnchor, constant: constant),
                view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -constant)
            ]
            case .fill(let constant): [
                view.topAnchor.constraint(equalTo: self.topAnchor, constant: constant),
                view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: constant),
                view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -constant),
                view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -constant)
            ]
            case .bottomKeyboard(let constant): [
                view.bottomAnchor.constraint(equalTo: self.keyboardLayoutGuide.topAnchor, constant: -constant)
            ]
            }
        }).flatMap { $0 }
        NSLayoutConstraint.activate(layouts)
    }
    
    func autolayout(_ layout: [SizeLayout]) {
        let layouts = layout.map({ layout in
            switch layout {
            case .width(let constant): [self.widthAnchor.constraint(equalToConstant: constant)]
            case .height(let constant): [self.heightAnchor.constraint(equalToConstant: constant)]
                
            case .widthEqual(let to, let constant): [self.widthAnchor.constraint(equalTo: to.widthAnchor, constant: constant)]
            case .heightEqual(let to, let constant): [self.heightAnchor.constraint(equalTo: to.heightAnchor, constant: constant)]
            }
        }).flatMap { $0 }
        NSLayoutConstraint.activate(layouts)
    }
}

class SpaceView: UIView {
    
    init(size: CGFloat = 10, for layout: NSLayoutConstraint.Axis = .horizontal) {
        super.init(frame: .zero)
        
        widthAnchor.constraint(greaterThanOrEqualToConstant: size).isActive = true
        heightAnchor.constraint(greaterThanOrEqualToConstant: size).isActive = true
        
        setContentHuggingPriority(.defaultLow, for: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
