//
//  Extensions.swift
//  CircularWordsCloud
//
//  Created by 최민섭 on 2020/01/16.
//

import Foundation

@available(iOS 9.0, *)
extension UIView {
    var safeAreaInsetDegree: CGFloat {
        if #available(iOS 11.0, *) { return 40 }
        else { return 0 }
    }
    
    func addShadowOnLabel(shadowColor: CGColor = UIColor.black.cgColor) {
        self.layer.shadowOpacity = 0.6
        self.layer.shadowColor = shadowColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    func anchor(position: CircularWordsCloudPosition) {
        translatesAutoresizingMaskIntoConstraints = false
        
        guard let superview = superview else {return}
        
        switch position {
        case .top:
            NSLayoutConstraint.activate([
                topAnchor.constraint(equalTo: superview.topAnchor,
                                     constant: 40 + safeAreaInsetDegree),
                centerXAnchor.constraint(equalTo: superview.centerXAnchor)
            ])
        case .center:
            NSLayoutConstraint.activate([
                centerXAnchor.constraint(equalTo: superview.centerXAnchor),
                centerYAnchor.constraint(equalTo: superview.centerYAnchor)
            ])
        case .bottom:
            NSLayoutConstraint.activate([
                centerXAnchor.constraint(equalTo: superview.centerXAnchor),
                bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -safeAreaInsetDegree - 40)
            ])
        }
        
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalTo: superview.widthAnchor, multiplier: 0.7),
            heightAnchor.constraint(equalTo: superview.widthAnchor, multiplier: 0.7)
        ])
    }
    
    func fadeOut(until alpha: CGFloat = 0.3, during: Double = 0.5) {
        UIView.animate(withDuration: during, animations: {
            self.alpha = alpha
        })
    }
    
    func fadeIn(during: Double = 1) {
        UIView.animate(withDuration: during, animations: {
            self.alpha = 1
        })
    }
    
    func bounce(completion: @escaping() -> Void = {}) {
        var targetFrame = self.frame
        targetFrame.origin.y -= 5
        self.frame = targetFrame
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.2, options: .curveEaseOut, animations: {
            targetFrame.origin.y += 5
            self.frame = targetFrame
        }) { res in
            completion()
        }
    }
    
    
    func changeAlphaWithAnimation(alpha: CGFloat) {
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = alpha
        })
    }
}
