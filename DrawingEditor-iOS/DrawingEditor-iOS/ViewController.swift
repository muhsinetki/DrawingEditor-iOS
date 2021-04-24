//
//  ViewController.swift
//  DrawingEditor-iOS
//
//  Created by Muhsin Etki on 22.04.2021.
//

import UIKit

enum Shape {
    case CIRCLE , RECTANGLE ,SQUARE , LINE
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
    
    var rectangles: [Shapes] = []
    var squares: [Shapes] = []
    var circles: [Shapes] = []
    var lines:[Shapes] = []
    
    var shapes:[String] = ["Circle","Rectangle","Square","Line"]
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
        squares.forEach { (square) in
            square.mode = .create
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
        squares.forEach { (square) in
            square.mode = .erase
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
                    let circle = Shapes(frame: .init(origin: gesture.location(in: view), size: .init(width: 0, height: 0)))
                    circle.color = currentColor
                    circle.type = .CIRCLE
                    view.addSubview(circle)
                    circles.append(circle)
                case .RECTANGLE:
                    let rectangle = Shapes(frame: .init(origin: gesture.location(in: view), size: .init(width: 0, height: 0)))
                    rectangle.color = currentColor
                    rectangle.type = .RECTANGLE
                    view.addSubview(rectangle)
                    rectangles.append(rectangle)
                case .SQUARE:
                    let square = Shapes(frame: .init(origin: gesture.location(in: view), size: .init(width: 0, height: 0)))
                    square.color = currentColor
                    square.type = .SQUARE
                    view.addSubview(square)
                    squares.append(square)
                case .LINE:
                    let line = Shapes(frame: .init(origin: gesture.location(in: view), size: .init(width: 0, height: 0)))
                    line.color = currentColor
                    line.type = .LINE
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
                case .SQUARE:
                    let index = squares.index(before: squares.endIndex)
                    let frame = squares[index].frame
                    squares[index].frame = .init(origin: frame.origin, size: .init(width: frame.width + distance.x, height: frame.width + distance.x))
                    squares[index].setNeedsDisplay()
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
            }else if row == 2{
                currentShape = .SQUARE
            }else{
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
