import UIKit

class GradientSwitch: UISwitch
{
	init()
	{
		super.init(frame: .zero)
		setup()
	}

	private let background: GradientView = {
		let view = GradientView()
		view.clipsToBounds = true
		view.layer.cornerRadius = 16.0
		view.alpha = 0.0
		return view
	}()

	private func setup()
	{
		onTintColor = .clear
		insertSubview(background, at: 0)
		background.constrain(toSuperviewEdges: nil)
		addTarget(self, action: #selector(toggleBackground), for: .valueChanged)
	}

	@objc private func toggleBackground()
	{
		UIView.animate(withDuration: 0.1, animations: {
			self.background.alpha = self.isOn ? 1.0 : 0.0
		})
	}

	@available(*, unavailable)
	required init?(coder _: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}
}
