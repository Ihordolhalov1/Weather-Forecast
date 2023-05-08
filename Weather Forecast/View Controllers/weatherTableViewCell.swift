//
//  weatherTableViewCell.swift
//  Weather Forecast
//
//  Created by Ihor Dolhalov on 08.05.2023.
//  Copyright © 2023 Ihor Dolhalov. All rights reserved.
//

import UIKit

class weatherTableViewCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dateLabel.text = "Text"
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
