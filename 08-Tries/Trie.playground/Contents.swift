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
