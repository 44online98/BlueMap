//
//  PlaceViewController.swift
//  BlueMap
//
//  Created by Vinh on 7/2/17.
//  Copyright © 2017 VinhNH. All rights reserved.
//

import UIKit

class PlaceViewController: UIViewController {
    
    @IBOutlet weak var containerView    : UIView!
    @IBOutlet weak var placeImageView   : UIImageView!
    @IBOutlet weak var titleLabel       : UILabel!
    @IBOutlet weak var addressLabel     : UILabel!
    @IBOutlet weak var phoneLabel       : UILabel!
    var place : PlaceModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /* setup navigationBar
         * barTintColor
         * titleTextAttributes (title color)
         * tintColor(left button color)
         * isTranslucent
         */
        navigationController?.navigationBar.barTintColor        = COLOR.MAIN
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        navigationController?.navigationBar.tintColor           = .white
        navigationController?.navigationBar.isTranslucent       = false
        
        title = self.place?.title
        
        self.setupView()
//        self.requestAPI()
    }
    
    func setupView(){
        
        /* setup containerView
         */
        containerView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - kStatusBarHeight - kNavBarHeight )
        
        placeImageView.af_setImage(
            withURL :URL(string: API.BASE_URL + self.place!.thumb)!,
            placeholderImage: nil,
            filter: nil,
            imageTransition: .crossDissolve(0.5),
            completion: { response in
                //                print(response.result.value as Any)
                //                print(response.result.error as Any)
        })
        
        titleLabel.textColor        = COLOR.MAIN
        titleLabel.width            = view.width - titleLabel.left
        titleLabel.numberOfLines    = 0
        titleLabel.text             = place!.title
        titleLabel.sizeToFit()
        
        addressLabel.width          = view.width - titleLabel.left
        addressLabel.numberOfLines  = 0
        addressLabel.text           = place!.address
        addressLabel.sizeToFit()
        
        phoneLabel.width          = view.width - titleLabel.left
        phoneLabel.text           = place!.phone

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: - Request API
extension PlaceViewController{
    
    func initializeDataSource() -> ZServiceDataSource {
        let dataSource: ZServiceDataSource = ZServiceDataSource()
        var query : String! = ""
        query = "?slug=" + self.place!.slug
        dataSource.url = API.BASE_URL + "api/getDetailCharity" + query
        dataSource.method = .GET
        dataSource.headers = [ TEXT.API_KEY: API.KEY ]
        return dataSource
    }
    
    func requestAPI(){
        let dataSource  = self.initializeDataSource()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        ZServiceManager.request(dataSource) { (response) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            guard let _response = response.response as? Array<Any> else { return }
            debugPrint(_response)
            
        }
    }
}
