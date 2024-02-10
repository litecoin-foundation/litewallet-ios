import Foundation
import SwiftUI

extension View {
	/// Forgot Password View Modal
	/// - Parameters:
	///   - isShowingForgot: Boolean to show/hide the modal
	///   - emailString: Users email
	///   - message: Message detail
	/// - Returns: ForgotPasswordView

	func forgotPasswordView(isShowingForgot: Binding<Bool>,
	                        emailString _: Binding<String>,
	                        message: String) -> some View
	{
		litewallet.ForgotAlertView(isShowingForgot: isShowingForgot, presenting: self,
		                           mainMessage: message)
	}

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
