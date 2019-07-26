# Tries

Pronounced as try...s. A trie is a data structure for storing data that can be represeneted as a collection, like a word. Characters would map to a node in the trie.

Wikipedia:
In computer science, a trie, also called digital tree, radix tree or prefix tree, is a kind of search tree—an ordered tree data structure used to store a dynamic set or associative array where the keys are usually strings. Unlike a binary search tree, no node in the tree stores the key associated with that node; instead, its position in the tree defines the key with which it is associated. All the descendants of a node have a common prefix of the string associated with that node, and the root is associated with the empty string. Keys tend to be associated with leaves, though some inner nodes may correspond to keys of interest. Hence, keys are not necessarily associated with every node. For the space-optimized presentation of prefix tree, see compact prefix tree.

![Trie](assets/trie.png)

See how in the example nodes are organized around the prefix of the words, making it easier to search through the tree looking for the data. Compare this to an array, where say you have 10k words and you need to find the one that the user is typing for an autocomplete engine. It would be terrible performance to hunt through 10k words matching the current state of the user's input to the all the possible words that start with the current input state. Using an array would be `O(k*n)` where `k` is the longest string in the collection and `n` the number of words in the collection. If you were searching for `Supercalifragilisticexpialidocious` in a 10k long array it would be `O(34,000)` 

![AutoComplete](assets/autocomplete.png)

#### Trie Node

```swift
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
```

#### Trie Structure

```swift
public class Trie<CollectionType: Collection>  where CollectionType.Element: Hashable {

  // Create a typealias to make typing the type easier down the road
  public typealias Node = TrieNode<CollectionType.Element>

  // Iniitialize the trie w/ a nil root node
  private let root = Node(key: nil, parent: nil)

  public init() {}
}
```

### Insert
```swift
/// Complexity `O(k)` where `k` is the length of the collection being inserted
extension Trie {
  public func insert(_ collection: CollectionType) {

    // Tracks traversal progress starting @ root node
    var current = root

    // Iterates over collection's elements
    for element in collection {

      // Checks if the current node already contains
      // the element being inserted
      if current.children[element] == nil {

        // If element does not exist, create a new node and 
        // attach to the parent
        current.children[element] = Node(key: element, parent: current)
      }

      // Move current node to the next node
      current = current.children[element]!
    }

    // Sets `isTerminating` to true to signal end of the collection
    current.isTerminating = true
  }
}
```

### Contains
```swift
extension Trie {
  public func contains(_ collection: CollectionType) -> Bool {

    // Tracks the current node
    var current = root

    for element in collection {
      // Checks if the current value being searched for exists in node's dictionary
      guard let child = current.children[element] else { return false }

      // Sets the next node to the child
      current = child
    }

    // If the current node isTerminating it signals that the string
    // Does exist in the trie
    return current.isTerminating
  }
}
```

### Remove
```swift
extension Trie {
  public func remove(_ collection: CollectionType) {
    // Set current node in iteration cycle to the root
    var current = root

    // Iterate over elements in collection to be removed
    for element in collection {

      // Verifies that the element being removed exists in the trie
      guard let child = current.children[element] else {
        return
      }

      // Sets current node to child node
      current = child
    }

    // Checks if the collection is terminated
    guard current.isTerminating else {
      return
    }

    // Sets isTerminating to false, so next step can remove node
    current.isTerminating = false

    // While the current node has a parent
    while let parent = current.parent,
    // And the current node has children and is not terminating
    current.children.isEmpty && !current.isTerminating {

      // Note: The reason for checking children.isEmpty & !current.isTerminating
      // is that we don't want to remove values that might belong to another
      // Collection in the trie

      // Set the value being removed's children to nil
      parent.children[current.key!] = nil

      // Set the current node to the parent
      current = parent
    }
  }
}
```

#### Remove Example
```swift
example(of: "remove") {
  let trie = Trie<String>()
  trie.insert("cut")
  trie.insert("cute")
  
  print("\n*** Before removing ***")
  assert(trie.contains("cut"))
  print("\"cut\" is in the trie")
  assert(trie.contains("cute"))
  print("\"cute\" is in the trie")
  
  print("\n*** After removing cut ***")
  trie.remove("cut")
  assert(!trie.contains("cut"))
  assert(trie.contains("cute"))
  print("\"cute\" is still in the trie")
}

```

### Prefix Matching
```swift
public extension Trie where CollectionType: RangeReplaceableCollection {
  func collections(startingWith prefix: CollectionType) -> [CollectionType] {

    // Verify trie contains the prefix
    var current = root

    // Iterate over elements in the prefix
    for element in prefix {

      // If the current node's children does not contain the element
      // return empty array
      guard let child = current.children[element] else { return [] }

      // If the current node's children does contain the element
      // Set the current node to the child for the next iteration
      current = child
    }

    return collection(startingWith: prefix, after: current)
  } 

  private func collection(startingWith: prefix: CollectionType, after node: Node) -> [CollectionType] {

    // Instantiate blank collection for results
    var results: [CollectionType] = []

    // If the node isTerminating add it to the results
    if node.isTerminating { results.append(prefix) }

    // Iterate over the children of the node
    for child in node.children.values {

      // Set prefix to a mutable value
      var prefix = prefix

      // Append the child's key to the prefix
      prefix.append(child.key!)

      // Recurse down the chain to the child's value
      results.append(contentsOf: collections(startingWith: prefix, after: child))
    }

    return results
  }

}
```