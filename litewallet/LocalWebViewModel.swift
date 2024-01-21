import Combine
import Foundation

class LocalWebViewModel: ObservableObject {
	var showLoader = PassthroughSubject<Bool, Never>()
	var valuePublisher = PassthroughSubject<String, Never>()
}
