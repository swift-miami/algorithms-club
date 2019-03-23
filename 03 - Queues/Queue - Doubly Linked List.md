### Doubly Linked List Implementation
```swift
public class QueueLinkedList<T>: Queue {

    private var list = DoublyLinkedList<T>()
    public init () {}
  
    public var peek: T? {
        return list.first?.value
    }
    
    public var isEmpty: Bool {
        return list.isEmpty
    }
    
    // O(1)
    public func enqueue(_ element: T) -> Bool {
        list.append(element)
        return true
    }
    
    // O(1)
    public func dequeue() -> T? {
        guard !list.isEmpty, let element = list.first else { return nil }
        return list.remove(element)
    }
}

extension QueueLinkedList: CustomStringConvertible {
    public var description: String {
        return String(describing: list)
    }
}
```
![IMAGE](resources/9358EEDE988F426582B9A3BC18AF4E42.jpg =330x142)

#### Doubly Linked List Note
The main weakness with QueueLinkedList is not apparent from the table. Despite O(1) performance, it suffers from high overhead. Each element has to have extra storage for the forward and back reference. Moreover, every time you create a new element, it requires a relatively expensive dynamic allocation. By contrast QueueArray does bulk allocation, which is faster.