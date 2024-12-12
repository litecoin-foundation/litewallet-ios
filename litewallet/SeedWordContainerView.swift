import SwiftUI

struct SeedWordContainerView: View {
	let generalPad: CGFloat = 10.0
	let largePad: CGFloat = 80.0

	let wordPad: CGFloat = 10.0

	let secureFieldHeight: CGFloat = 45.0

	let seedWordCount: Int = 12

	@State
	private var viewColumns = [GridItem]()

	@State
	private var wordViewWidthRoot = 3

	@State
	private var enteredPIN = ""

	@State
	private var shouldShowSeedWords = false

	@State
	private var didEnterPINCode = false

	@ObservedObject
	var seedViewModel = SeedViewModel(enteredPIN: .constant(""))

	var walletManager: WalletManager

	init(walletManager: WalletManager) {
		self.walletManager = walletManager
	}

	var body: some View {
		GeometryReader { geometry in

			let width = geometry.size.width
			let height = geometry.size.height
			let wordViewWidth = width / CGFloat(wordViewWidthRoot) - wordPad
			ZStack {
				VStack {
					HStack {
						Text(S.ShowWords.titleWarning.localize())
							.font(.barlowSemiBold(size: 24.0))
							.multilineTextAlignment(.center)
							.foregroundColor(.litewalletDarkBlue)
							.padding()
					}
					.padding()
					Spacer()
					if shouldShowSeedWords {
						LazyVGrid(columns: viewColumns, spacing: 1.0) {
							ForEach(0 ..< seedWordCount, id: \.self) { increment in
								SeedWordView(seedWord: seedViewModel.seedWords[increment].word,
								             wordNumber: seedViewModel.seedWords[increment].tagNumber)
									.frame(width: wordViewWidth,
									       height: height * 0.1)
							}
						}
						Spacer()
					} else {
						HStack {
							SecureField(S.UpdatePin.enterCurrent.localize(),
							            text: $enteredPIN)
								.keyboardType(.numberPad)
								.multilineTextAlignment(.center)
								.toolbar {
									ToolbarItemGroup(placement: .keyboard) {
										Spacer()
										Button(S.RecoverWallet.done.localize()) {
											didEnterPINCode.toggle()
										}
									}
								}
								.frame(width: width - largePad,
								       height: secureFieldHeight, alignment: .center)
								.padding()
						}
					}
					Spacer()
				}
			}
			.padding(.all, 10)
			.onAppear {
				viewColumns = [GridItem](repeating: GridItem(.flexible()),
				                         count: wordViewWidthRoot)
			}
			.onChange(of: didEnterPINCode) { _ in
				if let fetchedWords = seedViewModel.fetchWords(walletManager: self.walletManager,
				                                               appPIN: enteredPIN)
				{
					seedViewModel.seedWords = fetchedWords
					shouldShowSeedWords = true
				}
			}
		}
	}
}

// #Preview {
//	SeedWordContainerView(walletManager: WalletManager(store: Store()))
// }
