//
//  Utils.swift
//  Music
//
//  Created by Wcr on 2017/12/28.
//  Copyright © 2017年 wcr. All rights reserved.
//

import Foundation

class Utils {
    
    /**
     获取文档路径
     
     :returns: 文档路径
     */
    //更改
    class func documentPath() -> NSString
    {
        
        return NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as NSString
    }
}

