//
//  SignUpViewController.swift
//  sPre2
//
//  Created by keima on 2015/12/01.
//  Copyright © 2015年 keima. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController, UIPickerViewDelegate,UIPickerViewDataSource {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var nicknameField: UITextField!
    @IBOutlet weak var regionField: UITextField!
    @IBOutlet weak var birthField: UITextField!
    @IBOutlet weak var sexField: UITextField!
    
    var pickOption = ["東京", "神奈川", "埼玉"]
    var pickOption2 = ["男性", "女性"]
    
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150)) as
    UIActivityIndicatorView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.actInd.center = self.view.center
        self.actInd.hidesWhenStopped = true
        self.actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        
        view.addSubview(self.actInd)

        // Do any additional setup after loading the view.
        
        //日付用
        let datepicker = UIDatePicker()
        birthField.inputView = datepicker
        //表示の形式
        datepicker.datePickerMode = UIDatePickerMode.Date
        //選択時のイベント登録
        datepicker.addTarget(self, action: "onDidChangeDate:", forControlEvents: .ValueChanged)
        
        
        
        //地域用
        let pickerView = UIPickerView()
        pickerView.delegate = self
        
        regionField.inputView = pickerView
        pickerView.tag = 1

        //性別
        let pickerView2 = UIPickerView()
        pickerView2.delegate = self
        
        sexField.inputView = pickerView2
        pickerView2.tag = 2
        
        
        //ツールバーの作成
        let toolBar = UIToolbar(frame: CGRectMake(0, self.view.frame.size.height/6, self.view.frame.size.width, 40.0))
        
        
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        
        toolBar.barStyle = UIBarStyle.BlackTranslucent
        
        toolBar.tintColor = UIColor.whiteColor()
        
        toolBar.backgroundColor = UIColor.blackColor()
        
        let defaultButton = UIBarButtonItem(title: "Default", style: UIBarButtonItemStyle.Plain, target: self, action: "tappedToolBarBtn:")
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "donePressed:")
        
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        
        label.font = UIFont(name: "Helvetica", size: 12)
        
        label.backgroundColor = UIColor.clearColor()
        
        label.textColor = UIColor.whiteColor()
        
        label.text = ""
        
        label.textAlignment = NSTextAlignment.Center
        
        let textBtn = UIBarButtonItem(customView: label)
        
        toolBar.setItems([defaultButton,flexSpace,textBtn,flexSpace,doneButton], animated: true)
        
        regionField.inputAccessoryView = toolBar
        birthField.inputAccessoryView = toolBar
        sexField.inputAccessoryView = toolBar
        
        
        
    }

    func donePressed(sender: UIBarButtonItem) {
        
        regionField.resignFirstResponder()
        birthField.resignFirstResponder()
        sexField.resignFirstResponder()
        
    }
    
    func tappedToolBarBtn(sender: UIBarButtonItem) {
        
        regionField.text = "東京"
        
        regionField.resignFirstResponder()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //地域用
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView.tag == 1){
            return pickOption.count
        }else{
            return pickOption2.count
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       
        if(pickerView.tag == 1){
            return pickOption[row]
        }else{
            return pickOption2[row]
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if(pickerView.tag == 1){
            regionField.text = pickOption[row]
        }else{
            sexField.text = pickOption2[row]
        }
    }
    
    
    
    //選択時のイベント
    internal func onDidChangeDate(sender: UIDatePicker){
        
        // フォーマットを生成.
        let myDateFormatter: NSDateFormatter = NSDateFormatter()
        myDateFormatter.dateFormat = "yyyy/MM/dd"
        
        // 日付をフォーマットに則って取得.
        let mySelectedDate: NSString = myDateFormatter.stringFromDate(sender.date)
        birthField.text = mySelectedDate as String
    }

    
    //Mark: Action
    
    
    
    
    @IBAction func signupAction(sender: AnyObject) {
        
        var sex = ""
        let username = self.usernameField.text
        let password = self.passwordField.text
        let nickname = self.nicknameField.text
        let region = self.regionField.text
        let birth = self.birthField.text

        
        if(self.sexField.text == "男性"){
            sex = "m"
        }else{
            sex = "f"
        }
        
        
        if(username?.characters.count < 4 || password?.characters.count < 5){
            
            let alert = UIAlertController(title: "Invaild", message: "Username must be greater than 4 and Password must be greater than 5", preferredStyle: UIAlertControllerStyle.Alert)
            
            presentViewController(alert, animated: true, completion: nil)
            
            
        }else{
            
            self.actInd.startAnimating()
            
            let newUser =  PFUser()
            newUser.username = username
            newUser.password = password
            newUser["nickname"] = nickname
            newUser["region"] = region
            newUser["birthday"] = birth
            newUser["sex"] = sex
            self.actInd.stopAnimating()
            
            newUser.signUpInBackgroundWithBlock({ (succeed,error) -> Void in
                
                
                if(error != nil){
                    
                    let alert = UIAlertController(title: "Erorr", message: "¥(error)", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                }else{

                    
                    let alert = UIAlertController(title: "Succeed", message: "Signed Up", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .Default) {
                        
                        action in
                        self.performSegueWithIdentifier("GoIndex", sender: self)
                        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate //AppDelegateのインスタンスを取得
                        appDelegate.username = username
                        
                    }
                    
                    alert.addAction(defaultAction)
                    
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                }
                
            })
        }
    }
    
    }


