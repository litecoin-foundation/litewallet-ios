import Foundation
import UIKit

/// Implement Trackabble in your class to have access to these functions
public protocol Trackable {
	func saveEvent(_ eventName: String)
	func saveEvent(_ eventName: String, attributes: [String: String])
}

extension Trackable {
	func saveEvent(_ eventName: String) {
		NotificationCenter.default.post(name: EventManager.eventNotification, object: nil, userInfo: [
			EventManager.eventNameKey: eventName,
		])
	}

	func saveEvent(_ eventName: String, attributes: [String: String]) {
		NotificationCenter.default.post(name: EventManager.eventNotification, object: nil, userInfo: [
			EventManager.eventNameKey: eventName,
			EventManager.eventAttributesKey: attributes,
		])
	}
}

private var emKey: UInt8 = 1

// EventManager is attached to BRAPIClient
extension BRAPIClient {
	var events: EventManager? {
		return lazyAssociatedObject(self, key: &emKey) {
			return EventManager(adaptor: self)
		}
	}

	func saveEvent(_ eventName: String) {
		events?.saveEvent(eventName)
	}

	func saveEvent(_ eventName: String, attributes: [String: String]) {
		events?.saveEvent(eventName, attributes: attributes)
	}
}

class EventManager {
	typealias Attributes = [String: String]

	fileprivate static let eventNotification = Notification.Name("__saveEvent__")
	fileprivate static let eventNameKey = "__event_name__"
	fileprivate static let eventAttributesKey = "__event_attributes__"

	private let sessionId = NSUUID().uuidString
	private let queue = OperationQueue()
	private var isSubscribed = false
	private let eventToNotifications: [String: NSNotification.Name] = [
		"foreground": UIScene.willEnterForegroundNotification,
		"background": UIScene.didEnterBackgroundNotification,
	]
	private var buffer = [Event]()
	private let adaptor: BRAPIAdaptor

	struct Event {
		let sessionId: String
		let time: TimeInterval
		let eventName: String
		let attributes: Attributes

		var dictionary: [String: Any] {
			return ["sessionId": sessionId,
			        "time": time,
			        "eventName": eventName,
			        "metadata": attributes]
		}
	}

	init(adaptor: BRAPIAdaptor) {
		self.adaptor = adaptor
		queue.maxConcurrentOperationCount = 1
	}

	func saveEvent(_ eventName: String) {
		pushEvent(eventName: eventName, attributes: [:])
	}

	func saveEvent(_ eventName: String, attributes: [String: String]) {
		pushEvent(eventName: eventName, attributes: attributes)
	}

	func up() {
		guard !isSubscribed else { return }
		defer { isSubscribed = true }

		// slurp up app lifecycle events and save them as events
		eventToNotifications.forEach { key, value in
			NotificationCenter.default.addObserver(forName: value,
			                                       object: nil,
			                                       queue: self.queue,
			                                       using: { [weak self] note in
			                                       	self?.saveEvent(key)
			                                       	if note.name == UIScene.didEnterBackgroundNotification {
			                                       		self?.persistToDisk()
			                                       	}
			                                       })
		}

		// slurp up events sent as notifications
		NotificationCenter.default.addObserver(
			forName: EventManager.eventNotification, object: nil, queue: queue
		) { [weak self] note in
			guard let eventName = note.userInfo?[EventManager.eventNameKey] as? String
			else {
				print("[EventManager] received invalid userInfo dict: \(String(describing: note.userInfo))")
				return
			}
			if let eventAttributes = note.userInfo?[EventManager.eventAttributesKey] as? Attributes {
				self?.saveEvent(eventName, attributes: eventAttributes)
			} else {
				self?.saveEvent(eventName)
			}
		}
	}

	func down() {
		guard isSubscribed else { return }
		eventToNotifications.forEach { _, value in
			NotificationCenter.default.removeObserver(self, name: value, object: nil)
		}
	}

	private var shouldRecordData: Bool {
		return UserDefaults.hasAquiredShareDataPermission
	}

	func sync(completion _: @escaping () -> Void) {
		guard shouldRecordData else { removeData(); return }
	}

	private func pushEvent(eventName: String, attributes: [String: String]) {
		queue.addOperation { [weak self] in
			guard let myself = self else { return }
			print("[EventManager] pushEvent name=\(eventName) attributes=\(attributes)")
			myself.buffer.append(Event(sessionId: myself.sessionId,
			                           time: Date().timeIntervalSince1970 * 1000.0,
			                           eventName: eventName,
			                           attributes: attributes))
		}
	}

	private func persistToDisk() {
		queue.addOperation { [weak self] in
			guard let myself = self else { return }
			let dataDirectory = myself.unsentDataDirectory
			if !FileManager.default.fileExists(atPath: dataDirectory) {
				do {
					try FileManager.default.createDirectory(atPath: dataDirectory, withIntermediateDirectories: false, attributes: nil)
				} catch {
					print("[EventManager] Could not create directory: \(error)")
				}
			}
			let fullPath = NSString(string: dataDirectory).appendingPathComponent("/\(NSUUID().uuidString).json")
			if let outputStream = OutputStream(toFileAtPath: fullPath, append: false) {
				outputStream.open()
				defer { outputStream.close() }
				let dataToSerialize = myself.buffer.map { $0.dictionary }
				guard JSONSerialization.isValidJSONObject(dataToSerialize) else { print("Invalid json"); return }
				var error: NSError?
				if JSONSerialization.writeJSONObject(dataToSerialize, to: outputStream, options: [], error: &error) == 0
				{
					print("[EventManager] Unable to write JSON for events file: \(String(describing: error))")
				} else {
					print("[EventManager] saved \(myself.buffer.count) events to disk")
				}
			}
			myself.buffer.removeAll()
		}
	}

	private func removeData() {
		queue.addOperation { [weak self] in
			guard let myself = self else { return }
			guard let files = try? FileManager.default.contentsOfDirectory(atPath: myself.unsentDataDirectory) else { return }
			files.forEach { baseName in
				let fileName = NSString(string: myself.unsentDataDirectory).appendingPathComponent("/\(baseName)")
				do {
					try FileManager.default.removeItem(atPath: fileName)
				} catch {
					print("[EventManager] Unable to remove events file at path \(fileName): \(error)")
				}
			}
		}
	}

	private func eventTupleArrayToDictionary(_ events: [[String: Any]]) -> [String: Any] {
		return ["deviceType": 0,
		        "appVersion": Bundle.main.infoDictionary?["CFBundleShortVersionString"] ?? -1,
		        "events": events]
	}

	private var unsentDataDirectory: String {
		let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
		let documentsDirectory = NSString(string: paths[0])
		return documentsDirectory.appendingPathComponent("/event-data")
	}
}
