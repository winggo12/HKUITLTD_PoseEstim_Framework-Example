//
//  PoseSelectTableViewCell.swift
//  tutorial
//
//  Created by Cody Ng on 2/6/2021.
//

import UIKit

class PoseSelectTableViewCell: UITableViewCell {

    @IBOutlet weak var poseImageView: UIImageView!
    @IBOutlet weak var poseName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
