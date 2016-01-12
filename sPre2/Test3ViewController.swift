//
//  Test3ViewController.swift
//  sPre2
//
//  Created by keima on 2015/12/05.
//  Copyright © 2015年 keima. All rights reserved.
//

import UIKit
import Parse


class Test3ViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var actInd: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150)) as
    UIActivityIndicatorView

    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var myImgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var prField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        

        self.actInd.center = self.view.center
        self.actInd.hidesWhenStopped = true
        self.actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        
        view.addSubview(self.actInd)
        
        self.actInd.startAnimating()
        
        self.uploadButton.layer.borderWidth = 1
        self.uploadButton.layer.cornerRadius = 18
        self.uploadButton.layer.masksToBounds = true
        
        self.myImgView.layer.borderColor = UIColor.grayColor().CGColor
        self.myImgView.layer.borderWidth = 1
        self.myImgView.layer.cornerRadius = 55
        self.myImgView.layer.masksToBounds = true
        
        self.view.bringSubviewToFront(uploadButton)
        self.view.sendSubviewToBack(myImgView)
        
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let username = appDelegate.username
        
        let query = PFQuery(className:"_User")
        query.whereKey("username", equalTo:username!)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) .")
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        self.nameLabel.text = object.objectForKey("nickname")?.description
                    
                        let dateformatter: NSDateFormatter = NSDateFormatter()
                        dateformatter.locale = NSLocale(localeIdentifier: "ja")
                        dateformatter.dateFormat = "yyyy/MM/dd"
                        
                        let age = self.age(dateformatter.dateFromString((object.objectForKey("birthday")?.description)!)!)
                        self.ageLabel.text = age.description + "歳"
                        
                        self.regionLabel.text = object.objectForKey("region")?.description
                        
                        self.prField.text = object.objectForKey("PR")?.description
                        
                        let myImage = UIImage(named: "noimg.png")
                    
            
                        self.myImgView.image = myImage
                        
                        if let userPicture = PFUser.currentUser()?["thumb"] as? PFFile {
                            userPicture.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                                if (error == nil) {
                                    self.myImgView.image = UIImage(data:imageData!)
                                }
                            }
                        }
             

                        
                        
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
    
        }
        
        self.actInd.stopAnimating()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    
    // MARK: Function
    
    func age(birthDate: NSDate,baseDate: NSDate = NSDate()) -> Int {
        let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)!

        print(birthDate)
        print(baseDate)
        
        var comps = (0, 0, 0, 0)
        calendar.getEra(&comps.0, year: &comps.1, month: &comps.2, day: &comps.3, fromDate: birthDate)
        
        var comps2 = (0, 0, 0, 0)
        calendar.getEra(&comps2.0, year: &comps2.1, month: &comps2.2, day: &comps2.3, fromDate: baseDate)
        
        var y = comps2.1 - comps.1
        // 誕生日が来ていなければ1を引きます
        if comps2.2 < comps.2 {
            y = y - 1
        } else if (comps2.2 == comps.2) && (comps2.3 < comps.3) {
            y = y - 1
        }
        print (comps2.1)
        print (y)
        return y
    }
    
    //MARK: Action
    

    
    @IBAction func changeAction(sender: AnyObject) {
        self.actInd.startAnimating()
        
        let query = PFQuery(className:"_User")
        query.getObjectInBackgroundWithId((PFUser.currentUser()?.objectId!)!) {
            (_User: PFObject?, error: NSError?) -> Void in
            if error != nil {
                print(error)
            } else if let user = _User {
                user["PR"] = self.prField.text
                user.saveInBackground()
            }
            
            self.actInd.stopAnimating()
        }
        
        
        let alert = UIAlertController(title: "完了", message: "変更が完了しました", preferredStyle: UIAlertControllerStyle.Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default) {
            
            action in print("OK")
            
        }
        
        alert.addAction(defaultAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }
    
    @IBAction func imageUpAction(sender: AnyObject) {
            self.actInd.startAnimating()
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
            // フォトライブラリの画像・写真選択画面を表示
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .PhotoLibrary
            imagePickerController.allowsEditing = true
            imagePickerController.delegate = self
            presentViewController(imagePickerController, animated: true, completion: nil)
            self.actInd.stopAnimating()
        }
    }
    
    
    //Delegate Method
    func imagePickerController(picker: UIImagePickerController,
        
        
        
        didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
            
            
        
        // 選択した画像・写真を取得し、imageViewに表示
        if let info = editingInfo, let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage{

        }else{
            let imageData = UIImagePNGRepresentation(image)
            let parseImg = PFFile(name:"image.png", data:imageData!)
            let query = PFQuery(className:"_User")
            query.getObjectInBackgroundWithId((PFUser.currentUser()?.objectId!)!) {
                (_User: PFObject?, error: NSError?) -> Void in
                if error != nil {
                    print(error)
                } else if let user = _User {
                    
                    user["thumb"] = parseImg
                    user.saveInBackground()
                    self.myImgView.image = image
                }
            
        }
    }
        
        // フォトライブラリの画像・写真選択画面を閉じる
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}
    
    

    