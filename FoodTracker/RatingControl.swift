//
//  RatingControl.swift
//  FoodTracker
//
//  Created by rail bu on 15/11/28.
//  Copyright © 2015年 Rail Bu. All rights reserved.
//

import UIKit

class RatingControl: UIView {
    
    // MARK: Properties
    var rating = 0{
        didSet {
            setNeedsLayout()
        }
    }
    var ratingButtons = [UIButton]()
    var spacing = 5
    var stars = 5
    
    // MARK: Initialization
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        let filledStarImage = UIImage(named: "filledStar")
        let emptyStarImage = UIImage(named: "emptyStar")
        
        for _ in 0..<stars {
            
            // Create a red button
            let button = UIButton()
            
            button.setImage(emptyStarImage, forState: .Normal)
            button.setImage(filledStarImage, forState: .Selected)
            button.setImage(filledStarImage, forState: [.Highlighted, .Selected])
            
            button.adjustsImageWhenHighlighted = false
            
            button.addTarget(self, action: "ratingButtonTapped:", forControlEvents: .TouchDown)
            
            ratingButtons += [button]
            
            // The addSubview() method adds the button you created to the RatingControl view.
            addSubview(button)
        }
    }
    
    override func layoutSubviews() {
        
        // Set the button's width and height to a square the size of the frame's height.
        let buttonSize = Int(frame.size.height)
        
        var buttonFrame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
        
        // Offset each button's origin by the length of the button plus spacing.
        for (index, button) in ratingButtons.enumerate() {
            buttonFrame.origin.x = CGFloat(index * (buttonSize + spacing))
            button.frame = buttonFrame
        }
        
        updateButtonSelectionStates()
    }
    
    override func intrinsicContentSize() -> CGSize {
        let buttonSize = Int(frame.size.height)
        let width = (buttonSize + spacing) * stars
        
        return CGSize(width: width, height: buttonSize)
    }
    
    // MARK: Button Action
    func ratingButtonTapped(button: UIButton) {
        
        // 等级等于当前按下的button在数组中的位置加1
        rating = ratingButtons.indexOf(button)! + 1
        
        updateButtonSelectionStates()
    }
    
    func updateButtonSelectionStates() {
        
        for (index, button) in ratingButtons.enumerate() {
            // If the index of a button is less than the rating, that button should be selected.
            button.selected = index < rating
        }
    }
    
}
