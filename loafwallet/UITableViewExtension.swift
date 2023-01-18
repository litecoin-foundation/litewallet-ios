import UIKit

extension UITableView {
	func register<T: UITableViewCell>(_: T.Type) {
		register(T.self, forCellReuseIdentifier: T.defaultReuseIdentifier)
	}

	func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
		guard let cell = dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
			fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
		}
		return cell
	}

	func dequeueReusableView<T: UITableViewCell>() -> T {
		guard let cell = dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier) as? T else {
			fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
		}
		return cell
	}
}

protocol ReusableView: AnyObject {
	static var defaultReuseIdentifier: String { get }
	static var defaultKind: String { get }
}

extension ReusableView where Self: UIView {
	static var defaultReuseIdentifier: String {
		return NSStringFromClass(self)
	}

	static var defaultKind: String {
		return "kind.\(NSStringFromClass(self))"
	}
}

extension UITableViewCell: ReusableView {}

extension UICollectionReusableView: ReusableView {}
