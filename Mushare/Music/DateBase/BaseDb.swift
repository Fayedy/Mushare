//
//  BaseDb.swift
//  Music
//
//  Created by Wcr on 2017/12/28.
//  Copyright © 2017年 wcr. All rights reserved.
//

import Foundation

class BaseDb
{
    
    var dbPath: String
    var db:FMDatabase
    
    init()
    {
        
        print("basedb init")
        let dbDirectory = Utils.documentPath().appendingPathComponent("database") as NSString
        
        if !FileManager.default.fileExists(atPath: dbDirectory as String)
        {
            do{
                try FileManager.default.createDirectory(atPath: dbDirectory as String, withIntermediateDirectories: false, attributes: nil)
            }catch _{
                print("file does not exist")
            }
        }
        
        self.dbPath = dbDirectory.appendingPathComponent("baidufm.sqlite")
        
        self.db = FMDatabase(path: self.dbPath)
        //println(dbPath)
        
        //db文件不存在则创建
        if !FileManager.default.fileExists(atPath: self.dbPath)
        {
            if self.open()
            {
                let sql = "CREATE TABLE tbl_song_list (id INTEGER PRIMARY KEY AUTOINCREMENT,sid TEXT UNIQUE,name TEXT,artist TEXT,album TEXT,song_url  TEXT,pic_url   TEXT,lrc_url TEXT,time INTEGER,is_dl INTEGER DEFAULT 0,dl_file TEXT,is_like INTEGER DEFAULT 0,is_recent INTEGER DEFAULT 1,format TEXT)"
                if !self.db.executeUpdate(sql, withArgumentsIn: []){
                    print("db创建失败")
                }
                else
                {
                    print("db创建成功")
                }
            }
            else
            {
                print("open error")
            }
        }
    }
    
    deinit
    {
        self.close()
    }
    
    func open()->Bool
    {
        return self.db.open()
    }
    
    func close()->Bool
    {
        return self.db.close()
    }
}

