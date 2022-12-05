import SwiftUI

struct SendAddressCellView: View {
	// MARK: - Combine Variables

	@ObservedObject
	var viewModel = SendAddressCellViewModel()

	@State
	private var didReceiveLTCfromUD: Bool = false

	@State
	private var shouldDisableLookupButton: Bool = true

	@State
	private var didStartEditing: Bool = false

	let actionButtonWidth: CGFloat = 45.0

	let actionButtonA: CGFloat = 5.0
	let actionButtonB: CGFloat = 18.0

	var body: some View {
		GeometryReader { _ in
			ZStack {
				VStack {
					Spacer()
					HStack {
						VStack {
							AddressFieldView(S.Send.enterLTCAddressLabel, text: $viewModel.addressString)
								.onTapGesture {
									didStartEditing = true
								}
								.frame(height: 45.0, alignment: .leading)
						}
						.padding(.leading, swiftUICellPadding)

						Spacer()

						// Paste Address
						Button(action: {
							viewModel.shouldPasteAddress?()
						}) {
							HStack {
								ZStack {
									RoundedRectangle(cornerRadius: 4)
										.frame(width: actionButtonWidth, height: 30, alignment: .center)
										.foregroundColor(Color(UIColor.secondaryButton))
										.shadow(color: Color(UIColor.grayTextTint), radius: 3, x: 0, y: 4).padding(.trailing, 3.0)

									Text(S.Send.pasteLabel)
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

						// Scan Address
						Button(action: {
							viewModel.shouldScanAddress?()
						}) {
							HStack {
								ZStack {
									RoundedRectangle(cornerRadius: 4)
										.frame(width: actionButtonWidth, height: 30, alignment: .center)
										.foregroundColor(Color(UIColor.secondaryButton))
										.shadow(color: Color(UIColor.grayTextTint), radius: 3, x: 0, y: 4).padding(.trailing, 8.0)

									Text(S.Send.scanLabel)
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

struct SendAddressCellView_Previews: PreviewProvider {
	static let viewModel = SendAddressCellViewModel()

	static var previews: some View {
		Group {
			SendAddressCellView(viewModel: viewModel)
				.previewDevice(PreviewDevice(rawValue: DeviceType.Name.iPhoneSE2))
				.previewDisplayName(DeviceType.Name.iPhoneSE2)

			SendAddressCellView(viewModel: viewModel)
				.previewDevice(PreviewDevice(rawValue: DeviceType.Name.iPhone8))
				.previewDisplayName(DeviceType.Name.iPhone8)

			SendAddressCellView(viewModel: viewModel)
				.previewDevice(PreviewDevice(rawValue: DeviceType.Name.iPhone12ProMax))
				.previewDisplayName(DeviceType.Name.iPhone12ProMax)
		}
	}
}
