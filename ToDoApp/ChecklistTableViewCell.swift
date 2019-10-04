//
//  ChecklistTableViewCell.swift
//  ToDoApp
//
//  Created by user on 04/10/2019.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class ChecklistTableViewCell: UITableViewCell {
  
    @IBOutlet weak var todoTextLabel: UILabel!
    
    @IBOutlet weak var checkmarkLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
