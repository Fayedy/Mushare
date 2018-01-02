//
//  AlbumTableViewController.swift
//  Music
//
//  Created by Wcr on 2017/12/11.
//  Copyright © 2017年 wcr. All rights reserved.
//

import UIKit

class AlbumTableViewController: UITableViewController
{
    
    //MARK: Properties
    
    var AlbumCells = [Album]()
    
    //MARK: Private Methods
    
    private func loadAlbumCell()
    {
        let photo1 = UIImage(named: "recAlbum1")
        let photo2 = UIImage(named: "recAlbum2")
        let photo3 = UIImage(named: "recAlbum3")
        let photo4 = UIImage(named: "recAlbum4")
        
        guard let albumCell1 = Album(name: "有哪些好听的歌曲会让你感同身受", photo: photo1)
            else
        {
            fatalError("Unable to instantiate Album1")
        }
        
        guard let albumCell2 = Album(name: "入耳便爱上的英文歌", photo: photo2)
            else {
            fatalError("Unable to instantiate Album2")
        }
        
        guard let albumCell3 = Album(name: "混音人生REMIX", photo: photo3)
            else {
            fatalError("Unable to instantiate Album3")
        }
        
        guard let albumCell4 = Album(name: "沉溺于深海", photo: photo4)
            else {
            fatalError("Unable to instantiate Album4")
        }
        
        
        
        AlbumCells += [albumCell1, albumCell2, albumCell3, albumCell4]
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        //load Album cell
        //loadAlbumCell()
        //super.viewDidLoad()
        
        if DataCenter.shareDataCenter.channelListInfo.count == 0
        {
            HttpRequest.getChannelList { (list) -> Void in
                if list == nil {
                    print("list", list?.count)
                    return
                }
                DataCenter.shareDataCenter.channelListInfo = list!
                self.tableView.reloadData()
            }
        }
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
        //return AlbumCells.count
        //print(DataCenter.shareDataCenter.channelListInfo.count)
        return DataCenter.shareDataCenter.channelListInfo.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellIdentifier = "AlbumTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? AlbumTableViewCell  else {
            fatalError("The dequeued cell is not an instance of AlbumTableViewCell.")
        }
        /*
        // Fetches the appropriate music for the data source layout.
        let music = AlbumCells[indexPath.row]
        
        cell.AlbumName.text = music.name
        cell.AlbumImage.image = music.photo
        */
        //let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UITableViewCell
        //print("album cell")
        cell.AlbumName.text = DataCenter.shareDataCenter.channelListInfo[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let channel = DataCenter.shareDataCenter.channelListInfo[indexPath.row]
        DataCenter.shareDataCenter.currentChannel = channel.id
        DataCenter.shareDataCenter.currentChannelName = channel.name
        DataCenter.shareDataCenter.curShowStartIndex = 0
        DataCenter.shareDataCenter.curShowEndIndex = 20
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
    }
    */

}
