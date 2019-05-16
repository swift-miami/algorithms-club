```swift
public struct QueueStack<T>: Queue {
    private var leftStack: [T]  = []
    private var rightStack: [T] = []
    
    public var isEmpty: Bool {
        return leftStack.isEmpty && rightStack.isEmpty
    }
    
    public var peek: T? {
        return !leftStack.isEmpty ? leftStack.last : rightStack.first
    }
    
    public mutating func enqueue(_ element: T) -> Bool {
        rightStack.append(element)
        return true
    }
    
    public mutating func dequeue() -> T? {
        if leftStack.isEmpty {
            leftStack = rightStack.reversed()
            rightStack.removeAll()
        }
        return leftStack.popLast()
    }
}

extension QueueStack: CustomStringConvertible {
    public var description: String {
        let printList = leftStack.reversed() + rightStack
        return String(describing: printList)
    }
}
```

# Notes
This beats the linked list in terms of spacial locality. This is because array elements are next to each other in memory blocks. So a large number of elements will be loaded in a cache on first access.

![IMAGE](resources/66C1CEBAAF64AEF4DA214D1E94CC8D2B.jpg =429x184)
![IMAGE](resources/6FC2EB352D4B1803F8F5E23D98BEB06D.jpg =1132x717)