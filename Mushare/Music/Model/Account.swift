//
//  Account.swift
//  Music
//
//  Created by Wcr on 2017/12/11.
//  Copyright © 2017年 wcr. All rights reserved.
//

import UIKit

class Account
{
    
    //MARK: Properties
    
    var name: String
    var password: String
    var photo: UIImage?
    
    //MARK: Initialization
    init?(name:String, password: String, photo:UIImage?)
    {
        
        // The name must not be empty
        guard !name.isEmpty else
        {
            return nil
        }
        
        //Initialize stored properties
        self.name = name
        self.password = password
        self.photo = photo
    }
    
    func setName(name:String)->Void
    {
        self.name = name
    }
    
    func setPassword(password:String)->Void
    {
        self.password = password
    }
    
    func setPhoto(photo: UIImage)->Void
    {
        self.photo = photo
    }
    
}

