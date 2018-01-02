//
//  MyMusicTableViewController.swift
//  Music
//
//  Created by Wcr on 2017/12/10.
//  Copyright © 2017年 wcr. All rights reserved.
//

import UIKit

class MyMusicTableViewController: UITableViewController
{
    
    //MARK: Properties
    var myMusicCells = [MyMusic]()
    
    //MARK: Private Methods
    private func loadMyMusicCell() {
        let photo1 = UIImage(named: "local")
        let photo2 = UIImage(named: "current")
        let photo3 = UIImage(named: "favorite")
        
        guard let music1 = MyMusic(name: "本地音乐", photo: photo1)
            else
        {
            fatalError("Unable to instantiate Music1")
        }
        
        guard let music2 = MyMusic(name: "最近播放", photo: photo2)
            else
        {
            fatalError("Unable to instantiate Music2")
        }
        
        guard let music3 = MyMusic(name: "我的收藏", photo: photo3)
            else {
            fatalError("Unable to instantiate Musci2")
        }
        
        /*guard let music4 = MyMusic(name: "我创建的歌单", photo: photo4) else {
            fatalError("Unable to instantiate Musci4")
        }
        
        guard let music5 = MyMusic(name: "我收藏的歌单", photo: photo5) else {
            fatalError("Unable to instantiate Musci5")
        }
        
        myMusicCells += [music1, music2, music3, music4, music5]*/
        myMusicCells += [music1, music2, music3]
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()

        //load MyMusic cell
        loadMyMusicCell()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return myMusicCells.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "MyMusicTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MyMusicTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MyMusicTableViewCell.")
        }
        
        // Fetches the appropriate music for the data source layout.
        let music = myMusicCells[indexPath.row]
        
        cell.MyMusicName.text = music.name
        cell.MyMusicImage.image = music.photo
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        DataCenter.shareDataCenter.curlist = indexPath.row
        
        //NotificationCenter.default.post(name: NSNotification.Name(rawValue: CHANNEL_MUSIC_LIST_CLICK_NOTIFICATION), object: nil)
        
        //self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func display(_ sender: Any)
    {
        DataCenter.shareDataCenter.update = 0
    }
    
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
        
    }*/
    

}
