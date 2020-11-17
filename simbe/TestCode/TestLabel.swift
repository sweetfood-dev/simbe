//
//  TestLabel.swift
//  simbe
//
//  Created by 권지수 on 2020/11/16.
//

import UIKit

class TestLabel: UIView {

    var path: UIBezierPath!
    
    // 레이어 추가 시 시작 지점
    private var startPoint = CGPoint(x: 0, y: 0)
    // 가로는 4, 세로는 5칸으로
    private let widthSpace: CGFloat = 4
    private let heightSpace: CGFloat = 5
    
    // 최대 가로
    private var maxWidth: CGFloat {
        return self.frame.size.width
    }
    
    // 최대 세로
    private var maxHeight: CGFloat {
        return self.frame.size.height
    }
    // 전체 면적
    private var area: CGFloat {
        return maxWidth * maxHeight
    }
    
    // 한칸당 가로
    private var cellWidth: CGFloat {
        return maxWidth / widthSpace
    }
//    한칸당 세로
    private var cellHeight: CGFloat {
        return maxHeight / heightSpace
    }
    

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("width : \(maxWidth) height : \(maxHeight) area : \(area)")
    }
    

    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
}

extension TestLabel {
    func addLayer(name: String, weight: CGFloat, color: UIColor){
        let drawArea: CGFloat = area * ( weight / 100 )
        var drawWidth = drawArea / cellHeight
        print("addLayer drawWidth : \(drawWidth)")
        var pathWidth: CGFloat!
        
        while drawWidth > 0 {
            if drawWidth > maxWidth {
                pathWidth = maxWidth - startPoint.x
            }else {
                if (maxWidth - startPoint.x) > drawWidth {
                    pathWidth = drawWidth
                }else {
                    pathWidth = maxWidth - startPoint.x
                }
                
            }
//            let pathWidth = maxWidth - startPoint.x
            let path = UIBezierPath(rect: CGRect(x: startPoint.x, y: startPoint.y, width: pathWidth, height: cellHeight))
            print("width : \(pathWidth), x : \(startPoint.x) y: \(startPoint.y) color : \(color.description)")
            if  (startPoint.x + pathWidth) == maxWidth {
                startPoint.y = startPoint.y + cellHeight
                startPoint.x = 0
            }else {
                startPoint.x = startPoint.x + pathWidth
            }
            
            let layer = CAShapeLayer()
            layer.path = path.cgPath
            layer.fillColor = color.cgColor
            layer.strokeColor = color.cgColor
            layer.lineWidth = 0
            layer.name = name
            self.layer.addSublayer(layer)
            
            drawWidth = drawWidth - pathWidth
            
        }
        print("\n\n")
        /*
        let path = UIBezierPath()
        path.lineWidth = 10.0
        path.move(to: CGPoint(x: 100, y: 100))
        path.addLine(to: CGPoint(x: 100, y: 200))
        path.addLine(to: CGPoint(x: 200, y: 200))
        path.addLine(to: CGPoint(x: 200, y: 100))
        path.close()
        
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.fillColor = UIColor.brown.cgColor
        layer.name = "1"
        self.layer.addSublayer(layer)
                    
        let path2 = UIBezierPath()
        path2.lineWidth = 10.0
        path2.move(to: CGPoint(x: 100, y: 300))
        path2.addLine(to: CGPoint(x: 100, y: 400))
        path2.addLine(to: CGPoint(x: 200, y: 400))
        path2.addLine(to: CGPoint(x: 200, y: 300))
        path2.close()
        
        let layer2 = CAShapeLayer()
        layer2.path = path2.cgPath
        layer2.fillColor = UIColor.cyan.cgColor
        layer2.name = "2"
        layer2.lineWidth = 20
        layer2.strokeColor = UIColor.black.cgColor
        self.layer.addSublayer(layer2)*/
    }
}
