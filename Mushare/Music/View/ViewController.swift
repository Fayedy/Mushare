//
//  ViewController.swift
//  Music
//
//  Created by Wcr on 2017/12/10.
//  Copyright © 2017年 wcr. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selfsong:Song?
    
    let array = [""]
    
    var result = [String]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.result.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        // Configure the cell...
        let cellIdentifier = "SearchTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SearchTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MyAlbumTableViewCell.")
        }
        
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        cell.textLabel?.text = self.result[indexPath.row]
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        DataCenter.shareDataCenter.send = 1
        DataCenter.shareDataCenter.update = 1
        //let song = self.list![indexPath.row]
        print(selfsong?.name)
        let data:Dictionary<String,AnyObject> = ["song":selfsong!]
        DataCenter.shareDataCenter.curSong = selfsong
        HttpRequest.getSongLink(songid: (selfsong?.sid)!, callback:  { (link) -> Void in
            DataCenter.shareDataCenter.curPlaySongLink = link
        })
        
        HttpRequest.getSongInfo(songid: (selfsong?.sid)!, callback:  { (info) -> Void in
            DataCenter.shareDataCenter.curPlaySongInfo = info
        })
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: OTHER_MUSIC_LIST_CLICK_NOTIFICATION), object: nil, userInfo: data)
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        searchBar.delegate = self
        
        self.result = self.array
        
        self.searchTableView.delegate = self
        self.searchTableView.dataSource = self
        
        self.searchBar.placeholder = "搜索"
        
        // 注册tableviewCell
        
        self.searchTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    //MARK: UISearchBarDelegate
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool
    {
        
        // 没有搜索内容时显示全部内容
        if searchBar.text == ""
        {
            self.result = self.array
        }
        else
        {
            
            // 匹配用户输入的前缀，不区分大小写
            self.result = []
            
            if let song = DataCenter.shareDataCenter.dbSongList.getName(name: searchBar.text!){
                let data:Dictionary<String,AnyObject> = ["song":song]
                self.selfsong = song
                self.result = [song.name]
            }
            
        }
        
        // 刷新tableView 数据显示
        self.searchTableView.reloadData()
        return true
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        
        print("[ViewController searchBar] searchText: \(searchText)")
        
        // 没有搜索内容时显示全部内容
        if searchText == ""
        {
            self.result = self.array
        } else {
            
            // 匹配用户输入的前缀，不区分大小写
            self.result = []
            
            if let song = DataCenter.shareDataCenter.dbSongList.getName(name: searchBar.text!)
            {
                let data:Dictionary<String,AnyObject> = ["song":song]
                self.selfsong = song
                self.result = [song.name]
            }
            
        }
        
        // 刷新tableView 数据显示
        self.searchTableView.reloadData()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    
    // 搜索触发事件，点击虚拟键盘上的search按钮时触发此方法
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
    }
    
    // 书签按钮触发事件
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        
        print("搜索历史")
    }
    
    // 取消按钮触发事件
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // 搜索内容置空
        searchBar.text = ""
        self.result = self.array
        self.searchTableView.reloadData()
    }
}
