//
//  AddLocationViewController.swift
//  WhatTo
//
//  Created by macmini on 09/06/17.
//  Copyright © 2017 qw. All rights reserved.
//

import UIKit


class AddLocationViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    //MARK:-  IBOutlets
    @IBOutlet weak var tbl: UITableView!

    @IBOutlet weak var subviewHeader: UIView!
    @IBOutlet weak var subview_currentLocation: UIView!
    @IBOutlet weak var lblcircleDot: UILabel!
    @IBOutlet weak var txtCurrentLocation: UITextField!
    @IBOutlet weak var subview_WhereTo: UIView!
    @IBOutlet weak var txtWhereTo: UITextField!
    
    
    var arrLocation: NSMutableArray!
    
    //MARK:- viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setInitParam();
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func setInitParam() {
        

        Constants.shaodow(on: subviewHeader)
        Constants.setBorderTo(subview_currentLocation, withBorderWidth: 0, radiousView: 2, color: UIColor.clear)
        Constants.setBorderTo(subview_WhereTo, withBorderWidth: 0, radiousView: 2, color: UIColor.clear)
        
        Constants.setBorderTo(lblcircleDot, withBorderWidth: 0, radiousView: Float(lblcircleDot.frame.size.height/2), color: UIColor.clear)
        
        
        let dictHome:[String:String] = ["title":"Add Home", "icon":"home.png"]
        let dictWork:[String:String] = ["title":"Add Work", "icon":"briefcase.png"]
        let dictPinLocation:[String:String] = ["title":"Set pin location", "icon":"pinLocation.png"]
        let dictSkipDestination:[String:String] = ["title":"Skip destination", "icon":"forword.png"]

        arrLocation = [dictHome,dictWork, dictPinLocation, dictSkipDestination]
        tbl.reloadData()
        tbl.tableFooterView = UIView()

        txtWhereTo.becomeFirstResponder()
    }
    
    //MARK:-  IBActions
    @IBAction func back(_ sender: Any) {
        self.navigationController?.pop(animated: true)
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
        return arrLocation.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let CellIdentifier: String = "cell \(Int(indexPath.row))"
        var cell: Cell_setLocation? = (tableView.dequeueReusableCell(withIdentifier: CellIdentifier) as? Cell_setLocation)
        
        if cell == nil {
            let topLevelObjects: [Any] = Bundle.main.loadNibNamed("Cell_setLocation", owner: nil, options: nil)!
            cell = (topLevelObjects[0] as? Cell_setLocation)
            cell?.backgroundColor = UIColor.clear
            cell?.selectionStyle = .none
        }
        
        let dictCell = arrLocation.object(at: indexPath.row) as! NSDictionary

        cell?.imgIcon.image = UIImage(named: dictCell.value(forKey: "icon") as! String)
        cell?.lblTitle.text = dictCell.value(forKey: "title") as? String
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let dictCell = arrLocation.object(at: indexPath.row) as! NSDictionary

        if (dictCell.value(forKey: "title") as? String) == "Set pin location"
        {
            let move: PinLocationViewController = storyboard?.instantiateViewController(withIdentifier: "PinLocationViewController") as! PinLocationViewController
            navigationController?.pushViewController(move, animated: true)

        }
    }

    
}
