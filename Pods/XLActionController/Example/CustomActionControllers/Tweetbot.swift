//  Tweetbot.swift
//  Tweetbot ( https://github.com/xmartlabs/XLActionController )
//
//  Copyright (c) 2015 Xmartlabs ( http://xmartlabs.com )
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation
#if XLACTIONCONTROLLER_EXAMPLE
import XLActionController
#endif

public class TweetbotCell: ActionCell {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    func initialize() {
        actionTitleLabel?.font = UIFont(name: "Montserrat", size: 18)
        actionTitleLabel?.textColor = .whiteColor()
        actionTitleLabel?.textAlignment = .Center
        backgroundColor = UIColor(red: 93/255, green: 93/255, blue: 93/255, alpha: 1.0)
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 251/255, green: 127/255, blue: 6/255, alpha: 1.0)  //blue 0.54
        selectedBackgroundView = backgroundView
    }
}

public class TweetbotActionController: DynamicsActionController<TweetbotCell, String, UICollectionReusableView, Void, UICollectionReusableView, Void> {
    
    public override init(nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: NSBundle? = nil) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        backgroundView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        settings.animation.present.duration = 0.5
        settings.animation.dismiss.duration = 0.5
        settings.behavior.bounces = true
        settings.behavior.useDynamics = true
        collectionView.contentInset = UIEdgeInsets(top: 0.0, left: 12.0, bottom: 6.0, right: 12.0)
        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 6.0, right: 0.0)
        
        cellSpec = .NibFile(nibName: "TweetbotCell", bundle: NSBundle(forClass: TweetbotCell.self), height: { _  in 50 })
        
        onConfigureCellForAction = { [weak self] cell, action, indexPath in
            
            cell.setup(action.data, detail: nil, image: nil)
            let actions = self?.sectionForIndex(indexPath.section)?.actions
            let actionsCount = actions!.count
            cell.separatorView?.hidden = indexPath.item == (self?.collectionView.numberOfItemsInSection(indexPath.section))! - 1
            cell.backgroundColor = action.style == .Cancel ? UIColor(white: 0.23, alpha: 1.0) : .darkGrayColor()
            cell.alpha = action.enabled ? 1.0 : 0.5
            
            var corners = UIRectCorner()
            if indexPath.item == 0 {
                corners = UIRectCorner.TopLeft.union(.TopRight)
            }
            if indexPath.item == actionsCount - 1 {
                corners = corners.union(.BottomLeft).union(.BottomRight)
            }
            
            if corners == UIRectCorner.AllCorners {
                cell.layer.mask = nil
                cell.layer.cornerRadius = 8.0
            } else {
                let borderMask = CAShapeLayer()
                borderMask.frame = cell.bounds
                borderMask.path = UIBezierPath(roundedRect: cell.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: 8.0, height: 8.0)).CGPath
                cell.layer.mask = borderMask
            }
        }
    }
}
