import Foundation
import UIKit

class AnimatedCardViewModel: ObservableObject
{
	@Published
	var rotateIn3D = false

	@Published
	var isLoggedIn = false

	@Published
	var imageFront = "litecoin-front-card-border"

	var dropOffset: CGFloat = -200.0

	init() {}
}
