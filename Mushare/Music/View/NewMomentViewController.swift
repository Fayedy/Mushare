//
//  NewMomentViewController.swift
//  Music
//
//  Created by Wcr on 2017/12/30.
//  Copyright © 2017年 wcr. All rights reserved.
//

import UIKit

extension UITextView
{
    //添加链接文本（链接为空时则表示普通文本）
    func appendLinkString(string:String, withURLString:String = "")
    {
        //原来的文本内容
        let attrString:NSMutableAttributedString = NSMutableAttributedString()
        attrString.append(self.attributedText)
        
        //新增的文本内容（使用默认设置的字体样式）
        let attrs = [NSAttributedStringKey.font : self.font!]
        let appendString = NSMutableAttributedString(string: string, attributes:attrs)
        //判断是否是链接文字
        if withURLString != ""
        {
            let range:NSRange = NSMakeRange(0, appendString.length)
            appendString.beginEditing()
            appendString.addAttribute(NSAttributedStringKey.link, value:withURLString, range:range)
            appendString.endEditing()
        }
        //合并新的文本
        attrString.append(appendString)
        
        //设置合并后的文本
        self.attributedText = attrString
    }
}

class NewMomentViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var momentText: UITextView!
    @IBOutlet weak var momentImg: UIImageView!
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    @IBOutlet weak var MusicImage: UIImageView!
    @IBOutlet weak var MusicLabel: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        momentText.delegate=self;
        momentText.layer.borderWidth = 2
        // 设置字体
        momentText.font = UIFont.init(name: "Georgia-Bold", size: 13)
        // 设置是否能编辑
        momentText.isEditable = true
        // 设置内容是否可选
        momentText.isSelectable = true
        momentImg.image = UIImage(named: "addMomentPhoto")
        MusicLabel.text = ""
        MusicImage.image = DataCenter.shareDataCenter.shareImage
        MusicLabel.text = DataCenter.shareDataCenter.shareMusic


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var isSave = false

    //MARK: UITextViewDelegate
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool
    {
        NSLog("分享新鲜事");
        momentText.text = ""
        return true;
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool
    {
        momentText.resignFirstResponder()
        return true
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
        momentImg.image = selectedImage
        
        //Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let btn = sender as? UIBarButtonItem
        {
            
            if btn === saveBtn
            {
                if momentImg.image == UIImage(named: "addMomentPhoto")
                {
                    momentImg.image = nil
                }
                isSave = true
            }
        }
    }
 

}
