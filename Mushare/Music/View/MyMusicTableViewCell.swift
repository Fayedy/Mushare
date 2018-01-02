//
//  MyMusicTableViewCell.swift
//  Music
//
//  Created by Wcr on 2017/12/10.
//  Copyright © 2017年 wcr. All rights reserved.
//

import UIKit

class MyMusicTableViewCell: UITableViewCell
{
    
    //MARK: Properties
    
    @IBOutlet weak var MyMusicImage: UIImageView!
    @IBOutlet weak var MyMusicName: UILabel!
    
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
