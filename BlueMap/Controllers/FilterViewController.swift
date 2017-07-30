//
//  FilterViewController.swift
//  BlueMap
//
//  Created by Vinh on 7/27/17.
//  Copyright © 2017 VinhNH. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {
    
    @IBOutlet weak var headerView   : UIView!
    @IBOutlet weak var leftButton   : UIButton!
    @IBOutlet weak var leftButtonCover   : UIButton!
    @IBOutlet weak var titleLabel   : UILabel!
    @IBOutlet weak var tableView    : UITableView!
    var sizeLeftButton : CGFloat = 20
    var leftTitleLabel : CGFloat = 44
    var listCategory   = [CategoryModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    func setupView(){
        
        
        self.view.width     = kScreenWidth
        self.view.height    = kScreenHeight
        
        // init headerView
        headerView.backgroundColor = COLOR.MAIN
        headerView.frame = CGRect(x: 0, y: 0, width: view.width, height: 64)
        
        // init leftButton
        leftButton.frame = CGRect(x: kMargin * 2, y: 32,
                                  width: sizeLeftButton, height: sizeLeftButton)
        
        //init titleButton
        titleLabel.text  = "Lọc"
        titleLabel.frame = CGRect(x: leftTitleLabel, y: kStatusBarHeight + kMargin,
                                  width: view.width - leftTitleLabel * 2, height: leftTitleLabel - kMargin * 2)
        
        //init letButtonCover
        leftButtonCover.frame = CGRect(x: 0, y: 0, width: sizeLeftButton + leftTitleLabel,
                                       height: sizeLeftButton + leftTitleLabel)
        
        // init tableView
        
        tableView.frame = CGRect(x: 0, y: headerView.height, width: self.view.width , height: self.view.height - self.headerView.height)
        tableView.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onPressLeftButton (_ sender : AnyObject){
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension FilterViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaults.standard.set(self.listCategory[indexPath.row].slug, forKey: "category")
        UserDefaults.standard.synchronize()
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
    
}

extension FilterViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listCategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier: String = "identifier"
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: identifier)
        }
        let selectedItem = self.listCategory[indexPath.row]
        cell?.textLabel?.text = selectedItem.name
        cell?.tintColor = COLOR.MAIN
        cell?.selectionStyle = .none
        if UserDefaults.standard.string(forKey: "category") == self.listCategory[indexPath.row].slug{
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            cell?.accessoryType = .checkmark
        }
        return cell!
    }
}
