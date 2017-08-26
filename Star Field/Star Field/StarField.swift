//
//  StarField.swift
//  Star Field
//
//  Created by Florent Fondacci on 20/08/2017.
//  Copyright © 2017 Florent Fondacci. All rights reserved.
//

import UIKit
import Foundation

@IBDesignable
class StarField: UIView {
    
    var starFieldLayer: CALayer = CALayer()
    let nbStars = 300

    override init(frame: CGRect) {
        super.init(frame: frame)
        print("frame 2 = \(frame.size.width) -- height 2 = \(frame.size.height)")
        self.setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUp()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.starFieldLayer.position = CGPoint(x: Int(frame.size.width / 2), y: Int(frame.size.height / 2))
    }
    
    func setUp () {
        self.layer.addSublayer(self.starFieldLayer)
        self.backgroundColor = UIColor.clear
        self.buildStarField()
    }
    
    private func buildStarField () {
        
        
        // this transformation is needed to get a z position on a sublayer, will explain later
        var transform = CATransform3DMakeRotation(0, 0, 1, 0)
        transform = CATransform3DRotate(transform, 0, 1, 0, 0)
        let zDistance = 450
        transform.m34 = CGFloat(1.0 / Double(zDistance))
        
        self.starFieldLayer.sublayerTransform = transform
        
        let width = self.frame.size.width / 1.5
        let height = self.frame.size.height / 1.5
        
        for _ in 1...nbStars {
            
            let x = Float.random(from: -(Float)(width), Float(width))
            let y = Float.random(from: -(Float)(height), Float(height))
            
            let layer = CALayer()
            layer.frame = CGRect(x: CGFloat(x), y: CGFloat(y), width: 10, height: 10)
            
            // Layer content :
            let whichContent = Int.random(from: 1, 4)
            layer.contents = UIImage(named: "starfield-star-\(whichContent)")?.cgImage
            
            // Layer bounds :
            let size = layer.preferredFrameSize()
            layer.bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            
            // Animation:
            let duration = Double(Float.random(from: 2, 30))
            
            // TO DO: not elegant for swift, will change later. 
            // Where the stars will stop in their position max value ?
            let boundsToValue = (self.frame.size.width > self.frame.size.height) == true ? (Float(self.frame.size.width) + Float.random(from: 0, 50)) : (Float(self.frame.size.height) + Float.random(from: 0, 50))
            
            // Where the stars will start away from center max value ?
            let boundsFromValue = (self.frame.size.width > self.frame.size.height) == true ? (Float(self.frame.size.width) * 50 / 100) : (Float(self.frame.size.height) * 50 / 100)
            
                // position
            let positionAnimation = CABasicAnimation(keyPath: "zPosition")
            // FromValue will determinate the how far from the center the stars will start
            positionAnimation.fromValue = NSNumber(value: Float.random(from: 100, boundsFromValue))
            // Tovalue will determinate how far the stars will get more near from the center
            positionAnimation.toValue = NSNumber(value: Float.random(from: -200, -(boundsToValue)))
            positionAnimation.duration = duration
            positionAnimation.repeatCount = Float.infinity
            positionAnimation.isRemovedOnCompletion = false
            
                // Opacity
            let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
            opacityAnimation.values = [0.0, 1.0, 1.0, 0.0]
            opacityAnimation.duration = duration
            opacityAnimation.repeatCount = Float.infinity
            opacityAnimation.isRemovedOnCompletion = true
            
                // Rotation
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
            rotationAnimation.fromValue = 0.0
            rotationAnimation.toValue = Float.pi
            rotationAnimation.duration = 10
            rotationAnimation.autoreverses = true
            rotationAnimation.repeatCount = Float.infinity
            rotationAnimation.isCumulative = true
            rotationAnimation.isRemovedOnCompletion = false
            

            let groupAnimation = CAAnimationGroup()
            groupAnimation.animations = [positionAnimation,opacityAnimation,rotationAnimation]
            groupAnimation.isRemovedOnCompletion = false
            groupAnimation.repeatCount = Float.infinity
            groupAnimation.duration = positionAnimation.duration

            layer.add(groupAnimation, forKey: "groupStarAnimation")
            
            self.starFieldLayer.addSublayer(layer)

        }
        
        
    }
    
}
