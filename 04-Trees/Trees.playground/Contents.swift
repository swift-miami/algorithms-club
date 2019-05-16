import UIKit

public class TreeNode<T> {
    public var value: T
    public var children: [TreeNode] = []
    
    public init(_ value: T) {
        self.value = value
    }
    
    public func add(_ child: TreeNode) {
        children.append(child)
    }
}




func makeBeverageTree() -> TreeNode<String> {
    let tree = TreeNode("Beverages")
    let hot = TreeNode("hot")
    let cold = TreeNode("cold")
    
    let tea = TreeNode("tea")
    let coffee = TreeNode("coffee")
    let chocolate = TreeNode("cocoa")
    let blackTea = TreeNode("black")
    
    let greenTea = TreeNode("green")
    let chaiTea = TreeNode("chai")
    let soda = TreeNode("soda")
    let milk = TreeNode("milk")
    let gingerAle = TreeNode("ginger ale")
    let bitterLemon = TreeNode("bitter lemon")
    tree.add(hot)
    tree.add(cold)
    hot.add(tea)
    hot.add(coffee)
    hot.add(chocolate)
    cold.add(soda)
    cold.add(milk)
    
    tea.add(blackTea)
    tea.add(greenTea)
    tea.add(chaiTea)
    soda.add(gingerAle)
    soda.add(bitterLemon)
    return tree
}

let tree = makeBeverageTree()


// MARK: - Depth First
extension TreeNode {
    public func forEachDepthFirst(visit: (TreeNode) -> Void) {
        visit(self)
        children.forEach {
            $0.forEachDepthFirst(visit: visit)
        }
    }
}

public struct Queue<T> {
    
    private var leftStack: [T] = []
    private var rightStack: [T] = []
    
    public init() {}
    
    public var isEmpty: Bool {
        return leftStack.isEmpty && rightStack.isEmpty
    }
    
    public var peek: T? {
        return !leftStack.isEmpty ? leftStack.last : rightStack.first
    }
    
    public private(set) var count = 0
    @discardableResult public mutating func enqueue(_ element: T) -> Bool {
        count += 1
        rightStack.append(element)
        return true
    }
    
    public mutating func dequeue() -> T? {
        if leftStack.isEmpty {
            leftStack = rightStack.reversed()
            rightStack.removeAll()
        }
        
        let value = leftStack.popLast()
        if value != nil {
            count -= 1
        }
        return value
    }
}

// MARK: - Breadth First
extension TreeNode {
    public func forEachBreadthFirst(visit: (TreeNode) -> Void) {
        visit(self)
        var queue = Queue<TreeNode>()
        children.forEach { queue.enqueue($0) }
        
        while let node = queue.dequeue() {
            visit(node)
            node.children.forEach { queue.enqueue($0) }
        }
    }
}


//tree.forEachDepthFirst(visit: { print($0.value) })

//tree.forEachBreadthFirst(visit: { print($0.value) })


/**
Challenge

Print each level of a tree on a new line (all values on the same line) with the current level printed at the beginning.

```
Level 0: 0
Level 1: 1, 2, 3
Level 2: 4, 5, 6, 7, 8
```
**/

    func printEachLevel<T>(for tree: TreeNode<T>) {
        var queue = [TreeNode<T>]()
        var nodesLeftInCurrentLevel = 0
        var depth = 0
        
        queue.append(tree)
        
        while !queue.isEmpty {
            nodesLeftInCurrentLevel = queue.count
            print("Level \(depth): ", terminator: "")
            while nodesLeftInCurrentLevel > 0 {
                if queue.first == nil { break }
                let node = queue.removeFirst()
                
                let finishText = nodesLeftInCurrentLevel == 1 ? " " : ", "

                print("\(node.value)\(finishText)", terminator: "")
                
                queue.append(contentsOf: node.children)
//                node.children.forEach { queue.append($0) }
                
                nodesLeftInCurrentLevel -= 1
            }
            print()
            depth += 1
        }
    }

printEachLevel(for: tree)

func traversalByLevel<T>(visit: ([TreeNode<T>], Int) -> Void) {
    var level               = 0
    var levelNodes          = [TreeNode]()
    var nodesInCurrentLevel = 1
    var nodesInNextLevel    = 0
    let queue               = Queue<TreeNode>()
    
    queue.enqueue(value: self)
    
    while let node = queue.dequeue() {
        levelNodes.append(node)
        nodesInCurrentLevel -= 1
        
        node.children.forEach { queue.enqueue(value: $0) }
        nodesInNextLevel += node.children.count
        
        if nodesInCurrentLevel == 0 {
            visit(levelNodes, level)
            levelNodes = []
            level += 1
            nodesInCurrentLevel = nodesInNextLevel
            nodesInNextLevel = 0
        }
    }
}
