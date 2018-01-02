//
//  PlayViewController.swift
//  Music
//
//  Created by Wcr on 2017/12/29.
//  Copyright © 2017年 wcr. All rights reserved.
//

import UIKit
import MediaPlayer
import Async

class PlayViewController: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var songTimePlayLabel: UILabel!
    @IBOutlet weak var songTimeLengthLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var txtView: UITextView!
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var preButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var singerLabel: UILabel!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    var timer:Timer? = nil
    var currentChannel = ""
    var dbSong:Song? = nil
    var notiSong:Song? = nil
    
    @IBAction func share(_ sender: Any)
    {
        let info = DataCenter.shareDataCenter.curPlaySongInfo
        
        if info == nil
        {
            return
        }
        let showImg = Common.getIndexPageImage(info: info!)
        
        if let url = NSURL(string:showImg)
        {
            if let data = NSData(contentsOf: url as URL)
            {
                DataCenter.shareDataCenter.shareImage = UIImage(data: data as Data)
            }
        }
        DataCenter.shareDataCenter.shareMusic = info?.name
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //self.nameLabel.morphingEffect = .fall
        
        //背景图片模糊效果
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame.size = CGSize(width: view.frame.width, height: view.frame.height)
        self.bgImageView.addSubview(blurView)
        self.txtView.backgroundColor = UIColor.clear
        
        if DataCenter.shareDataCenter.send == 0 {
        self.currentChannel = DataCenter.shareDataCenter.currentChannel
        
        if let storeChannel = UserDefaults.standard.value(forKey: "LAST_PLAY_CHANNEL_ID") as? String
        {
            self.currentChannel = storeChannel
        }
        
        if let channelName = UserDefaults.standard.value(forKey: "LAST_PLAY_CHANNEL_NAME") as? String
        {
            DataCenter.shareDataCenter.currentChannelName = channelName
        }
        
        if DataCenter.shareDataCenter.currentAllSongId.count == 0
        {
            print("load data")
            HttpRequest.getSongList(ch_name: self.currentChannel, callback: { (list) -> Void in
                if let songlist = list
                {
                    DataCenter.shareDataCenter.currentAllSongId = list!
                    self.loadSongData()
                }
                else
                {
                    let alert = UIAlertView(title: "提示", message: "请连接网络", delegate: nil, cancelButtonTitle: "确定")
                    alert.show()
                }
            })
        }
        else
        {
            self.loadSongData()
        }
        }
        else
        {
            if let song = DataCenter.shareDataCenter.curSong
            {
                print(song.name)
                self.show(showImg: song.pic_url, name: song.name, artistName: song.artist, albumName: song.album, songLink: song.song_url, time: song.time, lrcLink: song.lrc_url, songId:song.sid, format:song.format)
            }
            else
            {
                print("nil")
            }
        }
        
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.progresstimer), userInfo: nil, repeats: true)
        
        //从后台激活通知
        //NotificationCenter.default.addObserver(self, selector: Selector(("appDidBecomeActive")), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        
        //监听歌曲列表点击
        NotificationCenter.default.addObserver(self, selector: #selector(self.musicListClick), name: NSNotification.Name(rawValue: CHANNEL_MUSIC_LIST_CLICK_NOTIFICATION), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.otherMusicListClick), name: NSNotification.Name(rawValue: OTHER_MUSIC_LIST_CLICK_NOTIFICATION), object: nil)
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*override func viewDidAppear(_ animated: Bool) {
        print("viewDidAppear")
        if !self.imgView.isAnimating && DataCenter.shareDataCenter.curPlayStatus == 1{
            self.imgView.rotation()
        }
    }*/
    
    /*func appDidBecomeActive(){
        print("appDidBecomeActive")
        if !self.imgView.isAnimating && DataCenter.shareDataCenter.curPlayStatus == 1{
            self.imgView.rotation()
        }
    }*/
    
    @objc func musicListClick()
    {
        DataCenter.shareDataCenter.send = 0
        self.start(index: DataCenter.shareDataCenter.curPlayIndex)
    }
    
    @objc func otherMusicListClick(notification:NSNotification)
    {
        DataCenter.shareDataCenter.send = 1
        print("notification")
        var info = notification.userInfo as! [String:AnyObject]
        let song = info["song"] as! Song
        print("\(song.name)")
        self.notiSong = song
        print(notiSong)
        
        HttpRequest.getSongLink(songid: song.sid, callback:
        { (link) -> Void in
            DataCenter.shareDataCenter.curPlaySongLink = link
        })
        
        HttpRequest.getSongInfo(songid: song.sid, callback:
        { (info) -> Void in
            DataCenter.shareDataCenter.curPlaySongInfo = info
        })
        
        self.show(showImg: song.pic_url, name: song.name, artistName: song.artist, albumName: song.album, songLink: song.song_url, time: song.time, lrcLink: song.lrc_url, songId:song.sid, format:song.format)
    }
    
    @objc func progresstimer(time: Timer)
    {
        
        //print("progresstimer")
        if let link = DataCenter.shareDataCenter.curPlaySongLink
        {
            //let currentPlaybackTime = DataCenter.shareDataCenter.mp.currentTime()
            let currentPlaybackTime = DataCenter.shareDataCenter.mp.currentPlaybackTime
            
            //print(currentPlaybackTime)
            
            if currentPlaybackTime.isNaN
            {
                return
            }
            //if !currentPlaybackTime.isValid {return}
            
            //println(currentPlaybackTime)
            
            self.progressView.progress = Float(currentPlaybackTime/Double(link.time))
            //println(self.progressView.progress)
            self.songTimePlayLabel.text = Common.getMinuteDisplay(seconds: Int(currentPlaybackTime))
            
            let len = (Int)(self.txtView.text.count/link.time)
            
            self.txtView.scrollRangeToVisible(NSRange(location: 80 + len*Int(currentPlaybackTime), length: 15))
            
            if self.progressView.progress == 1.0 {
                self.progressView.progress = 0
                self.next()
                //self.loadSongData()
            }
        }
    }
    
    func loadSongData()
    {
        
        if DataCenter.shareDataCenter.curShowAllSongInfo.count == 0
        {
            HttpRequest.getSongInfoList(chidArray: DataCenter.shareDataCenter.curShowAllSongId, callback: { (info) -> Void in
                
                print("load song data /play")
                if info == nil {return}
                DataCenter.shareDataCenter.curShowAllSongInfo = info!
                
                HttpRequest.getSongLinkList(chidArray: DataCenter.shareDataCenter.curShowAllSongId, callback: { (link) -> Void in
                    
                    DataCenter.shareDataCenter.curShowAllSongLink = link!
                    self.start(index: 0)
                })
            })
        }
        else
        {
            self.start(index: DataCenter.shareDataCenter.curPlayIndex)
        }
    }
    
    func start(index:Int)
    {
        
        DataCenter.shareDataCenter.curPlayIndex = index
        // println(DataCenter.shareDataCenter.curPlayIndex)
        
        Async.main
            {
            
            if index == 0 {
                self.preButton.isEnabled = false
            }
            else
            {
                self.preButton.isEnabled = true
            }
            
            if index == DataCenter.shareDataCenter.curShowAllSongId.count - 1
            {
                self.nextButton.isEnabled = false
            }
            else
            {
                self.nextButton.isEnabled = true
            }
            
            let info = DataCenter.shareDataCenter.curPlaySongInfo
            let link = DataCenter.shareDataCenter.curPlaySongLink
            
            if info == nil || link == nil {return}
            
            let showImg = Common.getIndexPageImage(info: info!)
            
            self.show(showImg: showImg, name: info!.name, artistName: info!.artistName, albumName: info!.albumName, songLink: link!.songLink, time: link!.time, lrcLink: link!.lrcLink, songId:link!.id, format:link!.format)
            
        }
        
        
    }
    
    func resetUI()
    {
        self.progressView.progress = 0
        self.songTimePlayLabel.text = "00:00"
        self.songTimeLengthLabel.text = "00:00"
        self.txtView.text = ""
    }
    
    func show(showImg:String,name:String,artistName:String,albumName:String,songLink:String,time:Int, lrcLink:String,songId:String,format:String)
    {
        print(DataCenter.shareDataCenter.update)
        self.resetUI()
        
        
        //self.navigationItem.title = DataCenter.shareDataCenter.curSong?.name
        
        //info
        
        self.imgView.kf.setImage(with: URL.init(string: showImg))
        //self.imgView.image = UIImage(data: NSData(contentsOfURL: NSURL(string: showImg)!)!)
        self.nameLabel.text = name
        self.singerLabel.text = "-" + artistName + "-"
        //self.albumLabel.text = albumName
        self.bgImageView.kf.setImage(with: URL.init(string: showImg))
        //self.bgImageView.image = UIImage(data: NSData(contentsOfURL: NSURL(string: showImg)!)!)
        //self.imgView.rotation()
        
        //锁屏显示
       // self.showNowPlay(songPic: showImg, name: name, artistName: artistName, albumName: albumName)
        
        //link

            DataCenter.shareDataCenter.mp.stop()
        
        let songUrl = Common.getCanPlaySongUrl(url: songLink)
         
        //如果已经下载 播放本地音乐
        let musicFile = Common.musicLocalPath(songId: songId, format: format)
        if Common.fileIsExist(filePath: musicFile)
        {
            print("播放本地音乐")
            DataCenter.shareDataCenter.mp.contentURL = NSURL(fileURLWithPath: musicFile) as URL!
        }
        else
        {
            DataCenter.shareDataCenter.mp.contentURL = NSURL(string: songUrl)! as URL
        }
        
        

            DataCenter.shareDataCenter.mp.prepareToPlay()
            DataCenter.shareDataCenter.mp.play()

        print("play")
        print(name)
        DataCenter.shareDataCenter.curPlayStatus = 1
        
        self.playButton.setImage(UIImage(named: "player_btn_pause"), for: [])
        
        self.songTimeLengthLabel?.text = Common.getMinuteDisplay(seconds: time)
        //\\[\\d{2}:\\d{2}\\.\\d{2}\\]
        HttpRequest.getLrc(lrcUrl: lrcLink, callback: { lrc -> Void in
            
            //print(lrc!)
            if lrc == nil
            {
                self.txtView.text = "暂无歌词"
            }
            else {
            
            let lrcAfter:String? = Common.replaceString(pattern: "\\[[\\w|\\.|\\:|\\-]*\\]", replace: lrc!, place: "")
            if let lrcDis = lrcAfter
            {
                
                if lrcDis.hasPrefix("<!DOCTYPE")
                {
                    self.txtView.text = "暂无歌词"
                }
                else
                {
                    self.txtView.text = lrcDis
                }
                
            }
            }
            
        })
        
        //DataCenter.shareDataCenter.curPlaySongInfo =
        
 
        self.addRecentSong()
        
        //更新下载状态和喜欢状态
        if let song = DataCenter.shareDataCenter.dbSongList.get(sid: songId)
        {
            self.dbSong = song
            
            if song.is_dl == 1
            {
                self.downloadButton.setImage(UIImage(named: "actionIconDownloaded"), for: [])
            }
            else
            {
                self.downloadButton.setImage(UIImage(named: "actionIconDownload"), for: [])
            }
            
            if song.is_like == 1
            {
                self.likeButton.setImage(UIImage(named: "actionIconLike"), for: [])
            }
            else
            {
                self.likeButton.setImage(UIImage(named: "actionIconUnlike"), for: [])
            }
        }
    }
    
    //添加最近播放
    func addRecentSong()
    {
        
        let info = DataCenter.shareDataCenter.curPlaySongInfo
        let link = DataCenter.shareDataCenter.curPlaySongLink
        
        if info == nil || link == nil
        {
            return
        }
        
        if DataCenter.shareDataCenter.dbSongList.insert(info: info!, link: link!)
        {
            print("\(info!.id)添加最近播放成功")
        }
        else
        {
            print("\(info!.id)添加最近播放失败")
        }
    }
    
    @IBAction func prevSong(sender: UIButton)
    {
        Async.background
            {
            self.prev()
        }
    }
    
    
    @IBAction func nextSong(sender: UIButton)
    {
        Async.background{
            self.next()
        }
    }
    
    func prev()
    {
        DataCenter.shareDataCenter.curPlayIndex -= 1
        if DataCenter.shareDataCenter.curPlayIndex < 0
        {
            DataCenter.shareDataCenter.curPlayIndex = DataCenter.shareDataCenter.curShowAllSongId.count-1
        }
        self.start(index: DataCenter.shareDataCenter.curPlayIndex)
    }
    
    func next()
    {
        DataCenter.shareDataCenter.curPlayIndex += 1
        if DataCenter.shareDataCenter.curPlayIndex > DataCenter.shareDataCenter.curShowAllSongId.count
        {
            DataCenter.shareDataCenter.curPlayIndex = 0
        }
        self.start(index: DataCenter.shareDataCenter.curPlayIndex)
    }
    
    //锁屏显示歌曲专辑信息
   /* func showNowPlay(songPic:String,name:String,artistName:String,albumName:String){
        
        //var showImg = Common.getIndexPageImage(info)
        var img = UIImage(data: NSData(contentsOfURL: NSURL(string: songPic) as! URL)!)
        var item = MPMediaItemArtwork(image: img)
        
        var dic:[NSObject : AnyObject] = [:]
        dic[MPMediaItemPropertyTitle] = name
        dic[MPMediaItemPropertyArtist] = artistName
        dic[MPMediaItemPropertyAlbumTitle] = albumName
        dic[MPMediaItemPropertyArtwork] = item
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = dic as! [String : Any]
    }*/
    
    //接受锁屏事件
   /* override func remoteControlReceived(with event: UIEvent?) {
        
        if event?.type == UIEventType.remoteControl{
            switch event?.subtype {
            case UIEventSubtype.remoteControlPlay:
                DataCenter.shareDataCenter.mp.play()
            case UIEventSubtype.remoteControlPause:
                DataCenter.shareDataCenter.mp.pause()
            case UIEventSubtype.remoteControlTogglePlayPause:
                self.togglePlayPause()
            case UIEventSubtype.remoteControlPreviousTrack:
                self.prev()
            case UIEventSubtype.remoteControlNextTrack:
                self.next()
            default:break
            }
        }
    }*/
    
    func togglePlayPause()
    {
        self.changePlayStatus(sender: self.playButton);
    }
    
    @IBAction func changePlayStatus(sender: UIButton)
    {
        
        if DataCenter.shareDataCenter.curPlayStatus == 1
        {
            DataCenter.shareDataCenter.curPlayStatus = 2
            DataCenter.shareDataCenter.mp.pause()
            self.playButton.setImage(UIImage(named: "player_btn_play"), for: [])
            self.imgView.layer.removeAllAnimations()
        }
        else
        {
            DataCenter.shareDataCenter.curPlayStatus = 1
            DataCenter.shareDataCenter.mp.play()
            self.playButton.setImage(UIImage(named: "player_btn_pause"), for: [])
            //self.imgView.rotation()
        }
    }
    
    @IBAction func downloadSong(sender: UIButton)
    {
        
        if let dbsong  = self.dbSong
        {
            
            if dbsong.is_dl == 1
            {
                //删除下载
                if Common.deleteSong(songId: dbsong.sid, format: dbsong.format)
                {
                    //更新db
                    var ret2 = DataCenter.shareDataCenter.dbSongList.updateDownloadStatus(sid: dbsong.sid, status: 0)
                    
                    self.dbSong!.is_dl = 0
                    self.downloadButton.setImage(UIImage(named: "actionIconDownload"), for: [])
                    print("删除下载\(dbsong.sid)\(dbsong.name)")
                }
            }
            else
            {
                //下载
                var musicPath = Common.musicLocalPath(songId: dbsong.sid, format: dbsong.format)
                if Common.fileIsExist(filePath: musicPath)
                {
                    print("文件已经存在")
                    return
                }
                
                HttpRequest.downloadFile(songURL: dbsong.song_url, musicPath: musicPath, filePath:
                    { () -> Void in
                    print("下载完成\(musicPath)")
                    
                    if Common.fileIsExist(filePath: musicPath)
                    {
                        if DataCenter.shareDataCenter.dbSongList.updateDownloadStatus(sid: dbsong.sid, status:1)
                        {
                            print("\(dbsong.sid)更新db成功")
                            Async.main{
                                self.dbSong!.is_dl = 1
                                self.downloadButton.setImage(UIImage(named: "actionIconDownloaded"), for: [])
                            }
                        }
                        else
                        {
                            print("\(dbsong.sid)更新db失败")
                        }
                    }
                    else
                    {
                        print("\(musicPath)文件不存在")
                    }
                })
            }
            
        }
        
    }
    
    @IBAction func likeSong(sender: UIButton)
    {
        
        if let dbsong  = self.dbSong
        {
            if dbsong.is_like == 1
            {
            
                //取消收藏
                if DataCenter.shareDataCenter.dbSongList.updateLikeStatus(sid: dbsong.sid, status: 0)
                {
                    print("\(dbsong.sid)\(dbsong.name)取消收藏成功")
                    self.dbSong!.is_like = 0
                    self.likeButton.setImage(UIImage(named: "actionIconUnlike"), for: [])
                }
                else
                {
                    print("\(dbsong.sid)取消收藏失败")
                }
                
            }
            else
            {
                //收藏
                if DataCenter.shareDataCenter.dbSongList.updateLikeStatus(sid: dbsong.sid, status: 1)
                {
                    print("\(dbsong.sid)\(dbsong.name)收藏成功")
                    self.dbSong!.is_like = 1
                    self.likeButton.setImage(UIImage(named: "actionIconLike"), for: [])
                }
                else
                {
                    print("\(dbsong.sid)收藏失败")
                }
            }
        }
    }
    



    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let info = DataCenter.shareDataCenter.curPlaySongInfo
        
        if info == nil
        {
            return
        }
        let showImg = Common.getIndexPageImage(info: info!)
        
        if let url = NSURL(string:showImg)
        {
            if let data = NSData(contentsOf: url as URL)
            {
                DataCenter.shareDataCenter.shareImage = UIImage(data: data as Data)
            }
        }
        DataCenter.shareDataCenter.shareMusic = info?.name
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}

