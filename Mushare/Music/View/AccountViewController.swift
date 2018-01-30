//
//  AccountViewController.swift
//  Kingfisher
//
//  Created by Wcr on 2017/12/30.
//  Copyright © 2017年 Wei Wang. All rights reserved.
//

import UIKit
import AVKit

class AccountViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    @IBOutlet weak var accountImage: UIImageView!
    @IBOutlet weak var accountName: UILabel!
    @IBOutlet weak var login_btn: UIButton!
    
    var islogin:Bool = false
    let logID = UITextField(frame: CGRect(x: 150, y: 120, width: 100, height: 30))
    let logPass = UITextField(frame: CGRect(x: 150, y: 160, width: 100, height: 30))
    
    let AccountLabel = UILabel(frame: CGRect(x: 100, y: 120, width: 50, height: 30))
    let PasswordLabel = UILabel(frame: CGRect(x: 100, y: 160, width: 50, height: 30))
    
    @IBAction func login(_ sender: Any)
    {
        login_btn.setTitleShadowColor(UIColor.gray, for:.normal)
        login_btn.setTitle("", for:.normal)
        login_btn.isUserInteractionEnabled = false
        islogin = true;
        self.Loginin()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        logID.backgroundColor = UIColor.white
        logPass.backgroundColor = UIColor.white
        AccountLabel.textColor = UIColor.black
        PasswordLabel.textColor = UIColor.black
        AccountLabel.text = "账号:"
        PasswordLabel.text = "密码:"
        if islogin == false
        {
            self.view.addSubview(logID)
            self.view.addSubview(logPass)
            self.view.addSubview(AccountLabel)
            self.view.addSubview(PasswordLabel)
        }
        
        else
        {
            Loginin()
        }
    
        // Do any additional setup after loading the view.
    }

    func Loginin()
    {
        AccountLabel.removeFromSuperview()
        PasswordLabel.removeFromSuperview()
        logID.removeFromSuperview()
        logPass.removeFromSuperview()
        accountName.text = logID.text
        accountImage.image = UIImage(named: "accountImage")
        DataCenter.shareDataCenter.me.setName(name: logID.text!)
        DataCenter.shareDataCenter.me.setPassword(password: logPass.text!)
        DataCenter.shareDataCenter.me.setPhoto(photo: accountImage.image!)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer)
    {
        
        //Hide the keyboard.
        //momentText.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
            else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        //Set photoImageView to display the selected image.
        accountImage.image = selectedImage
        
        //Dismiss the picker.
        dismiss(animated: true, completion: nil)
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
