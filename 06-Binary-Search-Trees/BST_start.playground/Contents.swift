import UIKit

public struct BinarySearchTree<Element: Comparable> {
    public private(set) var root: BinaryNode<Element>?
    public init() {}
}

extension BinarySearchTree: CustomStringConvertible {
    public var description: String {
        guard let root = root else { return "empty tree" }
        return String(describing: root)
    }
}

// MARK: - Insertion
extension BinarySearchTree {

    public mutating func insert(_ value: Element) {
        root = insert(from: root, value: value)
    }

    private func insert(from node: BinaryNode<Element>?, value: Element) -> BinaryNode<Element> {
        guard let node = node else {
            return BinaryNode(value: value)
        }

        if value < node.value {
            node.leftChild = insert(from: node.leftChild, value: value)
        } else {
            node.rightChild = insert(from: node.rightChild, value: value)
        }

        return node
    }
}

// MARK: - Contains Naive
extension BinarySearchTree {
    public func contains(_ value: Element) -> Bool {

        var current = root

        while let node = current {

            if node.value == value {
                return true
            }

            if value < node.value {
                current = node.leftChild
            } else {
                current = node.rightChild
            }
        }

        return false
    }
}

private extension BinaryNode {
    var min: BinaryNode {
        return leftChild?.min ?? self
    }
}

extension BinarySearchTree {
    public mutating func remove(_ value: Element) {
        root = remove(node: root, value: value)
    }

    private func remove(node: BinaryNode<Element>?, value: Element) -> BinaryNode<Element>? {

        guard let node = node else { return nil }

        if value == node.value {
            if node.leftChild == nil && node.rightChild == nil {
                return nil
            }

            if node.leftChild == nil {
                return node.rightChild
            }


            if node.rightChild == nil {
                return node.leftChild
            }

            node.value = node.rightChild!.min.value

            node.rightChild = remove(node: node.rightChild, value: node.value)

        } else if value < node.value {
            node.leftChild = remove(node: node.leftChild, value: value)
        } else {
            node.rightChild = remove(node: node.rightChild, value: value)
        }

        return node
    }

}



var exampleTree: BinarySearchTree<Int> {
    var bst = BinarySearchTree<Int>()
    bst.insert(3)
    bst.insert(1)
    bst.insert(4)
    bst.insert(0)
    bst.insert(2)
    bst.insert(5)
    return bst
}

exampleTree.contains(1110)
[0].count

/* Convert sorted array to a Binary Search Tree */
class TreeNode {
    var val: Int
    var left: TreeNode?
    var right: TreeNode?
    
    init(_ val: Int) {
        self.val = val
    }
}

extension TreeNode: CustomStringConvertible {
    
    public var description: String {
        return diagram(for: self)
    }
    
    private func diagram(for node: TreeNode?,
                         _ top: String = "",
                         _ root: String = "",
                         _ bottom: String = "") -> String {
        guard let node = node else {
            return root + "nil\n"
        }
        if node.left == nil && node.right == nil {
            return root + "\(node.val)\n"
        }
        return diagram(for: node.right, top + " ", top + "┌──", top + "│ ")
            + root + "\(node.val)\n"
            + diagram(for: node.left, bottom + "│ ", bottom + "└──", bottom + " ")
    }
}

func sortedArrayToBSTSlicing(_ nums: [Int]) -> TreeNode? {
    if nums.isEmpty { return nil }

    let mid = nums.count / 2
    let num = nums[mid]

    let node = TreeNode(num)
    node.left = sortedArrayToBST( Array( nums[0..<mid] ))
    node.right = sortedArrayToBST( Array( nums[(mid + 1)..<nums.count] ))
    return node
}

func sortedArrayToBST(_ nums: [Int]) -> TreeNode? {
    return convertToBST(nums, 0, nums.count - 1)
}

private func convertToBST(_ nums: [Int], _ minIndex: Int, _ maxIndex: Int) -> TreeNode? {
    guard minIndex <= maxIndex else { return nil }
    
    let midIndex = maxIndex - (maxIndex - minIndex) / 2
    let val = nums[midIndex]
    
    let node = TreeNode(val)
    node.left = convertToBST(nums, minIndex, midIndex - 1)
    node.right = convertToBST(nums, midIndex + 1, maxIndex)
    return node
}

let arr = [0, 1, 2, 4, 5, 6, 7, 8]

let treeSliced = sortedArrayToBSTSlicing(arr)
print(treeSliced!)

let tree = sortedArrayToBST(arr)
print(tree!)
