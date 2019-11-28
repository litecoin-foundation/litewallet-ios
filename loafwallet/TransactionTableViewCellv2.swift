//
//  TransactionTableViewCellv2.swift
//  loafwallet
//
//  Created by Kerry Washington on 11/17/19.
//  Copyright © 2019 Litecoin Foundation. All rights reserved.

import UIKit

private let timestampRefreshRate: TimeInterval = 10.0
let kMaxTransactionCellHeight: CGFloat = 240.0

class TransactionTableViewCellv2 : UITableViewCell, Subscriber {
 
    @IBOutlet weak var staticCommentLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var staticMemoLabel: UILabel!
    @IBOutlet weak var memoTextLabel: UILabel!
    
    @IBOutlet weak var timedateLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    
    @IBOutlet weak var staticTxIDLabel: UILabel!
    @IBOutlet weak var txidStringLabel: UILabel!
     
    @IBOutlet weak var staticAmountDetailLabel: UILabel!
    @IBOutlet weak var startingBalanceLabel: UILabel!
    @IBOutlet weak var endingBalanceLabel: UILabel!
    @IBOutlet weak var exchangeRateLabel: UILabel!
      
    @IBOutlet weak var staticBlockLabel: UILabel!
    @IBOutlet weak var blockLabel: UILabel!
     
    @IBOutlet weak var qrModalButton: UIButton!
    
    @IBOutlet weak var cardView: UIView!
 
    @IBOutlet weak var staticBackgroundView: UIView!
     
    @IBOutlet weak var moreOrLessLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var expandCardView: UIView!
    @IBOutlet weak var expandCardHeightLayoutContstraint: NSLayoutConstraint!
    
    var didReceiveLitecoin: Bool?
    var showQRModalAction: (() -> ())?
    ///https://fluffy.es/handling-button-tap-inside-uitableviewcell-without-using-tag/
    var expandCell: (() -> Bool)?
    var isExpanded: Bool = false
    private var timer: Timer? = nil

    //MARK: - Public
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
     }

    deinit {
        timer?.invalidate()
    }
 
    func updateTimestamp() {
         
    }
    
    func setupViews() {
       
        //TODO: polish when successful compiling happens
        self.backgroundColor = .white
        cardView.layer.cornerRadius = 5.0
//        cardView.layer.shadowColor = UIColor.black.cgColor
//        cardView.layer.shadowOffset = CGSize(width: 0.0,height: 2.0)
//        cardView.layer.shadowRadius = 2.0
//        cardView.layer.shadowOpacity = 1.0
        
        staticBackgroundView.backgroundColor = .liteWalletBlue
        expandCardHeightLayoutContstraint.constant = 0.0
    }
     
   
    override func setSelected(_ selected: Bool, animated: Bool) {
        

    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
       
    }

    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
    }
    
    @IBAction func didTapQRButtonAction(_ sender: Any) {
        showQRModalAction?()
    }
    
}
