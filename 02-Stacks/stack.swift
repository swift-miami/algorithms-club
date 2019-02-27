import Foundation

public struct Stack<Element> {
    private var storage: [Element] = []
    public init() {}

    public init(_ elements: [Element]) {
        storage = elements
    }

    /*:
     Adds element to top of stack
    */
    public mutating func push(_ element: Element) {
        storage.append(element)
    }

    /*:
     Removes topmost element or nil if empty
     and returns the value
    */
    @discardableResult
    public mutating func pop() -> Element? {
        return storage.popLast()
    }

    /*:
     Returns topmost value of stack or nil
     Does not remove element
    */
    public func peek() -> Element? {
        return storage.last
    }

    /*:
     Returns empty state of stack
    */
    public var isEmpty: Bool {
        return peek() == nil
    }
}

extension Stack: ExpressibleByArrayLiteral {
    /*:
     Allows for creation of stack by setting stack equal
     to array.
     `let stack: Stack<Int> = [1, 2, 3]
    */
    public init(arrayLiteral elements: Element...) {
        storage = elements
    }
}

// For debugging print output
extension Stack: CustomStringConvertible {
    public var description: String {
        let topDivider      = "-------------top----------------\n"
        let bottomDivider   = "\n--------------------------------"

        let stackElements = storage.map { "\($0)" }
                                   .reversed()
                                   .joined(separator: "\n")

        return topDivider + stackElements + bottomDivider
    }
}
