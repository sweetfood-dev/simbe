//
//  ExpanseTableViewCell.swift
//  simbe
//
//  Created by 권지수 on 2020/10/31.
//

import UIKit

class ExpanseTableViewCell: UITableViewCell {

    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var colorSelect: UIColorWell!
    @IBOutlet var colorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        colorSelect.title = "항목 색상을 선택하세요."
        colorSelect.supportsAlpha = true
        colorSelect.addTarget(self, action: #selector(selectColor(_:)), for: .valueChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @objc func selectColor(_ sender: Any){
        colorView.backgroundColor = colorSelect.selectedColor
        let context = AppDelegate.context
        let mItem = try? PayCategory.findOrCreateItem(name: categoryLabel.text!, color: colorSelect.selectedColor!, context: context)
        
        mItem?.color = colorSelect.selectedColor
        
        do {
            try context.save()
        }catch {
            print("saved selected color erro")
        }
        
    }
    
    func setColorView(color: UIColor){
        colorView.backgroundColor = color
        colorSelect.selectedColor = color
    }
}
