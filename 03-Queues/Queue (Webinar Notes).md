# My Definition
A first in first out data structure that allows for removing the first in line element and inserts elements at the end of the line. This keeps all data in the original order that it was inserted.

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

## Types of Implementation
- Array based
  - Pros
    - Simple implementation
  - Cons
    - Dequeue actions are `O(n)` 
- doubly linked list (A linked list where a node has knowledge of element before and after)
  - Pros
    - Enqueue & Dequeue `O(1)` & space complexity `O(n)`
  - Con
    - Each element needs forward and back reference which uses more memory 
- ring buffer
  - NOT COVERING 
- 2 stacks
  - Pro
    - Enqueue & Dequeue `O(1)`
    - Better than linked list because elements are in contiguous memory blocks

![IMAGE](resources/AF441A9BDD569FB1A93A711E42F9A558.jpg =507x494)

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