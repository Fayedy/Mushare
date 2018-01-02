//
//  DataCenter.swift
//  Music
//
//  Created by Wcr on 2017/12/28.
//  Copyright © 2017年 wcr. All rights reserved.
//

import Foundation
import MediaPlayer
import AVFoundation
import AVKit

class DataCenter
{
    
    //单例
    /*class var shareDataCenter:DataCenter
     {
        struct Static
        {
            static var onceToken : dispatch_once_t = 0
            static var instance: DataCenter? = nil
        }
        
        dispatch_once(&Static.onceToken)
        {
            () -> Void in
            Static.instance = DataCenter()
        }
        return Static.instance!
    }*/
    static let shareDataCenter = DataCenter()
    
    var mp: MPMoviePlayerController = MPMoviePlayerController()
    
    //var mp:AVPlayer = AVPlayer()
    
    //歌曲分类列表信息
    var channelListInfo:[Channel] = []
    
    //当前分类
    var currentChannel: String = "public_tuijian_zhongguohaoshengyin"
    {
        didSet
        {
            UserDefaults.standard.setValue(self.currentChannel, forKey: "LAST_PLAY_CHANNEL_ID")
            UserDefaults.standard.synchronize()
        }
    }
    
    var currentChannelName: String = "中国好声音"
    {
        didSet
        {
            UserDefaults.standard.setValue(self.currentChannelName, forKey: "LAST_PLAY_CHANNEL_NAME")
            UserDefaults.standard.synchronize()
        }
    }
    
    //当前分类所有歌曲ID
    var currentAllSongId:[String] = []
    
    var curShowStartIndex = 0
    
    var curShowEndIndex = 20
    
    //当前显示歌曲列表
    var curShowAllSongId:[String]
    {
        get
        {
            /*if curShowEndIndex > self.currentAllSongId.count {
                curShowEndIndex =  self.currentAllSongId.count
                curShowStartIndex = curShowEndIndex - 20
            }
            
            curShowStartIndex = curShowStartIndex < 0 ? 0 :curShowStartIndex
            
            
            return [] + currentAllSongId[curShowStartIndex ..< curShowEndIndex]*/
            return [] + currentAllSongId[0 ..< self.currentAllSongId.count]
        }
    }
    
    //当前显示歌曲列表info信息
    var curShowAllSongInfo:[SongInfo] = []
    
    //当前显示歌曲列表link信息
    var curShowAllSongLink:[SongLink] = []
    
    //当前播放的歌曲index
    var curPlayIndex:Int = 0
    {
        didSet
        {
            if curPlayIndex < curShowAllSongInfo.count
            {
                curPlaySongInfo = curShowAllSongInfo[curPlayIndex]
            }
            
            if curPlayIndex < curShowAllSongLink.count
            {
                curPlaySongLink = curShowAllSongLink[curPlayIndex]
            }
        }
    }
    
    //当前播放歌曲的info信息
    var curPlaySongInfo:SongInfo? = nil
    
    //当前播放歌曲的info信息
    var curPlaySongLink:SongLink? = nil
    
    var curSong:Song? = nil
    
    //0初始 1播放 2暂时 3停止
    var curPlayStatus = 0
    
    //0下载 1最近播放 2收藏
    var curlist = 0
    
    //0频道列表 1其他列表
    var send = 0
    
     //0不换歌 1换歌
    var update = 1
    
    //db操作
    var dbSongList:SongList = SongList()
    
    let me:Account = Account(name: "1", password: "2", photo: nil)!
    
    var shareImage:UIImage?
    
    var shareMusic:String?
}

