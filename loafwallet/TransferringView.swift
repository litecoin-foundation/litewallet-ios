import Foundation
import SwiftUI
import UIKit

struct TransferringModalView: View {
	// MARK: - Combine Variables

	@ObservedObject
	var viewModel: TransferringViewModel

	@Binding
	var isShowingTransferring: Bool

	@Binding
	var shouldStartTransfer: Bool

	@State
	var detailMessage: String = S.LitecoinCard.resetPasswordDetail

	// MARK: - Private Variables

	private var destinationAddress: String

	private var transferAmount: Double

	private var walletType: WalletType

	private let generalSidePadding: CGFloat = 40.0

	init(viewModel: TransferringViewModel,
	     isShowingTransferring: Binding<Bool>,
	     shouldStartTransfer: Binding<Bool>,
	     destinationAddress: String,
	     transferAmount: Double,
	     walletType: WalletType)
	{
		_isShowingTransferring = isShowingTransferring

		_shouldStartTransfer = shouldStartTransfer

		self.viewModel = viewModel

		self.destinationAddress = destinationAddress

		self.transferAmount = transferAmount

		print("XXX Transferring View transfer Amount\(self.transferAmount)")

		self.walletType = walletType

		// Flip for the transfer destination
		if self.walletType == .litewallet {
			self.walletType = .litecoinCard
		} else {
			self.walletType = .litewallet
		}
	}

	var body: some View {
		GeometryReader { (deviceSize: GeometryProxy) in
			HStack {
				Spacer()
				ZStack {
					VStack {
						// Dismiss button
						Button(action: {
							viewModel.shouldDismissView {
								self.isShowingTransferring.toggle()
								viewModel.shouldStartTransfer = false
							}

						}) {
							Image("whiteCross")
								.resizable()
								.aspectRatio(contentMode: .fit)
								.frame(width: 15,
								       height: 15)
						}
						.frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)

						Text(S.LitecoinCard.Transfer.title + ": " + String(format: "%6.6f Ł", self.transferAmount))
							.font(Font(UIFont.barlowSemiBold(size: 21.0)))
							.padding(.bottom, 10)
							.foregroundColor(Color.white)
							.padding([.leading, .trailing], generalSidePadding)

						Text(S.Fragments.to + " " + (self.walletType == .litewallet ? "Litewallet" : S.LitecoinCard.barItemTitle.localizedCapitalized))
							.font(Font(UIFont.barlowSemiBold(size: 21.0)))
							.padding(.bottom, 10)
							.foregroundColor(Color.white)
							.padding([.leading, .trailing], generalSidePadding)

						// Confirm OK button
						Button(action: {
							viewModel.shouldStartTransfer = true
						}) {
							Text(S.Button.ok)
								.frame(minWidth: 0, maxWidth: .infinity)
								.font(Font(UIFont.barlowBold(size: 20.0)))
								.foregroundColor(Color.white)
								.padding(.all, 8)
								.overlay(
									RoundedRectangle(cornerRadius: 4)
										.stroke(Color(UIColor.white), lineWidth: 1)
								)
								.padding([.leading, .trailing], generalSidePadding)
								.padding([.top, .bottom], 10)
						}.padding(.top, 15)
					}
					.padding()
					.overlay(
						RoundedRectangle(cornerRadius: 8)
							.stroke(Color.gray, lineWidth: 1.5)
					)
					.background(Color(UIColor.liteWalletBlue))
					.cornerRadius(8)
					.frame(
						width: deviceSize.size.width * 0.9,
						height: deviceSize.size.height * 0.95
					)
					.shadow(color: .black, radius: 10, x: 5, y: 5)
					.opacity(self.isShowingTransferring ? 1 : 0)
				}
				Spacer()
			}
		}
	}
}

struct TransferringModalView_Previews: PreviewProvider {
	static let viewModel = TransferringViewModel()
	static let destinationAddres1: String = "MVZj7gBRwcVpa9AAWdJm8A3HqTst112eJe"
	static let destinationAddres2: String = "MJ4W7NZya4SzE7R6xpEVdamGCimaQYPiWu"
	static let bigTransferAmount: Double = 15274.00343
	static let smallTransferAmount: Double = 0.0254521

	static var previews: some View {
		Group {
			TransferringModalView(viewModel: viewModel,
			                      isShowingTransferring: .constant(true),
			                      shouldStartTransfer: .constant(true),
			                      destinationAddress: destinationAddres1,
			                      transferAmount: bigTransferAmount,
			                      walletType: .litecoinCard)
				.previewDevice(PreviewDevice(rawValue: DeviceType.Name.iPhoneSE2))
				.previewDisplayName(DeviceType.Name.iPhoneSE2)

			TransferringModalView(viewModel: viewModel,
			                      isShowingTransferring: .constant(true),
			                      shouldStartTransfer: .constant(true),
			                      destinationAddress: destinationAddres2,
			                      transferAmount: bigTransferAmount,
			                      walletType: .litewallet)
				.previewDevice(PreviewDevice(rawValue: DeviceType.Name.iPhone8))
				.previewDisplayName(DeviceType.Name.iPhone8)

			TransferringModalView(viewModel: viewModel,
			                      isShowingTransferring: .constant(true),
			                      shouldStartTransfer: .constant(true),
			                      destinationAddress: destinationAddres1,
			                      transferAmount: bigTransferAmount,
			                      walletType: .litecoinCard)
				.previewDevice(PreviewDevice(rawValue: DeviceType.Name.iPhone12ProMax))
				.previewDisplayName(DeviceType.Name.iPhone12ProMax)
		}
	}
}
