import UIKit

extension CGContext {
	func addLineThrough(_ points: [(CGFloat, CGFloat)]) {
		guard let first = points.first else { return }
		move(to: CGPoint(x: first.0, y: first.1))
		for point in points.dropFirst() {
			addLine(to: CGPoint(x: point.0, y: point.1))
		}
	}
}
