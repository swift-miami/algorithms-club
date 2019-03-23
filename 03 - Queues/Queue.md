# My Definition
A first in first out data structure that allows for removing the first in line element and inserts elements at the end of the line. This keeps all data in the original order that it was inserted.

# Book Definition
Queues use FIFO or first-in first-out ordering, meaning the first element that was added will always be the first to be removed. Queues are handy when you need to maintain the order of your elements to process later.

## Operations
- enqueue: Insert an element at the back of the queue. Returns true if the operation was successful.
- dequeue: Remove the element at the front of the queue and return it. 
- isEmpty: Check if the queue is empty.
- peek: Return the element at the front of the queue without removing it.

## Key Points
- Queue takes a FIFO strategy, an element added first must also be removed first.
- Enqueue inserts an element to the back of the queue.
- Dequeue removes the element at the front of the queue.
- Elements in an array are laid out in contiguous memory blocks, whereas elements in
a linked list are more scattered with potential for cache misses.
- Ring-buffer-queue based implementation is good for queues with a fixed size.
- Compared to other data structures, leveraging two stacks improves the dequeue(_:) time complexity to amortized O(1) operation.
- Double-stack implementation beats out Linked-list in terms of spacial locality.


### Example Protocol for a Queue Implementation
```swift
public protocol Queue {
  associatedtype Element
  mutating func enqueue(_ element: Element) -> Bool
  mutating func dequeue() -> Element?
  var isEmpty: Bool { get }
  var peek: Element? { get }
}
```

## Notes
Queue can be implemented multiple ways depending on the underlying data structure.
- Using an array
- Using a doubly linked list
- Using a ring buffer
- Using two stacks