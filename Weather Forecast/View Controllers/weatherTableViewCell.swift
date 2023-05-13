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
    
    @IBOutlet weak var cloudImage: UIImageView!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
