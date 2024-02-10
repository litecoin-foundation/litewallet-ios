import Foundation
import SwiftUI

extension View {
	/// From Stack Overflow
	/// https://stackoverflow.com/questions/56760335/round-specific-corners-swiftui

	/// Switchable View corners
	/// - Parameters:
	///   - radius: CGFloat
	///   - corners: topleft, topright, bottomleft, bottomright
	/// - Returns: RoundedCornersView
	func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
		clipShape(RoundedCorner(radius: radius, corners: corners))
	}

	/// Added View Border
	/// - Parameters:
	///   - content: the VIew
	///   - width: CGFloat
	///   - cornerRadius: CGFloat
	/// - Returns: ShapeStyle
	public func addBorder<S>(_ content: S,
	                         width: CGFloat = 1,
	                         cornerRadius: CGFloat) -> some View where S: ShapeStyle
	{
		let roundedRect = RoundedRectangle(cornerRadius: cornerRadius)
		return clipShape(roundedRect)
			.overlay(roundedRect.strokeBorder(content, lineWidth: width))
	}
}

/// Helper struct for the custom Rounded Rect corners
struct RoundedCorner: Shape {
	var radius: CGFloat = .infinity
	var corners: UIRectCorner = .allCorners

	func path(in rect: CGRect) -> Path {
		let path = UIBezierPath(roundedRect: rect,
		                        byRoundingCorners: corners,
		                        cornerRadii: CGSize(width: radius,
		                                            height: radius))
		return Path(path.cgPath)
	}
}

// https://stackoverflow.com/questions/58200555/swiftui-add-clearbutton-to-textfield

/// Clear Button for Textfield()
struct ClearButton: ViewModifier {
	@Binding var text: String

	public func body(content: Content) -> some View {
		ZStack(alignment: .trailing) {
			content

			if !text.isEmpty {
				Button(action: {
					self.text = ""
				}) {
					Image(systemName: "delete.left")
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(width: 25, height: 25, alignment: /*@START_MENU_TOKEN@*/ .center/*@END_MENU_TOKEN@*/)
						.foregroundColor(Color(UIColor.opaqueSeparator))
				}
				.padding(.trailing, 30)
				.padding(.top, 2)
			}
		}
	}
}

/// Inspired by: https://stackoverflow.com/questions/27459746/adding-space-padding-to-a-uilabel
@IBDesignable class PaddingLabel: UILabel {
	@IBInspectable var topInset: CGFloat = 5.0
	@IBInspectable var bottomInset: CGFloat = 5.0
	@IBInspectable var leftInset: CGFloat = 5.0
	@IBInspectable var rightInset: CGFloat = 5.0

	override func drawText(in rect: CGRect) {
		let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
		super.drawText(in: rect.inset(by: insets))
	}

	override var intrinsicContentSize: CGSize {
		let size = super.intrinsicContentSize
		return CGSize(width: size.width + leftInset + rightInset,
		              height: size.height + topInset + bottomInset)
	}

	override var bounds: CGRect {
		didSet {
			// ensures this works within stack views if multi-line
			preferredMaxLayoutWidth = bounds.width - (leftInset + rightInset)
		}
	}
}
