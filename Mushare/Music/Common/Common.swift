//
//  Common.swift
//  Music
//
//  Created by Wcr on 2017/12/28.
//  Copyright © 2017年 wcr. All rights reserved.
//

import Foundation


class Common
{
    
    /**
     获取可以播放的音乐
     
     :param: url 音乐播放URL
     
     :returns: 可以播放的URL
     */
    class func getCanPlaySongUrl(url: String)->String
    {
        
        if url.hasPrefix("http://file.qianqian.com")
        {
            return replaceString(pattern: "&src=.+", replace: url, place: "")!
            //return url.substringToIndex(advance(url.startIndex, 114))
        }
        return url
    }
    
    /**
     获取首页显示图片
     
     :param: info 歌曲信息
     
     :returns: 首页显示的图片
     */
    class func getIndexPageImage(info :SongInfo) -> String
    {
        
        if info.songPicBig.isEmpty == false
        {
            return info.songPicBig
        }
        
        if info.songPicRadio.isEmpty == false
        {
            return info.songPicRadio
        }
        
        return info.songPicSmall
    }
    
    /**
     获取友好显示的时间
     
     :param: seconds 秒数
     
     :returns: 友好的时间显示
     */
    class func getMinuteDisplay(seconds: Int) ->String
    {
        
        let minute = Int(seconds/60)
        let second = seconds%60
        
        let minuteStr = minute >= 10 ? String(minute) : "0\(minute)"
        let secondStr = second >= 10 ? String(second) : "0\(second)"
        
        return "\(minuteStr):\(secondStr)"
    }
    
    /**
     正则替换字符串
     
     :param: pattern 正则表达式
     :param: replace 需要被替换的字符串
     :param: place   用来替换的字符串
     
     :returns: 替换后的字符串
     */
    class func replaceString(pattern:String, replace:String, place:String)->String?
    {
        let exp =  try? NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
        return exp?.stringByReplacingMatches(in: replace, options: [], range: NSRange(location: 0,length:replace.characters.count), withTemplate: place)
    }
    
    class func fileIsExist(filePath:String)->Bool
    {
        return FileManager.default.fileExists(atPath:filePath)
    }
    
    class func musicLocalPath(songId:String, format:String) -> String
    {
        
        let musicDir = Utils.documentPath().appendingPathComponent("download") as NSString
        if !FileManager.default.fileExists(atPath: musicDir as String){
            do{
                try FileManager.default.createDirectory(atPath: musicDir as String, withIntermediateDirectories: false, attributes: nil)
            }catch _{
            }
        }
        let musicPath = musicDir.appendingPathComponent(songId + "." + format)
        return musicPath
    }
    
    class func cleanAllDownloadSong()
    {
        
        //删除歌曲文件夹
        let musicDir = Utils.documentPath().appendingPathComponent("download")
        try! FileManager.default.removeItem(atPath: musicDir)
        
    }
    
    class func deleteSong(songId:String, format:String)->Bool
    {
        //删除本地歌曲
        let musicPath = self.musicLocalPath(songId: songId, format: format) 
        do{
            try FileManager.default.removeItem(atPath: musicPath)
        }catch{
            return false
        }
        return true
    }
    
    class func matchesForRegexInText(regex: String!, text: String!) -> [String]
    {
        
        guard let regex = try? NSRegularExpression(pattern: regex,
                                        options: [])
            else{
                fatalError("regex is empty")
        }
        let nsString = text as NSString
        let results = regex.matches(in: text,
                                            options: [], range: NSMakeRange(0, nsString.length))
        
        return results.map({ nsString.substring(with: $0.range)})
    }
    
    //02:57 => 2*60+57=177
    class func timeStringToSecond(time:String)->Int?
    {
        
        var strArr = time.components(separatedBy: ":")
        if strArr.count == 0 {return nil}
        
        let minute =  Int(strArr[0])
        let second = Int(strArr[1])
        
        if let min = minute, let sec = second
        {
            return min * 60 + sec
        }
        return nil
    }
    
    class func subStr(str:String, start:Int, length:Int)->String
    {
        //return str.substringWithRange(Range<String.Index>(start: str.index(str.startIndex, offsetBy: start), end: str.index(str.startIndex, offsetBy: start+length)))
        return String(str[str.index(str.startIndex, offsetBy: start)...str.index(str.startIndex, offsetBy: start+length)])
    }
    
    class func praseSongLrc(lrc:String)->[(lrc:String,time:Int)]
    {
        
        let list = lrc.components(separatedBy: "\n")
        var ret:[(lrc:String,time:Int)] = []
        
        for row in list {
            //匹配[]歌词时间
            var timeArray = matchesForRegexInText(regex: "(\\[\\d{2}\\:\\d{2}\\.\\d{2}\\])", text: row)
            var lrcArray = matchesForRegexInText(regex: "\\](.*)", text: row)
            
            if timeArray.count == 0 {continue}
            //[02:57.26]
            let lrcTime = timeArray[0]
            
            var lrcTxt:String = ""
            if lrcArray.count >= 1 {
                lrcTxt = lrcArray[0]
                lrcTxt = subStr(str: lrcTxt, start: 1, length: lrcTxt.count-1)
            }
            
            //02:57
            let time = subStr(str: lrcTime, start: 1, length: 5)
            
            //println("time=\(time),txt=\(lrcTxt)")
            
            if let t = timeStringToSecond(time: time)
            {
                ret += [(lrc:lrcTxt,time:t)]
            }
        }
        return ret
    }
    
    class func currentLrcByTime(curLength:Int, lrcArray:[(lrc:String,time:Int)])->(String,String)
    {
        
        var i = 0
        for (lrc, time): (String,Int) in lrcArray
        {
            
            if time >= curLength
            {
                if i == 0 { return (lrc, "")
                }
                let prev = lrcArray[i-1]
                return (prev.lrc,lrc)
            }
            i = i + 1
        }
        
        return ("","")
    }
    
}

