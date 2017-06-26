//
//  TripListViewController.swift
//  WhatTo
//
//  Created by macmini on 26/06/17.
//  Copyright © 2017 qw. All rights reserved.
//

import UIKit

class TripListViewController: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var subviewHeader: UIView!
    
    @IBOutlet weak var scrl: UIScrollView!
    @IBOutlet var tblPast: UITableView!
    @IBOutlet var tblUpcoming: UITableView!
    
    @IBOutlet weak var viewSegment: UIView!
    @IBOutlet weak var lblPast: UILabel!
    @IBOutlet weak var lblUpcoming: UILabel!
    @IBOutlet weak var lblUnderline: UILabel!
    
    var selectedTab: Int = 0
    var oldContentOffset = CGPoint.zero
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setInitParam()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setInitParam()
    {
        scrl.frame = CGRect(x: CGFloat(0), y: subviewHeader.frame.size.height, width: CGFloat(Constants.WIDTH), height: CGFloat(Constants.HEIGHT - subviewHeader.frame.size.height))
        
        tblPast.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(Constants.WIDTH), height: CGFloat(scrl.frame.size.height))
        tblUpcoming.frame = CGRect(x: CGFloat(Constants.WIDTH * 1), y: CGFloat(0), width: CGFloat(Constants.WIDTH), height: CGFloat(scrl.frame.size.height))
        
        scrl.addSubview(tblPast)
        scrl.addSubview(tblUpcoming)
        scrl.contentSize = CGSize(width: CGFloat(Constants.WIDTH * 2), height: CGFloat(0))
        scrl.isPagingEnabled = true
        
        var scrollPoint = CGPoint(x: CGFloat(0), y: CGFloat(0))
        scrl.setContentOffset(scrollPoint, animated: true)
        scrl.delegate = self
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func close(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - UnderLine Button
    func setLineFrameUnderMenu(_ lbl: UILabel) {
        resetButtontitleColor()
        lbl.textColor = UIColor.white
    }
    
    func resetButtontitleColor()
    {
        lblPast.textColor = UIColor.white
        lblUpcoming.textColor = UIColor.white
    }
    
    // MARK: - ScrollView Delegate
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView)
    {
        oldContentOffset = scrollView.contentOffset
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        let scrollOffsetX: Float = Float(scrollView.contentOffset.x)
        let scrollOffsetY: Float = Float(scrollView.contentOffset.y)
        
        if scrollView.contentOffset.x != oldContentOffset.x && (scrollOffsetX >= scrollOffsetY)
        {
            lblUnderline.frame = CGRect(x: CGFloat(scrollOffsetX / 2), y: CGFloat(lblUnderline.frame.origin.y), width: CGFloat(lblUnderline.frame.size.width), height: CGFloat(2.0))
        }
        else {
            
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrllView: UIScrollView)
    {
        if scrllView == scrl
        {
            let pageWidth: CGFloat = scrllView.frame.size.width
            let temp : Float = Float(((scrllView.contentOffset.x - pageWidth / 2) / pageWidth) + 1)
            let page: Int = Int(floor(temp))
            
            var scrollPoint: CGPoint
            resetButtontitleColor()
            
            var lbl: UILabel?
            
            if page == 0
            {
                lbl = lblPast
                lbl?.textColor = UIColor.white
                scrollPoint = CGPoint(x: CGFloat(0), y: CGFloat(0))
                scrl.setContentOffset(scrollPoint, animated: true)
                
                selectedTab = 0
                tblPast.reloadData()
            }
            else if page == 1
            {
                lbl = lblUpcoming
                lbl?.textColor = UIColor.white
                scrollPoint = CGPoint(x: CGFloat(Constants.WIDTH * 1), y: CGFloat(0))
                scrl.setContentOffset(scrollPoint, animated: true)
                
                selectedTab = 1
                tblUpcoming.reloadData()
            }
            
            UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseIn, animations: {() -> Void in
                self.lblUnderline.frame = CGRect(x: CGFloat((lbl?.frame.origin.x)!), y: CGFloat(self.lblUnderline.frame.origin.y), width: CGFloat((lbl?.frame.size.width)!), height: CGFloat(2.0))
            }, completion: {(_ finished: Bool) -> Void in
            })
            switchingtheSegments(page + 1)
        }
        oldContentOffset = scrllView.contentOffset
    }
    
    @IBAction func tabSelected(_ sender: Any)
    {
        let btn: UIButton? = (sender as? UIButton)
        var indx: Int = 0
        
        indx = Int((btn?.tag)!)
        
        switch indx
        {
        case 1:
            
            self.setLineFrameUnderMenu(lblPast)
            selectedTab = 0
            tblPast.reloadData()
            
        case 2:
            
            self.setLineFrameUnderMenu(lblUpcoming)
            selectedTab = 1
            tblUpcoming.reloadData()
            
        default:
            break
        }
        switchingtheSegments(indx)
    }
    
    // MARK: - switchSegments
    func switchSegments(_ btn: UIButton) {
        var indx: Int = 0
        indx = Int(btn.tag)
        switchingtheSegments(indx)
    }
    
    func switchingtheSegments(_ idx: Int) {
        oldContentOffset = scrl.contentOffset
        var scrollPoint: CGPoint
        switch idx {
        case 1:
            scrollPoint = CGPoint(x: CGFloat(0), y: CGFloat(0))
            scrl.setContentOffset(scrollPoint, animated: true)
        case 2:
            scrollPoint = CGPoint(x: CGFloat(Constants.WIDTH), y: CGFloat(0))
            scrl.setContentOffset(scrollPoint, animated: true)
        default:
            break
        }
        
    }
    // MARK: - TABLEVIEW DELEGATE
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 185
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let CellIdentifier: String = "cell \(Int(indexPath.row))"
        var cell: Cell_TripDetails? = (tableView.dequeueReusableCell(withIdentifier: CellIdentifier) as? Cell_TripDetails)
        
        if cell == nil
        {
            let topLevelObjects: [Any] = Bundle.main.loadNibNamed("Cell_TripDetails", owner: nil, options: nil)!
            cell = (topLevelObjects[0] as? Cell_TripDetails)
            cell?.backgroundColor = UIColor.clear
            cell?.selectionStyle = .none
        }
        
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
}
