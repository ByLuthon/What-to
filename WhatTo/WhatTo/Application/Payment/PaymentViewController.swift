//
//  PaymentViewController.swift
//  WhatTo
//
//  Created by macmini on 24/06/17.
//  Copyright © 2017 qw. All rights reserved.
//

import UIKit

class PaymentViewController: UIViewController, UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {

    
    
    @IBOutlet weak var tbl: UITableView!
    
    
    var arrPayment = NSMutableArray()
    var arrPramotions = NSMutableArray()

    @IBOutlet var viewPromoCode: UIView!
    @IBOutlet weak var subviewPromoCode: UIView!
    @IBOutlet weak var txtGiftCode: UITextField!
    @IBOutlet weak var btnCodeCancel: UIButton!
    @IBOutlet weak var btnCodeAdd: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true

        self.setInitParam()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setInitParam() {
        
        let dictDebit:[String:String] = ["title":"**** 6798 (India)", "icon":"credit-card.png"]
        let dictCase:[String:String] = ["title":"Cash", "icon":"notes.png"]
        let arrtemp1 : NSMutableArray = [dictDebit,dictCase]
        
        let dictRewards:[String:String] = ["title":"Payments Rewards", "icon":"PaymentsRewards.png"]
        let arrtemp2 : NSMutableArray = [dictRewards]

        
        let dict1:[String:Any] = ["titleHeader":"Payment Methods", "titleFooter":"Add Payment Methods", "arrList":arrtemp1]
        let dict2:[String:Any] = ["titleHeader":"Promotions", "titleFooter":"Add Promo/Gift Code", "arrList":arrtemp2]

        
        arrPayment = [dict1,dict2]
        print(arrPayment)
        
        /*
        tbl.reloadData()
        tbl.tableFooterView = UIView()
        
        let tableviewHeader = UIView()
        tableviewHeader.backgroundColor = UIColor.clear
        tableviewHeader.frame = CGRect(x: 0, y: 0, width: Constants.WIDTH, height: 30)
        tbl.tableHeaderView = tableviewHeader
        */
        
        tbl.backgroundColor = Constants.hexStringToUIColor(hex: "#F5F5F5")
        //tableAnimation
        tbl.frame = CGRect(x:CGFloat(0), y: 85, width: CGFloat(Constants.WIDTH), height: tbl.frame.size.height)
        
        UIView.animate(withDuration: 1.0, animations: {() -> Void in
            self.tbl.isHidden = false
            self.tbl.frame = CGRect(x:CGFloat(0), y: Constants.HEIGHT - self.tbl.frame.size.height, width: CGFloat(Constants.WIDTH), height: self.tbl.frame.size.height)
        })
        
        
        //GiftCode
        viewPromoCode.frame = CGRect(x: 0, y: 0, width: Constants.WIDTH, height: Constants.HEIGHT)
        view.addSubview(viewPromoCode)
        viewPromoCode.isHidden = true
        subviewPromoCode.frame = CGRect(x: 0 , y: Constants.HEIGHT, width: Constants.WIDTH, height: subviewPromoCode.frame.size.height)
        txtGiftCode.delegate = self
        
        Constants.shaodow(on: subviewPromoCode)
        Constants.setBorderTo(btnCodeAdd, withBorderWidth: 0.5, radiousView: 2, color: UIColor.clear)
        Constants.setBorderTo(btnCodeCancel, withBorderWidth: 0.5, radiousView: 2, color: UIColor.darkGray)

    }

    @IBAction func close(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
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
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return arrPayment.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let TempDictCell = arrPayment.object(at: section) as! NSDictionary
        let TempArr = TempDictCell.value(forKey: "arrList") as! NSMutableArray
        return TempArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 50
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerVw = UIView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(Constants.WIDTH), height: CGFloat(50)))
        headerVw.backgroundColor = UIColor.clear
        
        let TempDictCell = arrPayment.object(at: section) as! NSDictionary

        let lblusername = UILabel(frame: CGRect(x: CGFloat(8), y: CGFloat(25), width: CGFloat(Constants.WIDTH), height: CGFloat(25)))
        lblusername.font = UIFont(name: "HelveticaNeue-Medium", size:14)
        lblusername.textColor = Constants.DarkGray
        lblusername.text = TempDictCell.value(forKey: "titleHeader") as? String
        lblusername.backgroundColor = UIColor.clear
        headerVw.addSubview(lblusername)
        
        
        
        return headerVw
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 50
    }

    func tableView( _ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    {
        let headerVw = UIView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(Constants.WIDTH), height: CGFloat(50)))
        headerVw.backgroundColor = UIColor.white
        
        let TempDictCell = arrPayment.object(at: section) as! NSDictionary
        
        let lblLine = UILabel(frame: CGRect(x: 0, y: 0, width: Constants.WIDTH, height: 1.0))
        lblLine.backgroundColor = UIColor.lightGray
        lblLine.alpha = 0.5
        headerVw.addSubview(lblLine)

        let lblusername = UILabel(frame: CGRect(x: CGFloat(8), y: CGFloat(0), width: CGFloat(Constants.WIDTH), height: CGFloat(50)))
        lblusername.font = UIFont(name: "HelveticaNeue-Medium", size:14)
        lblusername.textColor = Constants.hexStringToUIColor(hex: "#53A6C5")
        lblusername.text = TempDictCell.value(forKey: "titleFooter") as? String
        lblusername.backgroundColor = UIColor.clear
        headerVw.addSubview(lblusername)
        
        let button:UIButton = UIButton(frame: lblusername.frame)
        button.setTitle("", for: UIControlState.normal)
        button.tag = section
        button.addTarget(self, action:#selector(self.footerTapped), for: .touchUpInside)
        headerVw.addSubview(button)

        
        return headerVw
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let CellIdentifier: String = "cell \(Int(indexPath.row))"
        var cell: Cell_AddPayment? = (tableView.dequeueReusableCell(withIdentifier: CellIdentifier) as? Cell_AddPayment)
        
        if cell == nil {
            let topLevelObjects: [Any] = Bundle.main.loadNibNamed("Cell_AddPayment", owner: nil, options: nil)!
            cell = (topLevelObjects[0] as? Cell_AddPayment)
            cell?.backgroundColor = UIColor.white
            cell?.selectionStyle = .none
        }
        
        let TempDictCell = arrPayment.object(at: indexPath.section) as! NSDictionary
        let TempArr = TempDictCell.value(forKey: "arrList") as! NSMutableArray
        let dictCell = TempArr.object(at: indexPath.row) as! NSDictionary
        
        cell?.imgIcon.image = UIImage(named: dictCell.value(forKey: "icon") as! String)
        cell?.lblTitle.text = dictCell.value(forKey: "title") as? String
        
        cell?.accessoryType = .disclosureIndicator
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
    func footerTapped(sender: AnyObject)
    {
        print("you clicked on button \(sender.tag)")
        
        if sender.tag == 0
        {
            /*
             let move = storyboard?.instantiateViewController(withIdentifier: "AddPamentViewController") as! AddPamentViewController
             navigationController?.push(viewController: move, animated: true)*/
            
            let move = storyboard?.instantiateViewController(withIdentifier: "AddPamentViewController") as! AddPamentViewController
            self.present(move, animated: true, completion: nil)
        }
        else
        {
            self.showGiftScreen()
        }
    }
    
    // MARK: - textField Delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let textFieldText: NSString = (textField.text ?? "") as NSString
        let txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
        self.enableAddButton(txtAfterUpdate)

        return true
    }

    // MARK: - Gift/Promo code Delegate

    func showGiftScreen()
    {
        Constants.animatewithShow(show: true, with: viewPromoCode)
        self.enableAddButton("")
        self.popupWithAnimation(_subview: subviewPromoCode, show: true)
        
        txtGiftCode.becomeFirstResponder()
    }

    func popupWithAnimation(_subview: UIView, show:Bool)  {
        if show
        {
            _subview.frame = CGRect(x:CGFloat(0), y: Constants.HEIGHT, width: CGFloat(Constants.WIDTH), height: _subview.frame.size.height)
            
            UIView.beginAnimations("", context: nil)
            UIView.setAnimationDuration(0.4)
            _subview.frame = CGRect(x:CGFloat(0), y: Constants.HEIGHT - _subview.frame.size.height, width: CGFloat(Constants.WIDTH), height: _subview.frame.size.height)
            UIView.commitAnimations()
            UIView.animate(withDuration: 1.0, animations: {() -> Void in
            })
        }
        else
        {
            UIView.beginAnimations("", context: nil)
            UIView.setAnimationDuration(0.4)
            _subview.frame = CGRect(x:CGFloat(0), y: Constants.HEIGHT, width: CGFloat(Constants.WIDTH), height: _subview.frame.size.height)
            UIView.commitAnimations()
        }
    }

    func enableAddButton(_ text : String)
    {
        if text == ""
        {
            btnCodeAdd.isEnabled = false
            btnCodeAdd.backgroundColor = UIColor.gray
        }
        else
        {
            btnCodeAdd.isEnabled = true
            btnCodeAdd.backgroundColor = UIColor.black
        }
    }
    
    
    @IBAction func CancelCode(_ sender: Any)
    {
        Constants.animatewithShow(show: false, with: viewPromoCode)
    }
    
    @IBAction func AddCode(_ sender: Any)
    {
        Constants.animatewithShow(show: false, with: viewPromoCode)
    }
    
    
    
    
}
