//
//  ViewController.swift
//  DrawingEditor-iOS
//
//  Created by Muhsin Etki on 22.04.2021.
//

import UIKit

enum Shape {
    case CIRCLE , RECTANGLE , LINE
}

enum Mode {
    case create , erase
}

class ViewController: UIViewController {
    @IBOutlet weak var shapeLabel: UILabel!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var openPickerViewButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var eraseButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    
    var rectangles: [Rectangle] = []
    var circles: [Circle] = []
    var lines:[Line] = []
    
    var shapes:[String] = ["Circle","Rectangle","Line"]
    var colors:[String] = ["Red","Blue","Green","Transparent"]
    var pickerData:[[String]] = []
    
    var currentColor:UIColor = .red
    var currentShape:Shape = .CIRCLE
    var currentMode:Mode = .create
    
    @IBOutlet weak var shapePickerView: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerData = [shapes,colors]
        shapePickerView.dataSource = self
        shapePickerView.delegate = self
        
        updateCurrentStyleLabel()
        
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(pan)))
    }
    
    func updateCurrentStyleLabel()  {
        shapeLabel.text = "Shape: \(currentShape)"
        colorLabel.text = "Color:  \(currentColor.accessibilityName.uppercased().components(separatedBy: " ").last ?? "")"
    }
    
    @IBAction func createButtonPressed(_ sender: UIButton) {
        eraseButton.backgroundColor = .lightGray
        createButton.backgroundColor = #colorLiteral(red: 0.3764705882, green: 0.8196078431, blue: 0.9137254902, alpha: 1)
        currentMode = .create
        circles.forEach { (circle) in
            circle.mode = .create
        }
        rectangles.forEach { (rectangle) in
            rectangle.mode = .create
        }
        lines.forEach { (line) in
            line.mode = .create
        }
    }
    
    @IBAction func eraseButtonPressed(_ sender: UIButton) {
        createButton.backgroundColor = .lightGray
        eraseButton.backgroundColor = #colorLiteral(red: 0.3764705882, green: 0.8196078431, blue: 0.9137254902, alpha: 1)
        currentMode = .erase
        circles.forEach { (circle) in
            circle.mode = .erase
        }
        rectangles.forEach { (rectangle) in
            rectangle.mode = .erase
        }
        lines.forEach { (line) in
            line.mode = .erase
        }
    }
    
    @IBAction func openPickerViewButtonPressed(_ sender: UIButton) {
        doneButton.isHidden = false
        shapePickerView.isHidden = false
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        doneButton.isHidden = true
        shapePickerView.isHidden = true
    }
    @objc func pan(_ gesture: UIPanGestureRecognizer) {
        if currentMode == .create {
            switch gesture.state {
            case .began:
                switch currentShape {
                case .CIRCLE:
                    let circle = Circle(frame: .init(origin: gesture.location(in: view), size: .init(width: 0, height: 0)))
                    circle.fillColor = currentColor
                    view.addSubview(circle)
                    circles.append(circle)
                case .RECTANGLE:
                    let rectangle = Rectangle(frame: .init(origin: gesture.location(in: view), size: .init(width: 0, height: 0)))
                    rectangle.color = currentColor
                    view.addSubview(rectangle)
                    rectangles.append(rectangle)
                case .LINE:
                    let line = Line(frame: .init(origin: gesture.location(in: view), size: .init(width: 0, height: 0)))
                    line.fillColor = currentColor
                    view.addSubview(line)
                    lines.append(line)
                }
            case .changed:
                let distance = gesture.translation(in: view)
                
                switch currentShape {
                case .CIRCLE:
                    let index = circles.index(before: circles.endIndex)
                    let frame = circles[index].frame
                    circles[index].frame = .init(x: frame.origin.x, y: frame.origin.y, width: frame.width+distance.x, height: frame.height+distance.y)
                    circles[index].setNeedsDisplay()
                case .RECTANGLE:
                    let index = rectangles.index(before: rectangles.endIndex)
                    let frame = rectangles[index].frame
                    rectangles[index].frame = .init(origin: frame.origin, size: .init(width: frame.width + distance.x, height: frame.height + distance.y))
                    rectangles[index].setNeedsDisplay()
                case .LINE:
                    let index = lines.index(before: lines.endIndex)
                    let frame = lines[index].frame
                    lines[index].frame = .init(x: frame.origin.x, y: frame.origin.y, width: frame.width+distance.x, height: frame.height+distance.y)
                    lines[index].setNeedsDisplay()
                }
                gesture.setTranslation(.zero, in: view)
            case .ended:
                break
            default:
                break
            }
        }
    }
}
extension ViewController : UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData[component].count
    }
}
extension ViewController: UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[component][row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            if row == 0 {
                currentShape = .CIRCLE
            }else if row == 1 {
                currentShape = .RECTANGLE
            }else {
                currentShape = .LINE
            }
        }else {
            if row == 0 {
                currentColor = .red
            }else if row == 1 {
                currentColor = .blue
            }else if row == 2{
                currentColor = .green
            }else {
                currentColor = .clear
            }
        }
        updateCurrentStyleLabel()
    }
}

@IBDesignable
class Rectangle: UIView {
    
    @IBInspectable var color: UIColor = .clear {
        didSet { backgroundColor = color }
    }
    var mode:Mode = .create
    
    
    // draw your view using the background color
    override func draw(_ rect: CGRect) {
        if color.isEqual(UIColor.clear){
            UIColor.black.set()
            backgroundColor = .clear
            UIBezierPath(rect: rect).stroke()
        }else{
            backgroundColor?.set()
            UIBezierPath(rect: rect).fill()
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
extension CGPoint {
    static func +=(lhs: inout CGPoint, rhs: CGPoint) {
        lhs.x += rhs.x
        lhs.y += rhs.y
    }
}

@IBDesignable
class Circle: UIView {
    @IBInspectable var fillColor: UIColor = .clear {
        didSet { fillColor.setFill() }
    }
    var mode:Mode = .create
    
    override func draw(_ rect: CGRect) {
        backgroundColor = .clear
        fillColor.set()
        if fillColor.isEqual(UIColor.clear){
            UIColor.black.set()
            backgroundColor = .clear
            UIBezierPath(ovalIn: rect).stroke()
        }else{
            UIBezierPath(ovalIn: rect).fill()
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

@IBDesignable
class Line: UIView {
    @IBInspectable var fillColor: UIColor = .clear {
        didSet { fillColor.setFill() }
    }
    var mode:Mode = .create
    
    override func draw(_ rect: CGRect) {
        backgroundColor = .clear
        let path = UIBezierPath()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        fillColor.set()
        path.stroke()
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
