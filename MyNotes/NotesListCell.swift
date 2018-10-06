//
//  notesListCell.swift
//  MyNotes
//
//  Created by Ramneet Singh on 08/04/18.
//  Copyright © 2018 Ramneet Singh. All rights reserved.
//

import UIKit

class NotesListCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var nameLbl: UILabel!

    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var dateLbl: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
