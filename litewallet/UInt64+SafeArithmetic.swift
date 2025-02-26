import Foundation

extension UInt64 {
	/// Adds two `UInt64` values safely, returning `nil` if overflow occurs.
	///
	/// This method is useful when you want to perform arithmetic operations
	/// on `UInt64` values but need to ensure that the result stays within
	/// the representable range of `UInt64`. Instead of causing a runtime crash
	/// due to overflow, this method gracefully handles the overflow case by
	/// returning `nil`.
	///
	/// - Parameter value: The value to add to the current `UInt64`.
	/// - Returns: The sum of the two values, or `nil` if the operation results in an overflow.
	func safeAddition(_ value: UInt64) -> UInt64? {
		let (result, overflow) = addingReportingOverflow(value)
		return overflow ? nil : result
	}

	/// Subtracts a `UInt64` value safely, returning `nil` if underflow occurs.
	///
	/// This method is useful when you want to perform subtraction on `UInt64`
	/// values but need to ensure that the result does not go below zero (since
	/// `UInt64` cannot represent negative numbers). Instead of causing a
	/// runtime crash due to underflow, this method gracefully handles the
	/// underflow case by returning `nil`.
	///
	/// - Parameter value: The value to subtract from the current `UInt64`.
	/// - Returns: The result of the subtraction, or `nil` if the operation results in an underflow.
	func safeSubtraction(_ value: UInt64) -> UInt64? {
		let (result, underflow) = subtractingReportingOverflow(value)
		return underflow ? nil : result
	}
}
