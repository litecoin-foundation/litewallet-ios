//
//  TransactionTableViewCellv2.swift
//  loafwallet
//
//  Created by Kerry Washington on 11/17/19.
//  Copyright © 2019 Litecoin Foundation. All rights reserved.

import UIKit

private let timestampRefreshRate: TimeInterval = 10.0
let kNormalTransactionCellHeight: CGFloat = 70.0
let kMaxTransactionCellHeight: CGFloat = 190.0

class TransactionTableViewCellv2 : UITableViewCell, Subscriber {
 
    @IBOutlet weak var staticCommentLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var availabilityLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var commentTextLabel: UILabel!
    @IBOutlet weak var timedateLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var staticTxIDLabel: UILabel!
    @IBOutlet weak var txidStringLabel: UILabel!
    @IBOutlet weak var staticAmountDetailLabel: UILabel!
    @IBOutlet weak var startingBalanceLabel: UILabel!
    @IBOutlet weak var endingBalanceLabel: UILabel!
    @IBOutlet weak var staticBlockLabel: UILabel!
    @IBOutlet weak var blockLabel: UILabel!
    @IBOutlet weak var qrModalButton: UIButton!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var staticBackgroundView: UIView!
    @IBOutlet weak var moreOrLessLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var expandCardView: UIView!
    var didReceiveLitecoin: Bool?
    var showQRModalAction: (() -> ())?
    ///https://fluffy.es/handling-button-tap-inside-uitableviewcell-without-using-tag/
    var expandCell: (() -> Bool)?
    var isExpanded: Bool = false
    private var timer: Timer? = nil
    private var transaction: Transaction?
    
    private class TransactionCellWrapper {
        weak var target: TransactionTableViewCellv2?
        init(target: TransactionTableViewCellv2) {
            self.target = target
        }

        @objc func timerDidFire() {
            target?.updateTimestamp()
        }
    }
     
    //MARK: - Public
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    deinit {
        timer?.invalidate()
    }
    
    func updateTimestamp() {
        guard let tx = transaction else { return }
        let timestampInfo = tx.timeSince
        timedateLabel.text = timestampInfo.0
        if !timestampInfo.1 {
            timer?.invalidate()
        }
    }
 
    func setupViews() {
        //TODO: polish when successful compiling happens
        self.backgroundColor = .white
        staticBackgroundView.backgroundColor = .liteWalletBlue
    }
    
    func setTransaction(_ transaction: Transaction, isLtcSwapped: Bool, rate: Rate, maxDigits: Int, isSyncing: Bool) {
           self.transaction = transaction
           expandCardView.alpha = 0.0

           amountLabel.attributedText = transaction.descriptionString(isLtcSwapped: isLtcSwapped, rate: rate, maxDigits: maxDigits)
           addressLabel.text = String(format: transaction.direction.addressTextFormat, transaction.toAddress ?? "")
           statusLabel.text = transaction.status
           commentTextLabel.text = transaction.comment
           blockLabel.text = transaction.blockHeight
           txidStringLabel.text = transaction.hash
           availabilityLabel.text = transaction.shouldDisplayAvailableToSpend ? S.Transaction.available : ""
           arrowImageView.image = UIImage(named: "black-circle-arrow-right")?.withRenderingMode(.alwaysTemplate)
        
//           startingBalanceLabel.text = transaction.amountDetailsStartingBalanceString(isLtcSwapped: isLtcSwapped, rate: rate, rates: <#T##[Rate]#>, maxDigits: maxDigits)
//           endingBalanceLabel.text = transaction.amountDetailsEndingBalanceString(isLtcSwapped: isLtcSwapped, rate: rate, rates: <#T##[Rate]#>, maxDigits: maxDigits)
        
           if #available(iOS 11.0, *) {
                      guard let textColor = UIColor(named: "labelTextColor") else {
                          NSLog("ERROR: Custom color not found")
                          return
                      }
                      amountLabel.textColor = textColor
                      addressLabel.textColor = textColor
                      commentTextLabel.textColor = textColor
                      statusLabel.textColor = textColor
                      timedateLabel.textColor = textColor
 
                  } else {
                      commentTextLabel.textColor = .darkText
                      statusLabel.textColor = .darkText
                      timedateLabel.textColor = .grayTextTint
                  }

           if transaction.status == S.Transaction.complete {
               statusLabel.isHidden = false
           } else {
               statusLabel.isHidden = isSyncing
           }

           let timestampInfo = transaction.timeSince
           timedateLabel.text = timestampInfo.0
           if timestampInfo.1 {
               timer = Timer.scheduledTimer(timeInterval: timestampRefreshRate, target: TransactionCellWrapper(target: self), selector: NSSelectorFromString("timerDidFire"), userInfo: nil, repeats: true)
           } else {
               timer?.invalidate()
           }
           timedateLabel.isHidden = !transaction.isValid

           let identity: CGAffineTransform = .identity
           if transaction.direction == .received {
               arrowImageView.transform = identity.rotated(by: π/2.0)
               arrowImageView.tintColor = .txListGreen
           } else {
               arrowImageView.transform = identity.rotated(by: 3.0*π/2.0)
               arrowImageView.tintColor = .cameraGuideNegative
           }
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
