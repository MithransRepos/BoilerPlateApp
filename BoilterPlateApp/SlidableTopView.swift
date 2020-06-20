//
//  SlidableTopView.swift
//  BoilterPlateApp
//
//  Created by MithranN on 19/06/20.
//  Copyright © 2020 MithranN. All rights reserved.
//

import UIKit
import MithranSwiftKit

class SlidableTopView: UIView, UIGestureRecognizerDelegate {
    
    public var minSwipePercentageToSnap: CGFloat = 10
    public var targetSnapPercentage: CGFloat = 40
    
    private let bottomView = UIView()
    private let topView = UIView()
    private var topViewTransformedValue: CGFloat = .zero
    
    private var targetSnapPoint: CGFloat {
        if topView.frame.size.width == .zero {
            self.layoutIfNeeded()
        }
        return topView.frame.size.width * targetSnapPercentage/100
    }
    
    private var minSwipeToSnap: CGFloat {
         return (topView.frame.size.width * minSwipePercentageToSnap)/100
     }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(bottomView)
        addSubview(topView)
        
        layer.cornerRadius = 10
        layer.masksToBounds = true
        topView.backgroundColor = .black
        bottomView.backgroundColor = .gray
        topView.layer.cornerRadius = 8
        
        bottomView.set(.fillSuperView(self))
        topView.set(.fillSuperView(self,8))
        
        let panGesture = UIPanGestureRecognizer(target: self, action:#selector(handlePanGesture))
        panGesture.delegate = self
        topView.addGestureRecognizer(panGesture)
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGestureRecognizer.translation(in: superview!)
            if abs(translation.x) > abs(translation.y) {
                return true
            }
            return false
        }
        return false
    }
    
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translationX = gesture.translation(in: self).x
        switch gesture.state {
        case .changed:
            let maxSlideAllowed = translationX > .zero ? targetSnapPoint : -targetSnapPoint
            let newTranformValue = topViewTransformedValue + translationX
            if (topViewTransformedValue > .zero && newTranformValue > topViewTransformedValue) ||
                (topViewTransformedValue < .zero && newTranformValue < topViewTransformedValue) ||
                (translationX > .zero &&  translationX > maxSlideAllowed) || (translationX < .zero &&  translationX < maxSlideAllowed) {
                return
            }
            self.topView.transform = CGAffineTransform(translationX: topViewTransformedValue + translationX, y: .zero)
        case .ended:
            let transformedValue = translationX + self.topViewTransformedValue
            if topViewTransformedValue != .zero {
                if (topViewTransformedValue > .zero && transformedValue > topViewTransformedValue)
                    || (topViewTransformedValue < .zero && transformedValue < topViewTransformedValue) {
                    return
                }
                snapTopViewToOriginalPosition(animated: true)
                return
            }
            if transformedValue > .zero && transformedValue > minSwipeToSnap {
                snapTopViewToPoint(targetSnapPoint)
            }else if transformedValue < .zero && transformedValue < -minSwipeToSnap {
                snapTopViewToPoint(-targetSnapPoint)
            }else {
                snapTopViewToOriginalPosition(animated: true)
            }
            
        default:
            break
        }
    }
    
    private func snapTopViewToPoint(_ point: CGFloat) {
        UIView.animate(withDuration: 0.45, delay: .zero, usingSpringWithDamping: 1,
                       initialSpringVelocity: 0.2, options: .curveEaseIn, animations: {
                        self.topView.transform = CGAffineTransform(translationX: point, y: .zero)
                        self.topViewTransformedValue = self.topView.frame.origin.x
        },completion: nil)
    }
    
    private func snapTopViewToOriginalPosition(animated: Bool) {
        let duration = animated ? 0.45 : .zero
        UIView.animate(withDuration: duration, delay: .zero, usingSpringWithDamping: 1,
                       initialSpringVelocity: 0.2, options: .curveEaseIn, animations: {
                        self.topView.transform = .identity
                        self.topViewTransformedValue = .zero
        },completion: nil)
    }
    
    func prepareForReuse() {
        snapTopViewToOriginalPosition(animated: false)
    }
    
    public func showActionTutorial() -> Bool {
        snapTopViewToPoint(-targetSnapPoint)
        return topViewTransformedValue != .zero
    }
    
}
