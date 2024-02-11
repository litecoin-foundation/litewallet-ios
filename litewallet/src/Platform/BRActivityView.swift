import UIKit

class BRActivityViewController: UIViewController {
	let activityView = BRActivityView()

	init(message: String) {
		super.init(nibName: nil, bundle: nil)
		modalTransitionStyle = .crossDissolve

		if #available(iOS 8.0, *) {
			modalPresentationStyle = .overFullScreen
		}

		activityView.messageLabel.text = message
		view = activityView
	}

	@available(*, unavailable)
	public required init(coder _: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

@objc open class BRActivityView: UIView {
	let activityIndicatorView = UIActivityIndicatorView(style: .large)
	let boundingBoxView = UIView(frame: CGRect.zero)
	let messageLabel = UILabel(frame: CGRect.zero)

	init() {
		super.init(frame: CGRect.zero)

		backgroundColor = UIColor(white: 0.0, alpha: 0.5)

		boundingBoxView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
		boundingBoxView.layer.cornerRadius = 12.0

		activityIndicatorView.startAnimating()

		messageLabel.font = UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)
		messageLabel.textColor = UIColor.white
		messageLabel.textAlignment = .center
		messageLabel.shadowColor = UIColor.black
		messageLabel.shadowOffset = CGSize(width: 0.0, height: 1.0)
		messageLabel.numberOfLines = 0

		addSubview(boundingBoxView)
		addSubview(activityIndicatorView)
		addSubview(messageLabel)
	}

	@available(*, unavailable)
	public required init(coder _: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override open func layoutSubviews() {
		super.layoutSubviews()

		boundingBoxView.frame.size.width = 160.0
		boundingBoxView.frame.size.height = 160.0
		boundingBoxView.frame.origin.x = ceil((bounds.width / 2.0) - (boundingBoxView.frame.width / 2.0))
		boundingBoxView.frame.origin.y = ceil((bounds.height / 2.0) - (boundingBoxView.frame.height / 2.0))

		activityIndicatorView.frame.origin.x = ceil((bounds.width / 2.0) - (activityIndicatorView.frame.width / 2.0))
		activityIndicatorView.frame.origin.y = ceil((bounds.height / 2.0) - (activityIndicatorView.frame.height / 2.0))

		let messageLabelSize = messageLabel.sizeThatFits(CGSize(width: 160.0 - 20.0 * 2.0, height: CGFloat.greatestFiniteMagnitude))
		messageLabel.frame.size.width = messageLabelSize.width
		messageLabel.frame.size.height = messageLabelSize.height
		messageLabel.frame.origin.x = ceil((bounds.width / 2.0) - (messageLabel.frame.width / 2.0))
		messageLabel.frame.origin.y = ceil(
			activityIndicatorView.frame.origin.y
				+ activityIndicatorView.frame.size.height
				+ ((boundingBoxView.frame.height - activityIndicatorView.frame.height) / 4.0)
				- (messageLabel.frame.height / 2.0))
	}
}
