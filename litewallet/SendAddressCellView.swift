import SwiftUI

struct SendAddressCellView: View {
	// MARK: - Combine Variables

	@ObservedObject
	var viewModel = SendAddressCellViewModel()

	let actionButtonWidth: CGFloat = 45.0
	let toggleButtonWidth: CGFloat = 60.0

	let textFieldHeight: CGFloat = 45.0

	var body: some View {
		GeometryReader { _ in
			ZStack {
				VStack {
					Spacer()

					/// Send Address Field
					HStack {
						VStack {
							AddressFieldView(placeholder: S.Send.enterLTCAddressLabel.localize(), text: $viewModel.addressString)
								.frame(height: textFieldHeight, alignment: .leading)
						}
						.padding(.leading, swiftUICellPadding)

						Spacer()

						/// Paste Address button
						Button(action: {
							viewModel.shouldPasteAddress?()
						}) {
							HStack {
								ZStack {
									RoundedRectangle(cornerRadius: 4)
										.frame(width: actionButtonWidth, height: 30, alignment: .center)
										.foregroundColor(Color(UIColor.secondaryButton))
										.shadow(color: Color(UIColor.grayTextTint), radius: 3, x: 0, y: 4).padding(.trailing, 3.0)

									Text(S.Send.pasteLabel.localize())
										.frame(width: actionButtonWidth, height: 30, alignment: .center)
										.font(Font(UIFont.customMedium(size: 15.0)))
										.foregroundColor(Color(UIColor.grayTextTint))
										.overlay(
											RoundedRectangle(cornerRadius: 4)
												.stroke(Color(UIColor.secondaryBorder))
										)
										.padding(.trailing, 3.0)
								}
							}
						}

						/// Scan Address
						Button(action: {
							viewModel.shouldScanAddress?()
						}) {
							HStack {
								ZStack {
									RoundedRectangle(cornerRadius: 4)
										.frame(width: actionButtonWidth, height: 30, alignment: .center)
										.foregroundColor(Color(UIColor.secondaryButton))
										.shadow(color: Color(UIColor.grayTextTint),
										        radius: 3,
										        x: 0, y: 4)
										.padding(.trailing, 8.0)

									Text(S.Send.scanLabel.localize())
										.frame(width: actionButtonWidth, height: 30, alignment: .center)
										.font(Font(UIFont.customMedium(size: 15.0)))
										.foregroundColor(Color(UIColor.grayTextTint))
										.overlay(
											RoundedRectangle(cornerRadius: 4)
												.stroke(Color(UIColor.secondaryBorder))
										)
										.padding(.trailing, 8.0)
								}
							}
						}
					}
					.background(
						Color.white.clipShape(RoundedRectangle(cornerRadius: 8.0))
					)
					.padding([.leading, .trailing], swiftUICellPadding)

					Spacer()
				}
			}
			.background(Color.litecoinGray)
		}
	}
}

#Preview {
	SendAddressCellView(viewModel: SendAddressCellViewModel())
}
