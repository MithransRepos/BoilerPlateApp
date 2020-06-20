//
//  SlidingViewTVCell.swift
//  BoilterPlateApp
//
//  Created by MithranN on 19/06/20.
//  Copyright © 2020 MithranN. All rights reserved.
//

import MithranSwiftKit
import UIKit
class SlidingTopViewTVCell: BaseTableViewCell {
    let slidingTopView = SlidableTopView(frame: .zero)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addViews() {
        super.addViews()
        contentView.addSubview(slidingTopView)
        
    }

    override func setConstraints() {
        super.setConstraints()
        slidingTopView.set(.sameLeadingTrailing(contentView, 12), .sameTopBottom(contentView, 12), .height(200))
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        slidingTopView.prepareForReuse()
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
}
