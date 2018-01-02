//
//  Album.swift
//  Music
//
//  Created by Wcr on 2017/12/11.
//  Copyright © 2017年 wcr. All rights reserved.
//

import UIKit

class Album
{
    //MARK: Properties
    
    var name: String
    var photo: UIImage?
    
    //MARK: Initialization
    init?(name:String, photo:UIImage?)
    {
        
        // The name must not be empty
        guard !name.isEmpty else
        {
            return nil
        }
        
        //Initialize stored properties
        self.name = name
        self.photo = photo
    }
}
