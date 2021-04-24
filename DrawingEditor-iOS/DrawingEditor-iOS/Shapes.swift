//
//  Shapes.swift
//  DrawingEditor-iOS
//
//  Created by Muhsin Etki on 23.04.2021.
//

import UIKit

@IBDesignable
class Shapes: UIView {
    
    @IBInspectable var color: UIColor = .clear {
        didSet { backgroundColor = color }
    }
    var mode:Mode = .create
    var type:Shape?
    
    
    // draw your view using the background color
    override func draw(_ rect: CGRect) {
        switch type {
        case .RECTANGLE,.SQUARE:
            if color.isEqual(UIColor.clear){
                UIColor.black.set()
                backgroundColor = .clear
                UIBezierPath(rect: rect).stroke()
            }else{
                backgroundColor?.set()
                UIBezierPath(rect: rect).fill()
            }
        case .CIRCLE:
            backgroundColor = .clear
            color.set()
            if color.isEqual(UIColor.clear){
                UIColor.black.set()
                backgroundColor = .clear
                UIBezierPath(ovalIn: rect).stroke()
            }else{
                UIBezierPath(ovalIn: rect).fill()
            }
        case .LINE:
            backgroundColor = .clear
            let path = UIBezierPath()
            path.move(to: CGPoint(x: rect.minX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            color.set()
            path.stroke()
        case .none:
            return
        }
    }
    // add the gesture recognizer to your view
    override func didMoveToSuperview() {
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(pan)))
        addGestureRecognizer( UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:))))
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        if mode == .erase {
            self.removeFromSuperview()
        }
    }
    // your gesture selector
    @objc func pan(_ gesture: UIPanGestureRecognizer) {
        //  update your view frame origin
        frame.origin += gesture.translation(in: self)
        // reset the gesture translation
        gesture.setTranslation(.zero, in: self)
    }
}

//MARK: - Extension CGPoint
extension CGPoint {
    static func +=(lhs: inout CGPoint, rhs: CGPoint) {
        lhs.x += rhs.x
        lhs.y += rhs.y
    }
}
