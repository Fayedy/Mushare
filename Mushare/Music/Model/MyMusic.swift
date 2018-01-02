//
//  MyMusic.swift
//  Music
//
//  Created by Wcr on 2017/12/10.
//  Copyright © 2017年 wcr. All rights reserved.
//

import UIKit

class MyMusic
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
