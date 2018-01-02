//
//  MusicListTableViewController.swift
//  Music
//
//  Created by Wcr on 2017/12/27.
//  Copyright © 2017年 wcr. All rights reserved.
//

import UIKit

class MusicListTableViewController: UITableViewController
{

    var channel:String = "public_tuijian_zhongguohaoshengyin"
    var curChannelList:[String] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.title = DataCenter.shareDataCenter.currentChannelName
        
        self.channel = DataCenter.shareDataCenter.currentChannel
        
        HttpRequest.getSongList(ch_name: self.channel, callback:
            { (list) -> Void in
            //print("2")
            if list == nil {return}
            DataCenter.shareDataCenter.currentAllSongId = list!
            //print(list)
            self.loadSongData()
            //self.tableView.reloadData()
            //print("3")
        })
        //print("1")
        //self.tableView.reloadData()
        //下拉刷新
        //self.tableView.addLegendHeaderWithRefreshingTarget(self, refreshingAction: #selector(self.refreshList))
        
        //self.tableView.addLegendFooterWithRefreshingTarget(self, refreshingAction: Selector("loadMore"))
    }
    
    func loadSongData()
    {
        
        //self.curChannelList = DataCenter.shareDataCenter.curShowAllSongId
        self.curChannelList = DataCenter.shareDataCenter.currentAllSongId
        //let list = self.curChannelList
        
        HttpRequest.getSongInfoList(chidArray: self.curChannelList, callback:
            { (info) -> Void in
            //print("1")
            if info == nil {return}
            //print("info")
            DataCenter.shareDataCenter.curShowAllSongInfo = info!
            //DataCenter.shareDataCenter.curShowAllSongLink = link!
            //self.tableView.reloadData()
            
            //self.tableView.header.endRefreshing()
            //self.tableView.footer.endRefreshing()
            HttpRequest.getSongLinkList(chidArray: self.curChannelList, callback:
                { (link) -> Void in
                //print("2")
                //print("link", link)
                DataCenter.shareDataCenter.curShowAllSongLink = link!
                //DataCenter.shareDataCenter.curShowAllSongInfo = info!
                self.tableView.reloadData()
            })
        })
        
        /*HttpRequest.getSongLinkList(chidArray: self.curChannelList, callback: { (link) -> Void in
            print("2")
            print("link", link)
            DataCenter.shareDataCenter.curShowAllSongLink = link!
            //DataCenter.shareDataCenter.curShowAllSongInfo = info!
            //self.tableView.reloadData()
        })*/
    }
    
    func refreshList()
    {
        
        DataCenter.shareDataCenter.curShowStartIndex += 20
        DataCenter.shareDataCenter.curShowEndIndex += 20
        
        if DataCenter.shareDataCenter.curShowEndIndex > DataCenter.shareDataCenter.currentAllSongId.count
        {
            DataCenter.shareDataCenter.curShowEndIndex = DataCenter.shareDataCenter.currentAllSongId.count
            DataCenter.shareDataCenter.curShowStartIndex = DataCenter.shareDataCenter.curShowEndIndex-20
        }
        
        loadSongData()
    }
    
    func loadMore()
    {
        
        DataCenter.shareDataCenter.curShowEndIndex += 20
        
        if DataCenter.shareDataCenter.curShowEndIndex > DataCenter.shareDataCenter.currentAllSongId.count
        {
            DataCenter.shareDataCenter.curShowEndIndex = DataCenter.shareDataCenter.currentAllSongId.count
            DataCenter.shareDataCenter.curShowStartIndex = DataCenter.shareDataCenter.curShowEndIndex-20
        }
        
        loadSongData()
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
        return self.curChannelList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellIdentifier = "MusicTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MusicTableViewCell
            else {
            fatalError("The dequeued cell is not an instance of MusicTableViewCell.")
        }
        //print("cell")
        //if indexPath.row < DataCenter.shareDataCenter.curShowEndIndex {
        if indexPath.row < DataCenter.shareDataCenter.curShowAllSongId.count
        {
            let info =  DataCenter.shareDataCenter.curShowAllSongInfo[indexPath.row]
            //print("info", indexPath.row, info)
        
            cell.musicTitle.text = info.name
            cell.singerName.text = info.artistName
            let song_pic = Common.getIndexPageImage(info: info)
            
            if let url = NSURL(string:song_pic)
            {
                if let data = NSData(contentsOf: url as URL)
                {
                    cell.imgView.image = UIImage(data: data as Data)
                }
            }
        }
        //cell.imageView?.kf_setImageWithURL(NSURL(string: info.songPicRadio)!, placeholderImage: nil)
        //cell.imageView?.image = UIImage(data: NSData(contentsOfURL: NSURL(string: info.songPicRadio)!)!)
       //cell.detailTextLabel?.text = info.artistName
        // Configure the cell...
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        DataCenter.shareDataCenter.curPlayIndex = indexPath.row
        DataCenter.shareDataCenter.send = 0
        DataCenter.shareDataCenter.update = 1
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: CHANNEL_MUSIC_LIST_CLICK_NOTIFICATION), object: nil)
        
        //self.navigationController?.popToRootViewController(animated: true)
    }
    
    /*
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: IndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
            cell.layer.transform = CATransform3DMakeScale(1, 1, 1)
        })
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
