//
//  MomentTableViewController.swift
//  Music
//
//  Created by Wcr on 2017/12/11.
//  Copyright © 2017年 wcr. All rights reserved.
//

import UIKit

class MomentTableViewController: UITableViewController {
    
    //MARK: Properties
    
    var momentCells = [Moment]()

    //MARK: Private Methods
    
    private func loadMomentCell()
    {
        let Accountphoto1 = UIImage(named: "moment_account1")
        let Accountphoto2 = UIImage(named: "moment_account2")
        let photo1 = UIImage(named: "moment1")
        let photo2 = UIImage(named: "moment2")
        
        let momentCell1 = Moment()
        momentCell1.name = "网易小助手"
        momentCell1.text = "分享一张我喜欢的照片和最爱的音乐（链接）"
        momentCell1.photo1 = Accountphoto1
        momentCell1.photo2 = photo1
       
        let momentCell2 = Moment()
        momentCell2.name = "Linda"
        momentCell2.text = "今天是阳光明媚的一天😏"
        momentCell2.photo1 = Accountphoto2
        momentCell2.photo2 = photo2
        
        
        momentCells += [momentCell1, momentCell2]
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        //load Moment cell
        loadMomentCell()
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
        return momentCells.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellIdentifier = "MomentTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MomentTableViewCell  else
        {
            fatalError("The dequeued cell is not an instance of MomentTableViewCell.")
        }
        
        // Fetches the appropriate music for the data source layout.
        let moment = momentCells[indexPath.row]
        
        cell.Name.text = moment.name
        cell.textView.text = moment.text
        cell.AccountImage.image = moment.photo1
        cell.PhotoImage.image = moment.photo2
        
        return cell
    }
    
    
    @IBAction func display(_ sender: Any)
    {
        DataCenter.shareDataCenter.update = 0
    }
    
    @IBAction func exitToMoment(sender: UIStoryboardSegue)
    {
        if let nvc =  sender.source as? NewMomentViewController, let content = nvc.momentText.text
        {
            
            if !content.isEmpty &&  nvc.isSave
            {
                let item = Moment()
                item.name = DataCenter.shareDataCenter.me.name
                item.text = content
                let photo1 = DataCenter.shareDataCenter.me.photo
                item.photo1 = photo1
                item.photo2 = nvc.momentImg.image
                //item.MusicImage = DataCenter.shareDataCenter.shareImage
                //item.MusicLabel = DataCenter.shareDataCenter.shareMusic
                self.momentCells.append(item)
                self.tableView.reloadData()
            }
            
        }
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
