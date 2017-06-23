//
//  AddPamentViewController.swift
//  WhatTo
//
//  Created by macmini on 15/06/17.
//  Copyright © 2017 qw. All rights reserved.
//

import UIKit

class AddPamentViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var tbl: UITableView!
    
    var arrPaymentList = NSMutableArray()
    
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

        let dictDebit:[String:String] = ["title":"Credit or Debit Card", "icon":"credit-card.png"]
        let dictCase:[String:String] = ["title":"Cash", "icon":"notes.png"]
        let dictPayment:[String:String] = ["title":"Payment", "icon":"paytm.png"]
        
        arrPaymentList = [dictDebit,dictCase, dictPayment]
        
        tbl.reloadData()
        tbl.tableFooterView = UIView()
        
        let tableviewHeader = UIView()
        tableviewHeader.backgroundColor = UIColor.clear
        tableviewHeader.frame = CGRect(x: 0, y: 0, width: Constants.WIDTH, height: 30)
        tbl.tableHeaderView = tableviewHeader
        
        
        tbl.backgroundColor = Constants.hexStringToUIColor(hex: "#F5F5F5")
        //tableAnimation
        tbl.frame = CGRect(x:CGFloat(0), y: 85, width: CGFloat(Constants.WIDTH), height: tbl.frame.size.height)

        UIView.animate(withDuration: 1.0, animations: {() -> Void in
            self.tbl.isHidden = false
            self.tbl.frame = CGRect(x:CGFloat(0), y: Constants.HEIGHT - self.tbl.frame.size.height, width: CGFloat(Constants.WIDTH), height: self.tbl.frame.size.height)
        })
    }
    
    @IBAction func close(_ sender: Any) {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "FindNearestDriver"), object: nil, userInfo: nil)

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
    
    // MARK: - Tableview Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrPaymentList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let CellIdentifier: String = "cell \(Int(indexPath.row))"
        var cell: Cell_AddPayment? = (tableView.dequeueReusableCell(withIdentifier: CellIdentifier) as? Cell_AddPayment)
        
        if cell == nil {
            let topLevelObjects: [Any] = Bundle.main.loadNibNamed("Cell_AddPayment", owner: nil, options: nil)!
            cell = (topLevelObjects[0] as? Cell_AddPayment)
            cell?.backgroundColor = UIColor.white
            cell?.selectionStyle = .none
        }
        
        let dictCell = arrPaymentList.object(at: indexPath.row) as! NSDictionary
        
        cell?.imgIcon.image = UIImage(named: dictCell.value(forKey: "icon") as! String)
        cell?.lblTitle.text = dictCell.value(forKey: "title") as? String
        
        cell?.accessoryType = .disclosureIndicator

        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        //let dictCell = arrPaymentList.object(at: indexPath.row) as! NSDictionary
        
        if indexPath.row == 0
        {
            
        }
        else if indexPath.row == 1
        {
            
        }
        else if indexPath.row == 2
        {
            
        }
    }
}
