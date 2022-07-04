//
//  CustomTableViewCell.swift
//  NewyorkNews
//
//  Created by Mrinmoy Sinha Mahapatra on 04/07/22.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var dateOfArticle: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var abstract: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var articleImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
