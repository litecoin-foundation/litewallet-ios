import SwiftUI

struct PreTransferView: View
{
	// MARK: - Combine Variables

	@Binding
	var wasTapped: Bool

	@Binding
	var parentWalletType: WalletType

	// MARK: - Private Variables

	private let mainPadding: CGFloat = 20.0

	private let generalCornerRadius: CGFloat = 8.0

	private let largeHeight: CGFloat = 125.0

	var twoFactorEnabled: Bool = false

	var walletBalance: Double

	var localWalletType: WalletType

	init(walletBalance: Double,
	     parentWalletType: Binding<WalletType>,
	     localWalletType: WalletType,
	     wasTapped: Binding<Bool>,
	     twoFactorEnabled: Bool)
	{
		_wasTapped = wasTapped

		_parentWalletType = parentWalletType

		self.walletBalance = walletBalance

		self.twoFactorEnabled = twoFactorEnabled

		self.localWalletType = localWalletType
	}

	var body: some View
	{
		VStack
		{
			ZStack
			{
				RoundedRectangle(cornerRadius: generalCornerRadius)
					.frame(height: largeHeight,
					       alignment: .center)
					.frame(maxWidth: .infinity)
					.padding(mainPadding)
					.foregroundColor(Color.litecoinGray)
					.shadow(radius: 1.0, x: 2.0, y: 2.0)
					.overlay(
						HStack
						{
							// Wallet type image & title
							VStack(alignment: .center)
							{
								Spacer()

								if localWalletType == .litecoinCard
								{
									CardIconView()
								}
								else
								{
									LitewalletIconView()
								}

								Text(localWalletType.nameLabel)
									.font(Font(UIFont.barlowSemiBold(size: 18.0)))
									.foregroundColor(Color.liteWalletDarkBlue)

								Spacer()
							}
							.padding(.leading, mainPadding + 12.0)

							// Balance label
							VStack
							{
								Text(String(format: "%5.4f Ł", walletBalance))
									.frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
									.foregroundColor(walletBalance == 0.0 ? .litecoinSilver : .liteWalletDarkBlue)
									.multilineTextAlignment(.trailing)
									.font(Font(twoFactorEnabled ? UIFont.barlowRegular(size: 20.0) : UIFont.barlowBold(size: 20.0)))
									.padding(.trailing, twoFactorEnabled ? 5.0 : 40.0)
							}

							// Selection button
							if twoFactorEnabled
							{
								VStack
								{
									Button(action: {
										self.wasTapped = true

										parentWalletType = localWalletType

									})
									{
										ZStack
										{
											Rectangle()
												.frame(minHeight: 0,
												       maxHeight: .infinity,
												       alignment: .center)
												.frame(width: 50.0)
												.foregroundColor(walletBalance == 0.0 ? Color.litewalletLightGray : Color.liteWalletBlue)
												.shadow(radius: 1.0, x: 2.0, y: 2.0)

											Image(systemName: "chevron.right")
												.resizable()
												.aspectRatio(contentMode: .fit)
												.frame(width: 20, height: 20, alignment: .center)
												.foregroundColor(walletBalance == 0.0 ? .litecoinSilver : .white)
										}
									}
									.cornerRadius(generalCornerRadius, corners: [.topRight, .bottomRight])
									.disabled(walletBalance == 0.0 ? true : false)
								}
								.frame(height: largeHeight,
								       alignment: .center)
								.padding(.trailing, mainPadding)
							}
						}
					)
					.frame(height: largeHeight,
					       alignment: .center)
					.frame(maxWidth: .infinity)
			}
		}
	}
}

struct PreTransferView_Previews: PreviewProvider
{
	static let lcImagestr = MockData.cardImageString
	static let lwImagestr = MockData.logoImageString
	static let small = MockData.smallBalance
	static let large = MockData.largeBalance

	static let walletManager = try! WalletManager(store: Store(), dbPath: nil)

	static var previews: some View
	{
		Group
		{
			VStack
			{
				PreTransferView(walletBalance: 0.0,
				                parentWalletType: .constant(.litecoinCard),
				                localWalletType: .litewallet,
				                wasTapped: .constant(false),
				                twoFactorEnabled: false)
				Spacer()
			}
			.previewDevice(PreviewDevice(rawValue: DeviceType.Name.iPhoneSE2))
			.previewDisplayName(DeviceType.Name.iPhoneSE2)
		}
	}
}
