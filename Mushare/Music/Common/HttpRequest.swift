//
//  HttpRequest.swift
//  Music
//
//  Created by Wcr on 2017/12/28.
//  Copyright © 2017年 wcr. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class HttpRequest
{
    
    class func getChannelList(callback:@escaping ([Channel]?)->Void) -> Void
    {
        
        /*Alamofire.request("https://httpbin.org/get")
            .responseString { response in
                print("Response String: \(response.result.value)")
            }
            .responseJSON { response in
                print("Response JSON: \(response.result.value)")
        }*/
        
        var channelList:[Channel]? = nil
        
        Alamofire.request("http://fm.baidu.com/dev/api/?tn=channellist&hashcode=310d03041bffd10803bc3ee8913e2726&_=1428801468750", method: .get).responseJSON{ (response) -> Void in
            //print("Request: \(response.request)")
            //print("Response: \(response.response)")
            //print("Error: \(response.error)")
            //print("Response JSON: \(response.result.value)")
            let json = response.result.value
            let error = response.result.error
            if json == nil{
                print("json is nil")
            }
            if error == nil && json != nil {
                //print("here")
                var data = JSON(json!)
                let list = data["channel_list"]
                channelList = []
                for (_,subJson):(String, JSON) in list
                {
                    
                    let id = subJson["channel_id"].stringValue
                    let name = subJson["channel_name"].stringValue
                    let order = subJson["channel_order"].int
                    let cate_id = subJson["cate_id"].stringValue
                    let cate = subJson["cate"].stringValue
                    let cate_order = subJson["cate_order"].int
                    let pv_order = subJson["pv_order"].int
                    
                    //print(name)
                    
                    let channel = Channel(id: id, name: name, order: order!, cate_id: cate_id, cate: cate, cate_order: cate_order!, pv_order: pv_order!)
                    channelList?.append(channel)
                }
                callback(channelList)
            }
            else
            {
                callback(nil)
            }
        }
    }
    
    class func getSongList(ch_name:String, callback:@escaping ([String]?)->Void)->Void
    {
        
        var songList:[String]? = nil
        let url = http_song_list_url + ch_name
        // println(url)
        Alamofire.request(url, method: .get).responseJSON{ (response) -> Void in
            //print("Request: \(response.request)")
            //print("Response: \(response.response)")
            //print("Error: \(response.error)")
            //print("Response JSON: \(response.result.value)")
            let json = response.result.value
            let error = response.error
            if error == nil && json != nil
            {
                //println(json)
                var data = JSON(json!)
                let list = data["list"]
                songList = []
                for (_,subJson):(String, JSON) in list
                {
                    let id = subJson["id"].stringValue
                    songList?.append(id)
                }
                callback(songList)
            }
            else
            {
                callback(nil)
            }
        }
    }
    
    class func getSongInfoList(chidArray:[String], callback:@escaping ([SongInfo]?)->Void )
    {
        
        let chids = chidArray.joined(separator: ",")
        
        let params = ["songIds":chids]
        Alamofire.request("http://fm.baidu.com/data/music/songinfo", method: .post, parameters: params).responseJSON{ (response) -> Void in
            let json = response.result.value
            let error = response.error
            if error == nil && json != nil {
                //print("here")
                var data = JSON(json!)
                
                let lists = data["data"]["songList"]
                
                var ret:[SongInfo] = []
                
                for (_,list):(String, JSON) in lists
                {
                    
                    let id = list["songId"].stringValue
                    let name = list["songName"].stringValue
                    let artistId = list["artistId"].stringValue
                    let artistName = list["artistName"].stringValue
                    let albumId = list["albumId"].int
                    let albumName = list["albumName"].stringValue
                    let songPicSmall = list["songPicSmall"].stringValue
                    let songPicBig = list["songPicBig"].stringValue
                    let songPicRadio = list["songPicRadio"].stringValue
                    let allRate = list["allRate"].stringValue
                    
                    let songInfo = SongInfo(id: id, name: name, artistId: artistId, artistName: artistName, albumId: albumId!, albumName: albumName, songPicSmall: songPicSmall, songPicBig: songPicBig, songPicRadio: songPicRadio, allRate: allRate)
                    ret.append(songInfo)
                }
                callback(ret)
            }
            else
            {
                callback(nil)
            }
        }
    }
    
    class func getSongInfo(songid:String, callback:@escaping (SongInfo?)->Void )
    {
    
        
        let params = ["songIds":songid]
        
        Alamofire.request("http://fm.baidu.com/data/music/songinfo", method: .post, parameters: params).responseJSON{ (response) -> Void in
            let json = response.result.value
            let error = response.error
            if error == nil && json != nil {
                //print("here")
                var data = JSON(json!)
                
                let lists = data["data"]["songList"]
                
                var ret:[SongInfo] = []
                
                for (_,list):(String, JSON) in lists
                {
                    
                    let id = list["songId"].stringValue
                    let name = list["songName"].stringValue
                    let artistId = list["artistId"].stringValue
                    let artistName = list["artistName"].stringValue
                    let albumId = list["albumId"].int
                    let albumName = list["albumName"].stringValue
                    let songPicSmall = list["songPicSmall"].stringValue
                    let songPicBig = list["songPicBig"].stringValue
                    let songPicRadio = list["songPicRadio"].stringValue
                    let allRate = list["allRate"].stringValue
                    
                    let songInfo = SongInfo(id: id, name: name, artistId: artistId, artistName: artistName, albumId: albumId!, albumName: albumName, songPicSmall: songPicSmall, songPicBig: songPicBig, songPicRadio: songPicRadio, allRate: allRate)
                    ret.append(songInfo)
                }
                if ret.count == 1
                {
                    callback(ret[0])
                }
                else
                {
                    callback(nil)
                }
            }
            else
            {
                callback(nil)
            }
        }
    }
    
    class func getSongLinkList(chidArray:[String], callback:@escaping ([SongLink]?)->Void )
    {
        
        let chids = chidArray.joined(separator: ",")
        
        let params = ["songIds":chids]
        
        //print(params)
        //Alamofire.request(http_song_link, method: .post, parameters: params, encoding: .URL, headers: _).responseJSON{ (response) -> Void in
        Alamofire.request("http://fm.baidu.com/data/music/songlink", method: .post, parameters: params).responseJSON{ (response) -> Void in
            //print("Request: \(response.request)")
            //print("Response: \(response.response)")
            //print("Error: \(response.error)")
            //print("Response JSON: \(response.result.value)")
            let json = response.result.value
            let error = response.error
            if error == nil && json != nil
            {
                //print("here")
                var data = JSON(json!)
                let lists = data["data"]["songList"]
                //print("lists", lists)
                
                var ret:[SongLink] = []
                
                for (_,list):(String, JSON) in lists
                {
                    
                    let id = list["songId"].stringValue
                    let name = list["songName"].stringValue
                    let lrcLink = list["lrcLink"].stringValue
                    let linkCode = list["linkCode"].int
                    let link = list["songLink"].stringValue
                    let format = list["format"].stringValue
                    let time = list["time"].int
                    let size = list["size"].int
                    let rate = list["rate"].int
                    
                    var t = 0, s = 0, r = 0
                    if time != nil {
                        t = time!
                    }
                    
                    if size != nil {
                        s = size!
                    }
                    
                    if rate != nil {
                        r = rate!
                    }
                    
                    let songLink = SongLink(id: id, name: name, lrcLink: lrcLink, linkCode: linkCode!, songLink: link, format: format, time: t, size: s, rate: r)
                    ret.append(songLink)
                }
                callback(ret)
            }
            else
            {
                callback(nil)
            }
        }
    }
    
    class func getSongLink(songid:String, callback:@escaping (SongLink?)->Void )
    {
        
        let params = ["songIds":songid]
        
        Alamofire.request(http_song_link, method: .post, parameters: params).responseJSON { (response) -> Void in
            //print("Request: \(response.request)")
            //print("Response: \(response.response)")
            //print("Error: \(response.error)")
            //print("Response JSON: \(response.result.value)")
            let json = response.result.value
            let error = response.error
            if error == nil && json != nil {
                var data = JSON(json!)
                let lists = data["data"]["songList"]
                
                var ret:[SongLink] = []
                
                for (_,list):(String, JSON) in lists {
                    
                    let id = list["songId"].stringValue
                    let name = list["songName"].stringValue
                    let lrcLink = list["lrcLink"].stringValue
                    let linkCode = list["linkCode"].int
                    let link = list["songLink"].stringValue
                    let format = list["format"].stringValue
                    let time = list["time"].int
                    let size = list["size"].int
                    let rate = list["rate"].int
                    
                    var t = 0, s = 0, r = 0
                    if time != nil {
                        t = time!
                    }
                    
                    if size != nil {
                        s = size!
                    }
                    
                    if rate != nil
                    {
                        r = rate!
                    }
                    
                    let songLink = SongLink(id: id, name: name, lrcLink: lrcLink, linkCode: linkCode!, songLink: link, format: format, time: t, size: s, rate: r)
                    ret.append(songLink)
                }
                if ret.count == 1 {
                    callback(ret[0])
                }else{
                    callback(nil)
                }
            }else{
                callback(nil)
            }
        }
    }
    
    class func getLrc(lrcUrl:String, callback:@escaping (String?)->Void) ->Void
    {
        
        //let url = http_song_lrc + lrcUrl
        let url = lrcUrl
        Alamofire.request(url, method: .get).responseString(encoding: String.Encoding.utf8){ (response) -> Void in
            //print("Request: \(response.request)")
            //print("Response: \(response.response)")
            //print("Error: \(response.error)")
            //print("Response JSON: \(response.result.value)")
            let string = response.result.value
            let error = response.error
            if error == nil
            {
                callback(string)
            }
            else
            {
                callback(nil)
            }
        }
    }
    
    class func downloadFile(songURL:String, musicPath:String, filePath:@escaping ()->Void)
    {
        
        let canPlaySongURL = Common.getCanPlaySongUrl(url: songURL)
        print("开始下载\(songURL)")
        let url = NSURL(fileURLWithPath: musicPath)
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            return (url as URL, [.createIntermediateDirectories, .removePreviousFile])
        }
        Alamofire.download(canPlaySongURL, method: .get, to: destination).response { (response) -> Void in
            filePath()
        }
    }
}


