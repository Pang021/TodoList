//
//  CustomTableViewCell.swift
//  TodoList
//
//  Created by pangthunyalak on 12/3/2562 BE.
//  Copyright © 2562 pangthunyalak. All rights reserved.
//

import UIKit
    
class CustomTableViewCell: UITableViewCell {

    
    @IBOutlet weak var messageTextLable1: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    

    

}
