//
//  TestViewController.swift
//  simbe
//
//  Created by 권지수 on 2020/11/16.
//

import UIKit

class TestViewController: UIViewController {
    
    
    @IBOutlet var layerView: TestLabel!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first

        guard let point = touch?.location(in: self.layerView) else { return }
        guard let sublayers = self.layerView.layer.sublayers as? [CAShapeLayer] else { return }
        
            for layer in sublayers {
                if let path = layer.path, path.contains(point) {
                    print(layer.name ?? "없음")
                }
            }
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.layerView.addLayer(name: "test", weight: 30, color: .blue)
            self.layerView.addLayer(name: "test2", weight: 25, color: .cyan)
            self.layerView.addLayer(name: "test3", weight: 20, color: .darkGray)
            self.layerView.addLayer(name: "test3", weight: 15, color: .brown)
            self.layerView.addLayer(name: "test3", weight: 10, color: .orange)
//            self.layerView.addLayer(name: "test4", weight: 10, color: .brown)
//            self.layerView.addLayer(name: "test5", weight: 8, color: .orange)
//            self.layerView.addLayer(name: "test6", weight: 8, color: .purple)
//            self.layerView.addLayer(name: "test7", weight: 3, color: .systemIndigo)
        }
        
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            //
            //        let cellWidth = self.view.safeAreaFrame.width / 4
            //        let cellheight = self.view.safeAreaFrame.height / 5
            //
            //        print("Width : \(cellWidth) height : \(cellheight) viewHeight : \(self.view.safeAreaFrame.height)")
            //
            //        let width: CGFloat = 240.0
            //        let height: CGFloat = 160.0
            //
            //        let demoView = TestLabel(frame: CGRect(x: 0,
            //                                               y: view.getTopSafeAreaHeight(),
            //                                               width: width,
            //                                               height: height))
            //        demoView.backgroundColor  = .brown
            //        self.view.addSubview(demoView)
            //
            //        let testLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
            //        testLabel.center = CGPoint(x: demoView.frame.width / 2, y: demoView.frame.height / 2)
            //        testLabel.text = "test"
            //        testLabel.textAlignment = .center
            //
            //        demoView.addSubview(testLabel)
            
        }
    }
