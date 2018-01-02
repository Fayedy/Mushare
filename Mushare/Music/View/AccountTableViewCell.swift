//
//  AccountTableViewCell.swift
//  Music
//
//  Created by Wcr on 2017/12/11.
//  Copyright © 2017年 wcr. All rights reserved.
//

import UIKit

class AccountTableViewCell: UITableViewCell
{
    
    //MARK: Properties
    @IBOutlet weak var AccountCellName: UILabel!
    @IBOutlet weak var AccountCellImage: UIImageView!
    
    
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
