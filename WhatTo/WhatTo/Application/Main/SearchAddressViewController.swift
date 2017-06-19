//
//  SearchAddressViewController.swift
//  WhatTo
//
//  Created by macmini on 10/06/17.
//  Copyright © 2017 qw. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class SearchAddressViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var destinationResultsViewController: GMSAutocompleteResultsViewController?
    var destinationSearchController: UISearchController?

    
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var tbl: UITableView!
    @IBOutlet weak var subview_txtAddress: UIView!
    @IBOutlet weak var viewDestinationSearchBar: UIView!
    @IBOutlet var viewFooter: UIView!
    
    var isFromHome = Bool()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setInitParam();

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        tbl.reloadData()
        super.viewWillAppear(animated) // No need for semicolon
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setInitParam() {
        
        destinationResultsViewController = GMSAutocompleteResultsViewController()
        destinationResultsViewController?.delegate = self
        destinationSearchController = UISearchController(searchResultsController: destinationResultsViewController)
        destinationSearchController?.searchResultsUpdater = destinationResultsViewController
        
        viewDestinationSearchBar.addSubview((destinationSearchController?.searchBar)!)
        
        self.destinationSearchController?.searchBar.sizeToFit()
        // For some reason, the search bar will extend outside the view to the left after calling sizeToFit. This next line corrects this.
        self.destinationSearchController?.searchBar.frame.size.width = self.view.frame.size.width
        self.destinationSearchController?.searchBar.frame.size.height = self.viewDestinationSearchBar.frame.size.height

        self.destinationSearchController?.searchBar.tintColor = Constants.hexStringToUIColor(hex: "127399")
        
        self.destinationSearchController?.hidesNavigationBarDuringPresentation = false
        
        
        viewDestinationSearchBar.isHidden = true;
        if isFromHome
        {
            txtAddress.placeholder = "Enter home address"
            destinationSearchController?.searchBar.placeholder = "Enter home address"
        }
        else
        {
            txtAddress.placeholder = "Enter work address"
            destinationSearchController?.searchBar.placeholder = "Enter work address"
        }
        
        Constants.shaodow(on: viewHeader)
        Constants.setBorderTo(subview_txtAddress, withBorderWidth: 0, radiousView: 2, color: UIColor.clear)
        
        
        tbl.tableFooterView = viewFooter
    }

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
        //return Constants.app_delegate.arrselectLocation.count
        
        if Constants.app_delegate.arrselectLocation.count > 0 {
            return Constants.app_delegate.arrselectLocation.count
        }
        else
        {
            return 0
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let CellIdentifier: String = "cell \(Int(indexPath.row))"
        var cell: Cell_HomeWork? = (tableView.dequeueReusableCell(withIdentifier: CellIdentifier) as? Cell_HomeWork)
        
        if cell == nil {
            let topLevelObjects: [Any] = Bundle.main.loadNibNamed("Cell_HomeWork", owner: nil, options: nil)!
            cell = (topLevelObjects[0] as? Cell_HomeWork)
            cell?.backgroundColor = UIColor.clear
            cell?.selectionStyle = .none
        }
        
        let dictCell = Constants.app_delegate.arrselectLocation.object(at: indexPath.row) as! NSDictionary

        cell?.lbl_placeName.text = dictCell.object(forKey: "place_name") as? String
        cell?.lbl_placeAddress.text = dictCell.object(forKey: "place_address") as? String

        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {

    }
    
    
    
    @IBAction func pinLocationTapped(_ sender: Any)
    {
        let move: PinLocationViewController = storyboard?.instantiateViewController(withIdentifier: "PinLocationViewController") as! PinLocationViewController
        move.FromVC_NAME = "SEARCH_ADDRESS"
        move.isFromHome = isFromHome
        navigationController?.pushViewController(move, animated: false)
    }
}



extension SearchAddressViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        viewDestinationSearchBar.isHidden = false
        textField.resignFirstResponder()
        
        destinationSearchController?.searchBar.becomeFirstResponder()
        
        return true
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true
    }
}


extension SearchAddressViewController: GMSAutocompleteResultsViewControllerDelegate
{
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        
        if resultsController == self.destinationResultsViewController {
            destinationSearchController?.isActive = false
            // Do something with the selected place.
            let lat = place.coordinate.latitude
            let lon = place.coordinate.longitude
            //mapView.animate(toLocation: CLLocationCoordinate2D(latitude: lat, longitude: lon))
            
            //let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lon, zoom: mapView.camera.zoom)
            //mapView.camera = camera
            
            print("destination : ", place.formattedAddress!)
            
            let dict : [String : Any] = [
                "place_name":place.name,
                "place_address":place.formattedAddress!,
                "latitude":lat,
                "longitude":lon,
                "isHome":isFromHome
            ]

            
            if isFromHome
            {
                Constants.app_delegate.HomeDict = dict as! NSMutableDictionary
            }
            else
            {
                Constants.app_delegate.WorkDict = dict as! NSMutableDictionary
            }
            

            //Constants.app_delegate.arrselectLocation.insert((dict as! NSMutableDictionary), at: 0)
            Constants.app_delegate.arrselectLocation.add(dict)
            
            viewDestinationSearchBar.isHidden = true
            txtAddress.text = place.formattedAddress!

            tbl.reloadData()
        }
        
        //fetchNearestDriver()
        //btnSetPickupDest.sendActions(for: .touchUpInside)
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
        viewDestinationSearchBar.isHidden = false

    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

