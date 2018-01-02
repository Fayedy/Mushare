//
//  FindMusicViewController.swift
//  Mushare
//
//  Created by 费炀 on 2017/12/11.
//  Copyright © 2017年 Faye. All rights reserved.
//

import UIKit

class FindMusicViewController: UIViewController, CLLoopViewDelegate
{

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let image1 = UIImage(named: "album0")!
        let image2 = UIImage(named: "album1")!
        let image3 = UIImage(named: "album2")!
        let image4 = UIImage(named: "album3")!
        let images = [image1,image2,image3,image4]
        
        let rect = CGRect(x: 0, y: 64, width: self.view.frame.size.width, height:self.view.frame.size.width/16 * 9)
        let loopView = CLLoopView(frame: rect)
        loopView.isUserInteractionEnabled = false
        self.view.addSubview(loopView)
        //add images
        loopView.arrImage = images;
        //auto turn to next page
        loopView.autoShow = true
        loopView.delegate = self as? CLLoopViewDelegate
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - CLLoopView Delegate
    func selectLoopViewPage(idx: Int)
    {
        print("select page:\(idx)")
    }
    
    
    @IBAction func display(_ sender: Any)
    {
        DataCenter.shareDataCenter.update = 0
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
