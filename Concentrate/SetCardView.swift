//
//  SetCardView.swift
//  Set
//
//  Created by KangKang on 2017/12/10.
//  Copyright © 2017年 KangKang. All rights reserved.
//

import UIKit

class SetCardView: UIView {
    
    var count: Int = 1 { didSet { setNeedsDisplay(); setNeedsLayout() } }
    var color: UIColor = #colorLiteral(red: 0.8196078431, green: 0.1411764706, blue: 0.1960784314, alpha: 1) { didSet { setNeedsDisplay(); setNeedsLayout() } }
    var shape: Shape = .diamond { didSet { setNeedsDisplay(); setNeedsLayout() } }
    var grain: Grain = .solid { didSet { setNeedsDisplay(); setNeedsLayout() } }
    
    var isSelected = false
    var isMatched: Bool?
    var isFaceup = false { didSet { setNeedsDisplay(); setNeedsLayout() } }
    
    private weak var behavior: CardFlyawayBehavior?

    
    enum Shape {
        case diamond, oval, squiggle
        static let allValues = [diamond, oval, squiggle]
    }
    
    enum Grain {
        case solid, striped, outlined
        static let allValues = [solid, striped, outlined]
    }
    
    convenience init(_ behavior: CardFlyawayBehavior) {
        self.init(frame: CGRect.zero)
        self.behavior = behavior
        alpha = 0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        isOpaque = false
    }
    
//    private lazy var tmpCard = copyCard()
    func configState() {
        layer.cornerRadius = cornerRadius
        layer.borderWidth = patternLineWidth*2
        layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0).cgColor
//        isUserInteractionEnabled = true

        if isSelected { // highlight selected card view
            layer.borderColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1).cgColor
            if let matched = isMatched { // Already selected 3 cards
                if matched {
                    layer.borderColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1).cgColor
//                    isUserInteractionEnabled = false
                    
                    //- MARK: flyaway animation
//                    let tmpCard = copyCard()
//                    self.superview!.addSubview(tmpCard)
//                    self.behavior?.addItem(tmpCard)
//                    self.alpha = 0

//                    Timer.scheduledTimer(withTimeInterval: Constants.cardDisappearTime, repeats: false, block: { (timer) in
//                        UIView.transition(with: tmpCard, duration: 1, options: [.transitionFlipFromLeft], animations: {
//                            tmpCard.isFaceup = false
//                        }, completion: { (isComplete) in
//                            self.behavior?.remove(tmpCard)
//                            tmpCard.removeFromSuperview()
//                        })
//                    })
                    
                } else {
                    layer.borderColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1).cgColor
                }
            }
        } else {
            layer.borderWidth = 0
        }
    }
    
    func copyCard() -> SetCardView {
        let copy = SetCardView()
        copy.color = color
        copy.count = count
        copy.shape = shape
        copy.grain = grain
        copy.isFaceup = true
        copy.bounds = bounds
        copy.frame = frame
        copy.alpha = 1
        return copy
    }
    
    func animateDeal(from deckCenter: CGPoint) {
        let currentCenter = center
        center = deckCenter
//        print("cardCenter: \(deckCenter)")
        alpha = 1
        isFaceup = false
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 1, delay: 0.3, options: [], animations: {
            self.center = currentCenter
        }, completion: { position in
            UIView.transition(with: self, duration: 0.5, options: [.transitionFlipFromLeft], animations: {
                self.isFaceup = true
            })
        })
    }
    
    override func draw(_ rect: CGRect) {
        drawRoundConer(rect)
        isFaceup ? drawShape() : drawBack()
    }
    
    private func drawRoundConer(_ rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        roundedRect.addClip()
        #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).setFill()
        roundedRect.fill()
    }
    
    private func drawBack() {
        let font = UIFont(name: "Party LET", size: backFontsize)!
        let attr: [NSAttributedStringKey : Any] = [
            .font : font,
        ]
        let text = NSAttributedString(string: "K", attributes: attr)
        text.draw(at: CGPoint.zero)
    }
    
    private func drawShape() {
        switch shape {
        case .diamond:
            drawDimond()
        case .oval:
            drawOval()
        case .squiggle:
            drawSquiggle()
        }
    }
    
    private func drawDimond() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: bounds.midX, y: bounds.midY - patternHeight/2))
        path.addLine(to: CGPoint(x: bounds.midX + patternWidth/2, y: bounds.midY))
        path.addLine(to: CGPoint(x: bounds.midX, y: bounds.midY + patternHeight/2))
        path.addLine(to: CGPoint(x: bounds.midX - patternWidth/2, y: bounds.midY))
        path.close()
        
        drawPattern(with: path)
    }
    
    private func drawOval() {
        let path = UIBezierPath(ovalIn: CGRect(origin: patternOrgin, size: CGSize(width: patternWidth, height: patternHeight)))
        
        drawPattern(with: path)
    }
    
    private func drawSquiggle() {
        let path = UIBezierPath()
        path.move(to: patternOrgin.offsetBy(dx: 0, dy: patternHeight))
        let c1_1 = CGPoint(x: bounds.width*0.24, y: bounds.height*0.21)
        let c1_2 = CGPoint(x: bounds.width*0.47, y: bounds.height*0.54)
        let c2_1 = c1_1.offsetBy(dx: 2*(bounds.midX - c1_1.x), dy: 2*(bounds.midY - c1_1.y))
        let c2_2 = c1_2.offsetBy(dx: 2*(bounds.midX - c1_2.x), dy: 2*(bounds.midY - c1_2.y))
        path.addCurve(to: patternOrgin.offsetBy(dx: patternWidth, dy: 0), controlPoint1: c1_1, controlPoint2: c1_2)
        path.addCurve(to: patternOrgin.offsetBy(dx: 0, dy: patternHeight), controlPoint1: c2_1, controlPoint2: c2_2)
        
        drawPattern(with: path)
    }
    
    private func drawPattern(with path: UIBezierPath) {
        
        path.lineWidth = patternLineWidth
        color.setStroke()
        color.setFill()
        
        // set if striped
        if grain == .striped {
            UIGraphicsGetCurrentContext()?.saveGState()
            path.addClip()
            
            // Draw stripe
            for offset in stride(from: CGFloat(0), to: patternWidth, by: stripInterval) {
                path.move(to: patternOrgin.offsetBy(dx: CGFloat(offset), dy: 0))
                path.addLine(to: patternOrgin.offsetBy(dx: CGFloat(offset), dy: patternHeight))
            }
        }
        
        if count == 1 || count == 3 {
            // Draw 1 pattern at center
            grain == .solid ? path.fill() : path.stroke()
        }
        
        if count == 2 {
            if grain == .striped {
                UIGraphicsGetCurrentContext()?.restoreGState()
                UIGraphicsGetCurrentContext()?.saveGState()
            }
            path.apply(CGAffineTransform(translationX: 0, y: patternHeight*0.5 + patternMargin))
            if grain == .striped {
                path.addClip()
            }
            grain == .solid ? path.fill() : path.stroke()
            
            if grain == .striped {
                UIGraphicsGetCurrentContext()?.restoreGState()
            }
            path.apply(CGAffineTransform(translationX: 0, y: -2 * (patternHeight*0.5 + patternMargin)))
            if grain == .striped {
                path.addClip()
            }
            grain == .solid ? path.fill() : path.stroke()
        }

        if count == 3 {
            if grain == .striped {
                UIGraphicsGetCurrentContext()?.restoreGState()
                UIGraphicsGetCurrentContext()?.saveGState()
            }
            path.apply(CGAffineTransform(translationX: 0, y: patternHeight + patternMargin))
            if grain == .striped {
                path.addClip()
            }
            grain == .solid ? path.fill() : path.stroke()
            
            if grain == .striped {
                UIGraphicsGetCurrentContext()?.restoreGState()
            }
            path.apply(CGAffineTransform(translationX: 0, y: -2 * (patternHeight + patternMargin)))
            if grain == .striped {
                path.addClip()
            }
            grain == .solid ? path.fill() : path.stroke()
        }
    }
}

extension SetCardView {
    private struct Constants {
        static let patternMarginToBoundsHeight: CGFloat = 0.07
        static let patternHeightToBoundsHeight: CGFloat = 0.22
        static let patternWidthToBoundsWidth: CGFloat = 0.8
        static let patternLineWidthToBoundsWidth: CGFloat = 0.015
        static let stripIntervalToBoundsWidth: CGFloat = 0.03
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
        static let backTextFontsizeToBoundsWidth: CGFloat = 1.4
        static let cardDisappearTime: TimeInterval = 2
        static let cardDealTime: TimeInterval = 1
    }
    
    private var patternHeight: CGFloat {
        return bounds.height * Constants.patternHeightToBoundsHeight
    }
    
    private var patternWidth: CGFloat {
        return bounds.width * Constants.patternWidthToBoundsWidth
    }
    
    private var patternMargin: CGFloat {
        return bounds.size.height * Constants.patternMarginToBoundsHeight
    }
    
    private var patternOrgin: CGPoint {
        return CGPoint(x: bounds.midX - patternWidth/2, y: bounds.midY - patternHeight/2)
    }
    
    private var cornerRadius: CGFloat {
        return bounds.size.height * Constants.cornerRadiusToBoundsHeight
    }
    
    private var patternLineWidth: CGFloat {
        return bounds.width * Constants.patternLineWidthToBoundsWidth
    }
    
    private var stripInterval: CGFloat {
        return bounds.width * Constants.stripIntervalToBoundsWidth
    }
    
    private var backFontsize: CGFloat {
        return bounds.width * Constants.backTextFontsizeToBoundsWidth
    }
}

extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x + dx, y: y + dy)
    }
}
