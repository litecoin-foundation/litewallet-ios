//
//  ReceiveLTCViewController.swift
//  loafwallet
//
//  Created by Kerry Washington on 11/17/19.
//  Copyright © 2019 Litecoin Foundation. All rights reserved.
//

import UIKit
import QREncoder

struct WalletAddressData {
    var address: String
    var qrCode: UIImage
    var balance: Double
    var balanceText: String  {
        get {
            String(self.balance) + " Ł"
        }
    }
}

class ReceiveLTCViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var copyAddressButton: UIButton!
    
    @IBOutlet weak var generateAddressButton: UIButton!
    @IBOutlet weak var generateAddressLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var currentAddressLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var currentBalanceLabel: UILabel!
    @IBOutlet weak var addressPageControl: UIPageControl!
   
    @IBOutlet weak var addressScrollView: UIScrollView!
    
    let addressPadding: CGFloat = 0
    var xOffset:CGFloat = 0
    
    let addresses = ["Lac5igzEeP7uRP6A5kNuDnD1GGs9k6M9Vo","LUdcK841QPSTSmeAKqvya725RJg1dPEQ9v"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupSubviews()
    }
    
    private func setupData() {
        addressPageControl.numberOfPages = addresses.count
    }
    
    private func setupSubviews() {
        addressPageControl.currentPageIndicatorTintColor = .liteWalletBlue
        addressPageControl.pageIndicatorTintColor = .litecoinGray
        addressScrollView.backgroundColor = UIColor.blue
        addressScrollView.delegate = self
        addressScrollView.isPagingEnabled = true
        loadScrollViews()
    }
    
    private func loadScrollViews() {
        for address in addresses {
            let qrImage = address.qrCode
            let qrImageView = UIImageView()
            qrImageView.image = qrImage
            qrImageView.frame = CGRect(x: xOffset, y: CGFloat(addressPadding), width: 180, height: 180)
            //button.addTarget(self, action: #selector(btnTouch), for: UIControlEvents.touchUpInside)
            xOffset = xOffset + CGFloat(addressPadding) + qrImageView.frame.size.width
            addressScrollView.addSubview(qrImageView)
        }
        addressScrollView.contentSize = CGSize(width: xOffset, height: addressScrollView.frame.height)
        addressPageControl.addTarget(self, action: #selector(changePage(sender:)) , for: .valueChanged)

    }
 
    @objc func changePage(sender: AnyObject) -> () {
        let x = CGFloat(addressPageControl.currentPage) * addressScrollView.frame.size.width
        addressScrollView.setContentOffset(CGPoint(x:x, y:0), animated: true)
//        currentBalanceLabel.text =
//        currentAddressLabel.text = address
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        addressPageControl.currentPage = Int(pageNumber)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //
    }
     
    
    
//    var scView:UIScrollView!
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        scView = UIScrollView(frame: CGRect(x: 0, y: 120, width: view.bounds.width, height: 50))
//        view.addSubview(scView)
//
//        scView.backgroundColor = UIColor.blue
//        scView.translatesAutoresizingMaskIntoConstraints = false
//
//        for i in 0 ... 10 {
//            let button = UIButton()
//            button.tag = i
//            button.backgroundColor = UIColor.darkGray
//            button.setTitle("\(i)", for: .normal)
//            //button.addTarget(self, action: #selector(btnTouch), for: UIControlEvents.touchUpInside)
//
//            button.frame = CGRect(x: xOffset, y: CGFloat(buttonPadding), width: 70, height: 30)
//
//            xOffset = xOffset + CGFloat(buttonPadding) + button.frame.size.width
//            scView.addSubview(button)
//
//
//        }
//
//        scView.contentSize = CGSize(width: xOffset, height: scView.frame.height)
//    }

}
