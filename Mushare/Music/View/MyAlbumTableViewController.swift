//
//  MyAlbumTableViewController.swift
//  Music
//
//  Created by Wcr on 2017/12/27.
//  Copyright © 2017年 wcr. All rights reserved.
//

import UIKit

class MyAlbumTableViewController: UITableViewController
{

    var list: [Song]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tableView.rowHeight = UITableViewAutomaticDimension;

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.loadData()
        
    }
    
    func loadData()
    {
        if DataCenter.shareDataCenter.curlist == 0
        {
            self.list = DataCenter.shareDataCenter.dbSongList.getAllDownload()
            self.navigationItem.title = "本地音乐"
        }
        else if DataCenter.shareDataCenter.curlist == 1
        {
            self.list = DataCenter.shareDataCenter.dbSongList.getAllRecent()
            self.navigationItem.title = "最近播放"
        }
        else if DataCenter.shareDataCenter.curlist == 2
        {
            self.list = DataCenter.shareDataCenter.dbSongList.getAllLike()
            self.navigationItem.title = "我的收藏"
        }
        
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int
    {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // #warning Incomplete implementation, return the number of rows
        return self.list!.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {


        // Configure the cell...
        let cellIdentifier = "MyAlbumTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MyAlbumTableViewCell
            else
            {
                fatalError("The dequeued cell is not an instance of MyAlbumTableViewCell.")
            }
        
        let song = self.list![indexPath.row]
        
        cell.musicTitle.text = song.name
        cell.singerName.text = song.artist
        
        if let url = NSURL(string:song.pic_url)
        {
            if let data = NSData(contentsOf: url as URL)
            {
                cell.imgView.image = UIImage(data: data as Data)
            }
        }

        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        DataCenter.shareDataCenter.send = 1
        DataCenter.shareDataCenter.update = 1
        let song = self.list![indexPath.row]
        //print(song.name)
        let data:Dictionary<String,AnyObject> = ["song":song]
        DataCenter.shareDataCenter.curSong = song
        HttpRequest.getSongLink(songid: song.sid, callback:
        { (link) -> Void in
            DataCenter.shareDataCenter.curPlaySongLink = link
        })
        
        HttpRequest.getSongInfo(songid: song.sid, callback:
        { (info) -> Void in
            DataCenter.shareDataCenter.curPlaySongInfo = info
        })
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: OTHER_MUSIC_LIST_CLICK_NOTIFICATION), object: nil, userInfo: data)
        
        //导航控制器 跳转到root播放页面
        /*self.tabBarController?.selectedIndex = 0
        var mainView = self.tabBarController?.viewControllers![0] as! UINavigationController
        mainView.popToRootViewControllerAnimated(true)
        */
        
    }
    
    @IBAction func delAllSong(sender: UIBarButtonItem)
    {
        
        if DataCenter.shareDataCenter.curlist == 0
        {
            //更新db
            Common.cleanAllDownloadSong()
            
            DataCenter.shareDataCenter.dbSongList.cleanDownloadList()
        }
        else if DataCenter.shareDataCenter.curlist == 1 {
            DataCenter.shareDataCenter.dbSongList.cleanRecentList()
            
        }
        else if DataCenter.shareDataCenter.curlist == 2
        {
            DataCenter.shareDataCenter.dbSongList.clearLikeList()
        }
        
        self.loadData()
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
