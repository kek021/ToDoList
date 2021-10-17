//
//  RealmCell.swift
//  ToDoList
//
//  Created by Александр Жуков on 30.09.2021.
//

import UIKit

class RealmCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
