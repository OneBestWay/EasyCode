//
//  AccountCell.swift
//  PocketBook
//
//  Created by GK on 2017/3/11.
//  Copyright © 2017年 GK. All rights reserved.
//

import UIKit

class AccountCell: UITableViewCell {
    
}

class DetailsCell: UITableViewCell {
    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    
    static func cellIdentifier() -> String {
        return "DetailsCell"
    }
    func configCell(consumptionDTO: ConsumptionDTO) {
        self.amountLabel.text = consumptionDTO.showAmountString
        self.titleLabel.text = consumptionDTO.patterns
        self.iconImage.image = UIImage(named: consumptionDTO.iconName)
    }
    
}

class ConsumptionCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
