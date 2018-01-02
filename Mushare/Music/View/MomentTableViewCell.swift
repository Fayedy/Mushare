//
//  MomentTableViewCell.swift
//  Music
//
//  Created by Wcr on 2017/12/11.
//  Copyright © 2017年 wcr. All rights reserved.
//

import UIKit

class MomentTableViewCell: UITableViewCell
{
    
    //MARK: Properties
    @IBOutlet weak var AccountImage: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var PhotoImage: UIImageView!
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var MusicImage: UIImageView!
    @IBOutlet weak var MusicLabel: UILabel!
    
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
