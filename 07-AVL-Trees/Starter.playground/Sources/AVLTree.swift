// Copyright (c) 2018 Razeware LLC
// For full license & permission details, see LICENSE.markdown.

public struct AVLTree<Element: Comparable> {

    public private(set) var root: AVLNode<Element>?

    public init() {}
}

extension AVLTree: CustomStringConvertible {

    public var description: String {
        guard let root = root else { return "empty tree" }
        return String(describing: root)
    }
}

extension AVLTree {

    public mutating func insert(_ value: Element) {
        root = insert(from: root, value: value)
    }

    private func insert(from node: AVLNode<Element>?, value: Element) -> AVLNode<Element> {

        // Verifies there is a node available, if at a leaf this would be nil and it would
        // create the node and return it
        guard let node = node else {
            return AVLNode(value: value)
        }

        if value < node.value {

            // Following BST rules if the node has a less than value it will traverse
            // Down the left child
            node.leftChild = insert(from: node.leftChild, value: value)
        } else {

            // Traverse down the right child
            node.rightChild = insert(from: node.rightChild, value: value)
        }

        // Once the node is in the proper position (possibly unbalanced), the balance
        // function is run
        let balanceNode = balanced(node)

        // Update the node height
        balanceNode.height = max(balanceNode.leftHeight, balanceNode.rightHeight) + 1

        return balanceNode
    }

    private func leftRotate(_ node: AVLNode<Element>) -> AVLNode<Element> {

        // Set the pivot node to the right child of the node being rotated
        let pivot = node.rightChild!

        // Take the pivot's left child and set it to the node being rotated's
        // Left child ( if nil it just sets the node's right child to nil)
        node.rightChild = pivot.leftChild

        // Move the node being rotated to the left child of the pivot
        pivot.leftChild = node

        // Set the node's new height, find the max height between the left & right children
        // And adds 1 to the node & the pivot
        node.height = max(node.leftHeight, node.rightHeight) + 1
        pivot.height = max(pivot.leftHeight, pivot.rightHeight) + 1

        // returns pivot
        return pivot
    }

    private func rightRotate(_ node: AVLNode<Element>) -> AVLNode<Element> {

        // Set the pivot node to the left child
        let pivot = node.leftChild!

        // Take the pivot's right child (even if nil) and set it to the rotated node's
        // right child
        node.leftChild = pivot.rightChild

        // Move the node being rotated to the right child of the pivot
        pivot.rightChild = node

        // Update the height of the pivot node & the rotated node
        node.height = max(node.leftHeight, node.rightHeight) + 1
        pivot.height = max(pivot.leftHeight, pivot.rightHeight) + 1

        // Return pivot
        return pivot
    }

    private func rightLeftRotate(_ node: AVLNode<Element>) -> AVLNode<Element> {

        // Verify that a right child exists else return the node
        guard let rightChild = node.rightChild else { return node }

        // Right rotate the right child
        node.rightChild = rightRotate(rightChild)

        // Left rotate & return the node
        return leftRotate(node)
    }

    private func leftRightRotate(_ node: AVLNode<Element>) -> AVLNode<Element> {

        // Verify that the left node exists else return
        guard let leftChild = node.leftChild else { return node }

        // Left rotate the left child
        node.leftChild = leftRotate(leftChild)

        // Right Rotate the node and return it
        return rightRotate(node)
    }

    private func balanced(_ node: AVLNode<Element>) -> AVLNode<Element> {
        switch node.balanceFactor {
        case 2:
            if let leftChild = node.leftChild,
                leftChild.balanceFactor == -1 {
                    return leftRightRotate(node)
            } else {
                return rightRotate(node)
            }
        case -2:
            if let rightChild = node.rightChild,
                rightChild.balanceFactor == 1 {
                return rightLeftRotate(node)
            } else {
                return leftRotate(node)
            }
        default:
            return node
        }
    }
}

extension AVLTree {

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

private extension AVLNode {

    var min: AVLNode {
        return leftChild?.min ?? self
    }
}

extension AVLTree {

    public mutating func remove(_ value: Element) {
        root = remove(node: root, value: value)
    }

    private func remove(node: AVLNode<Element>?, value: Element) -> AVLNode<Element>? {
        guard let node = node else {
            return nil
        }
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

        // After 
        let balancedNode = balanced(node)
        balancedNode.height = max(balancedNode.leftHeight, balancedNode.rightHeight) + 1
        return balancedNode
    }
}
