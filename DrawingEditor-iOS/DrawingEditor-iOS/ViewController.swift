//
//  ViewController.swift
//  DrawingEditor-iOS
//
//  Created by Muhsin Etki on 22.04.2021.
//

import UIKit

class ViewController: UIViewController {
    var rectangles: [Rectangle] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(pan)))
    }
    @objc func pan(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            let rectangle = Rectangle(frame: .init(origin: gesture.location(in: view), size: .init(width: 0, height: 0)))
            rectangle.color = .blue
            view.addSubview(rectangle)
            rectangles.append(rectangle)
        case .changed:
            let distance = gesture.translation(in: view)
            let index = rectangles.index(before: rectangles.endIndex)
            let frame = rectangles[index].frame
            rectangles[index].frame = .init(origin: frame.origin, size: .init(width: frame.width + distance.x, height: frame.height + distance.y))
            rectangles[index].setNeedsDisplay()
            gesture.setTranslation(.zero, in: view)
        case .ended:
            break
        default:
            break
        }
    }
}
@IBDesignable
class Rectangle: UIView {

    @IBInspectable var color: UIColor = .clear {
        didSet { backgroundColor = color }
    }
    // draw your view using the background color
    override func draw(_ rect: CGRect) {
        backgroundColor?.set()
        UIBezierPath(rect: rect).fill()
    }
    // add the gesture recognizer to your view
    override func didMoveToSuperview() {
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(pan)))
    }
    // your gesture selector
    @objc func pan(_ gesture: UIPanGestureRecognizer) {
        //  update your view frame origin
        frame.origin += gesture.translation(in: self)
        // reset the gesture translation
        gesture.setTranslation(.zero, in: self)
    }
}
extension CGPoint {
    static func +=(lhs: inout CGPoint, rhs: CGPoint) {
        lhs.x += rhs.x
        lhs.y += rhs.y
    }
}

