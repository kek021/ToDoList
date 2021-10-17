//
//  CoreDataCell.swift
//  ToDoList
//
//  Created by Александр Жуков on 30.09.2021.
//

import UIKit

class CoreDataCell: UITableViewCell {
    
    @IBOutlet weak var nameLabelCD: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
