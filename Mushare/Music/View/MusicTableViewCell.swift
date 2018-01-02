//
//  MusicTableViewCell.swift
//  Music
//
//  Created by Wcr on 2017/12/27.
//  Copyright © 2017年 wcr. All rights reserved.
//

import UIKit

class MusicTableViewCell: UITableViewCell
{

    @IBOutlet weak var musicTitle: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var singerName: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
