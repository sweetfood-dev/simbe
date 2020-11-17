//
//  paymentInfoCell.swift
//  simbe
//
//  Created by 권지수 on 2020/11/13.
//

import UIKit

class paymentInfoCell: UITableViewCell {

    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
