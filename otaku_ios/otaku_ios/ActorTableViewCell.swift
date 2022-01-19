//
//  ActorTableViewCell.swift
//  otaku_ios
//
//  Created by EL FATHI LALAOUI on 19/01/2022.
//

import UIKit

class ActorTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameActorLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
