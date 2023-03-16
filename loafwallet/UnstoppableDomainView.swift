import Combine
import SwiftUI

struct UnstoppableDomainView: View {
	// MARK: - Combine Variables

	@ObservedObject
	var viewModel: UnstoppableDomainViewModel

	@State
	private var didReceiveLTCfromUD: Bool = false

	@State
	private var shouldDisableLookupButton: Bool = true

	@State
	private var didStartEditing: Bool = false

	@State
	private var shouldStartScroll: Bool = false

	init(viewModel: UnstoppableDomainViewModel) {
		self.viewModel = viewModel
	}

	var body: some View {
		GeometryReader { _ in

			ZStack {
				VStack {
					Spacer()
					HStack {
						if viewModel.isDomainResolving {
							if #available(iOS 14.0, *) {
								ProgressView()
									.padding(.all, swiftUICellPadding)
							} else {
								ActivityIndicator(isAnimating: .constant(true), style: .large)
									.padding(.all, swiftUICellPadding)
							}
						} else {
							VStack {
								ZStack {
									AddressFieldView(viewModel.placeholderString,
									                 text: $viewModel.searchString)
										.onTapGesture {
											didStartEditing = true
										}
										.frame(height: 45.0, alignment: .leading)
										.padding(.leading, swiftUICellPadding)
								}
							}
						}

						Spacer()
						Button(action: {
							viewModel.resolveDomain()
						}) {
							HStack(spacing: 10) {
								ZStack {
									RoundedRectangle(cornerRadius: 4)
										.frame(width: 60, height: 30, alignment: .center)
										.foregroundColor(Color(UIColor.secondaryButton))
										.shadow(color: Color(UIColor.grayTextTint), radius: 3, x: 0, y: 4).padding(.trailing, 18)

									Text(S.Send.UnstoppableDomains.lookup.localize())
										.frame(width: 60, height: 30, alignment: .center)
										.font(Font(UIFont.customMedium(size: 15.0)))
										.foregroundColor(Color(UIColor.grayTextTint))
										.overlay(
											RoundedRectangle(cornerRadius: 4)
												.stroke(Color(UIColor.secondaryBorder))
										)
										.padding(.trailing, 18)
								}
							}
						}
						.onReceive(viewModel.$searchString,
						           perform: { currentString in

						           	// Description: the minmum domain length is 4 e.g.; 'a.zil'
						           	// Enabling the button until the domain string is at least 4 chars long
						           	shouldDisableLookupButton = currentString.count < 4

						           })
						.disabled(shouldDisableLookupButton)
					}
					.background(
						Color.white.clipShape(RoundedRectangle(cornerRadius: 8.0))
					)
					.padding([.leading, .trailing], swiftUICellPadding)

					Spacer()

					// Unstoppable Domains Image and URL
					HStack {
						Spacer()
						Text(S.Send.UnstoppableDomains.enterA.localize() + " " + S.Send.UnstoppableDomains.domain.localize() + ":")
							.font(Font(UIFont.barlowMedium(size: 15.0)))
							.foregroundColor(Color(UIColor.litecoinDarkSilver))
							.opacity(0.8)
							.frame(height: 20)

						Text("\(viewModel.currentDomain)")
							.font(Font(UIFont.barlowMedium(size: 15.0)))
							.foregroundColor(Color(UIColor.litecoinDarkSilver))
							.opacity(0.8)
							.padding(.trailing, 2.0)
							.frame(height: 20)
							.frame(width: 80)

						ZStack {
							Image("ud-color-logo")
								.resizable()
								.aspectRatio(contentMode: .fit)
								.frame(height: 20, alignment: .center)
								.padding(.all, 4.0)
								.onTapGesture {
									guard let url = URL(string: "https://unstoppabledomains.com/?ref=6897e86a35e34f1")
									else {
										return
									}

									if #available(iOS 10.0, *) {
										UIApplication.shared.open(url,
										                          options: [:],
										                          completionHandler: nil)
									} else {
										UIApplication.shared.openURL(url)
									}

									LWAnalytics.logEventWithParameters(itemName: ._20220822_UTOU)
								}
						}
						.padding([.leading, .trailing], swiftUICellPadding)
						.padding(.bottom, 4.0)
					}
				}
			}
			.background(Color.litecoinGray)
		}
	}
}

struct UnstoppableDomainView_Previews: PreviewProvider {
	static let viewModel = UnstoppableDomainViewModel()

	static var previews: some View {
		Group {
			UnstoppableDomainView(viewModel: viewModel)
				.previewDevice(PreviewDevice(rawValue: "iPhone SE"))
				.previewDisplayName("iPhone SE")

			UnstoppableDomainView(viewModel: viewModel)
				.previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro Max"))
				.previewDisplayName("iPhone 12 Pro Max")
		}
	}
}
