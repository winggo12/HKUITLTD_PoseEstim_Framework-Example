
import Accelerate
import CoreImage
import Foundation
//import TensorFlowLite

// MARK: - Data
extension Data {
  /// Creates a new buffer by copying the buffer pointer of the given array.
  ///
  /// - Warning: The given array's element type `T` must be trivial in that it can be copied bit
  ///     for bit with no indirection or reference-counting operations; otherwise, reinterpreting
  ///     data from the resulting buffer has undefined behavior.
  /// - Parameter array: An array with elements of type `T`.
  init<T>(copyingBufferOf array: [T]) {
    self = array.withUnsafeBufferPointer(Data.init)
  }

  /// Convert a Data instance to Array representation.
  func toArray<T>(type: T.Type) -> [T] where T: AdditiveArithmetic {
    var array = [T](repeating: T.zero, count: self.count / MemoryLayout<T>.stride)
    _ = array.withUnsafeMutableBytes { self.copyBytes(to: $0) }
    return array
  }
}

// MARK: - Wrappers
/// Struct for handling multidimension `Data` in flat `Array`.
struct FlatArray<Element: AdditiveArithmetic> {
  private var array: [Element]
  var dimensions: [Int]

  init(tensor: Tensor) {
    dimensions = tensor.shape.dimensions
    array = tensor.data.toArray(type: Element.self)
  }

  private func flatIndex(_ index: [Int]) -> Int {
    guard index.count == dimensions.count else {
      fatalError("Invalid index: got \(index.count) index(es) for \(dimensions.count) index(es).")
    }

    var result = 0
    for i in 0..<dimensions.count {
      guard dimensions[i] > index[i] else {
        fatalError("Invalid index: \(index[i]) is bigger than \(dimensions[i])")
      }
      result = dimensions[i] * result + index[i]
    }
    return result
  }

  subscript(_ index: Int...) -> Element {
    get {
      return array[flatIndex(index)]
    }
    set(newValue) {
      array[flatIndex(index)] = newValue
    }
  }
}
