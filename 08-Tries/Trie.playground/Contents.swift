// Copyright (c) 2018 Razeware LLC
// For full license & permission details, see LICENSE.markdown.

public class Trie<CollectionType: Collection>  where CollectionType.Element: Hashable {

    // Create a typealias to make typing the type easier down the road
    public typealias Node = TrieNode<CollectionType.Element>

    // Iniitialize the trie w/ a nil root node
    private let root = Node(key: nil, parent: nil)

    public init() {}
}

public class TrieNode<Key: Hashable> {

    // Optional because the root node has no key
    public var key: Key?

    // Holding a reference to the parent helps in remove operations
    public weak var parent: TrieNode?

    // BST's hold only 2 children, because a node can have > 2 children
    // A dictionary is a better option for efficiently storing children
    public var children: [Key: TrieNode] = [:]

    // Lets node know if it is a leaf or not
    public var isTerminating = false

    public init(key: Key?, parent: TrieNode?) {
        self.key = key
        self.parent = parent
    }
}

extension Trie {
    public func insert(_ collection: CollectionType) {
        var current = root

        for element in collection {
            if current.children[element] == nil {
                current.children[element] = Node(key: element, parent: current)
            }

            current = current.children[element]!
        }

        current.isTerminating = true
    }

    public func contains(_ collection: CollectionType) -> Bool {

        var current = root

        for element in collection {
            guard let child = current.children[element] else { return false }

            current = child
        }

        return current.isTerminating
    }

    public func remove(_ collection: CollectionType) {
        var current = root

        for element in collection {
            guard let child = current.children[element] else { return }

            current = child
        }

        guard current.isTerminating else { return }

        while let parent = current.parent,
            current.children.isEmpty && !current.isTerminating {

                parent.children[current.key!] = nil

                current = parent
        }
    }
}

extension Trie where CollectionType: RangeReplaceableCollection {

    func collection(startingWith prefix: CollectionType) -> [CollectionType] {

        var current = root

        for element in prefix {
            guard let child = current.children[element] else { return [] }

            current = child
        }

        return collection(startingWith: prefix, after: current)
    }

    private func collection(startingWith prefix: CollectionType, after node: Node) -> [CollectionType] {

        var results: [CollectionType] = []

        if node.isTerminating { results.append(prefix) }

        for child in node.children.values {
            var prefix = prefix

            prefix.append(child.key!)

            results.append(contentsOf: collection(startingWith: prefix, after: child))
        }

        return results
    }
}
