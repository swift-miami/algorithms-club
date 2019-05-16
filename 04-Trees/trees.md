# Trees

A hierarchal data structure that can represent hierarchal relationships, manage sorted data and help speed up lookup.

## Terminology

#### Node
- A data structure that encapsulates a piece of data and tracks it's children

#### Parent & Child
- Every node (except for the topmost one) is connected to exactly one node above it. That node is called a parent node. The nodes directly below and connected to it are called its child nodes. In a tree, every child has exactly one parent. That’s what makes a tree, well, a tree.

#### Root
The topmost node in a tree

#### Leaf
A node w/ not children

#### Edges
Edges are determined after running a depth first search (DFS)

* Tree Edge
  *  If `v` is visited for the first time as we traverse the edge(`u`, `v`), then the edge is a tree edge. Simply put this will be any line that is created while running a DFS
* Forward Edge
  * It is an edge (`u`, `v`) such that `v` is descendant but not part of the DFS tree. Edge from root node to leaf is a forward edge.
* Back Edge
  *  It is an edge (`u`, `v`) such that `v` is ancestor of edge `u` but not part of DFS tree. Edge from leaf to root node is a back edge.
* Cross Edge
  * It is a edge which connects two node such that they do not have any ancestor and a descendant relationship between them. Edge from node 5 to 4 is cross edge.
[Reference](https://www.geeksforgeeks.org/tree-back-edge-and-cross-edges-in-dfs-of-graph/)
[Stack Overflow](https://cs.stackexchange.com/questions/11116/difference-between-cross-edges-and-forward-edges-in-a-dft)

#### Backtracking
* Backtracking is a general algorithm for finding all (or some) solutions to some computational problems, notably constraint satisfaction problems, that incrementally builds candidates to the solutions, and abandons a candidate ("backtracks") as soon as it determines that the candidate cannot possibly be completed to a valid solution
* In laymans terms, reaching a node, determining it does not satisfy the requirement or predicate, moving backwards along the edge to a previous node
[Wikipedia](https://en.wikipedia.org/wiki/Backtracking)

## Traversal
* Depth First
  * Starts at the root node and explores as far as possible before backtracking
  
``` swift
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

// MARK: - Depth First
extension TreeNode {
  public func forEachDepthFirst(visit: (TreeNode) -> Void) {
    visit(self)
    children.forEach {
      $0.forEachDepthFirst(visit: visit)
    }
  }
}
```
For a depth first search, using recursion will nest the logic. Think if you have a 3 level deep tree the first level will call `visit` then recurse on children, the first child will call `visit` then then start iterating over children, and the process repeats on the first child. So it will traverse all the way to the far left bottom node first.


### Level Order or Breadth First
* Rather than traversing down to the furthest nodes first, this will traverse the first level of nodes, then second and so on. (Root node [0], Root node's children [1]...)

```
extension TreeNode {
  public func forEachLevelOrder(visit: (TreeNode) -> Void) {
    visit(self)
    var queue = Queue<TreeNode>()
    children.forEach { queue.enqueue($0) }
    while let node = queue.dequeue() {
		visit(node)
      	node.children.forEach { queue.enqueue($0) }
    }
  } 
}
```

### Challenge
Print each level of a tree on a new line (all values on the same line) with the current level printed at the beginning.

```
Level 0: 0
Level 1: 1, 2, 3
Level 2: 4, 5, 6, 7, 8
```

Answer

```
extension TreeNode {
    
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
                print("\(node.value), ", terminator: "")
                node.children.forEach {
                    queue.append($0)
                }
                nodesLeftInCurrentLevel -= 1
            }
            depth += 1
            print()
        }
    }
}
```