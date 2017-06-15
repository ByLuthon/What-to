//
//  EditAccountViewController.swift
//  WhatTo
//
//  Created by macmini on 15/06/17.
//  Copyright © 2017 qw. All rights reserved.
//

import UIKit

class EditAccountViewController: UIViewController, UITableViewDelegate,UITableViewDataSource, UIActionSheetDelegate {

    
    @IBOutlet weak var tbl: UITableView!
    
    @IBOutlet var viewHeader: UIView!
    @IBOutlet weak var imgProfile: UIImageView!
    
    var arrProfile = NSMutableArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setInitParam()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setInitParam() {
        
        
        Constants.setBorderTo(imgProfile, withBorderWidth: 2, radiousView: Float(imgProfile.frame.size.height/2), color: UIColor.lightGray)
        
        let dict_fname:[String:String] = ["title":"First Name", "value":"Bhavesh"]
        let dict_lname:[String:String] = ["title":"Last Name", "value":"Nayi"]
        let dict_phone:[String:String] = ["title":"Phone Number", "value":"088888 88888"]
        let dict_email:[String:String] = ["title":"Email", "value":"bhavesh@rlogical.com"]
        let dict_password:[String:String] = ["title":"Password", "value":"******"]

        arrProfile = [dict_fname, dict_lname, dict_phone, dict_email, dict_password]
        
        tbl.reloadData()
        tbl.tableFooterView = UIView()
        tbl.tableHeaderView = viewHeader
        
        
        tbl.backgroundColor = Constants.hexStringToUIColor(hex: "#F5F5F5")
        //tableAnimation
        tbl.frame = CGRect(x:CGFloat(0), y: 85, width: CGFloat(Constants.WIDTH), height: tbl.frame.size.height)
        
        UIView.animate(withDuration: 1.0, animations: {() -> Void in
            self.tbl.isHidden = false
            self.tbl.frame = CGRect(x:CGFloat(0), y: Constants.HEIGHT - self.tbl.frame.size.height, width: CGFloat(Constants.WIDTH), height: self.tbl.frame.size.height)
        })
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func editProfile(_ sender: Any) {
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Tableview Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrProfile.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let CellIdentifier: String = "cell \(Int(indexPath.row))"
        var cell: Cell_Account? = (tableView.dequeueReusableCell(withIdentifier: CellIdentifier) as? Cell_Account)
        
        if cell == nil {
            let topLevelObjects: [Any] = Bundle.main.loadNibNamed("Cell_Account", owner: nil, options: nil)!
            cell = (topLevelObjects[0] as? Cell_Account)
            cell?.backgroundColor = UIColor.white
            cell?.selectionStyle = .none
        }
        
        let dictCell = arrProfile.object(at: indexPath.row) as! NSDictionary
        
        cell?.lblPlaceholder.text = dictCell.value(forKey: "title") as? String
        cell?.lblTitle.text = dictCell.value(forKey: "value") as? String

        cell?.accessoryType = .disclosureIndicator
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {

    }
    
    
    @IBAction func editProfileTapped(_ sender: Any) {
   
        let actionSheet = UIActionSheet(title: "Select a photo", delegate: self as UIActionSheetDelegate , cancelButtonTitle: "CANCEL", destructiveButtonTitle: nil, otherButtonTitles: "TAKE PHOTO", "CHOOSE FROM LIBRARY")
        
        actionSheet.show(in: self.view)

    }
    
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int)
    {
        print("\(buttonIndex)")
    }
}
