import Foundation

public struct LinkedList<Value> {
    public var head: Node<Value>?
    public var tail: Node<Value>?

    public init() {}

    public var isEmpty: Bool {
        return head == nil
    }

    public mutating func push(_ value: Value) {
        // pushes new node into front of list
        head = Node(value: value, next: head)

        // if list was empty before operation
        // the head is now also the tail
        if tail == nil {
            tail = head
        }
    }

    public mutating func append(_ value: Value) {
        // If list is empty and element is appended
        // instead push into the front which will set it
        // as head and tail
        guard !isEmpty else {
            push(value)
            return
        }

        // Set the tail value to new value being
        // appended
        tail!.next = Node(value: value)

        // Set the tail to the new tail
        tail = tail!.next
    }

   public func node(at index: Int) -> Node<Value>? {
        // Set current node & index to the start of the list
        var currentNode  = head
        var currentIndex = 0

        // Traverse list while there are nodes & less than the index
        while currentNode != nil && currentIndex < index {

            // Sets current node to the next node & advances index
            currentNode = currentNode!.next
            currentIndex += 1
        }

        // LinkedList is 0 indexed so 1 less than the intended index
        //
        return currentNode
    }

    @discardableResult
    public mutating func insert(_ value: Value, after node: Node<Value>) -> Node<Value> {

        // To speed up the operation, check if the tail is the node being looked for
        // if it is this becomes a O(1) operation
        guard tail !== node else {
            append(value)
            return tail!
        }

        // In this case the node being passed in is the one we want to insert after
        // create a new node and set it to the next value of the node, then take the
        // next value (this is the old value, the new one isn't set yet) and set it
        // to next for the newly created node
        node.next = Node(value: value, next: node.next)
        return node.next!
    }

    @discardableResult
    public mutating func pop() -> Value? {
        defer {

            // Sets head to the head's next value (this removes the head from the list
            head = head?.next
            if isEmpty {

                // If the list is now empty the tail is nil
                tail = nil
            }
        }

        // Returns the new head's value
        return head?.value
    }

    // Because a node only knows about the next value
    // The whole list must be traversed to get the element before
    // The last one so that the second to last and last element can be known
    @discardableResult
    public mutating func removeLast() -> Value? {
        // Checks if head has a value, if not returns nil
        guard let head = head else { return nil }

        // Checks if the list is 1 node long, if so just
        // pop off the front node and return it
        guard head.next != nil else { return pop() }

        // previous -> current -> next -> repeat until current.next == nil
        var previous = head
        var current  = head

        while let next = current.next {
            previous = current
            current  = next
        }
        // We now know the last element is current & the 2nd
        // to last element is previous
        // Set tail to previous
        // And set the next value for previous to nil
        previous.next = nil
        tail          = previous
        return current.value
    }

    @discardableResult
    public mutating func remove(after node: Node<Value>) -> Value? {
        defer {
            // Verifies that node to remove is not the tail
            // If so remove tail and set new tail
            if node.next === tail {
                tail = node
            }
            // Gets the value of the next next node (2 over)
            // and sets it to the node in hand's next value
            node.next = node.next?.next
        }

        // returns the value
        return node.next?.value
    }
}

extension LinkedList: CustomStringConvertible {
    public var description: String {
        guard let head = head else {
            return "Empty list"
        }
        return String(describing: head)
    }
}

