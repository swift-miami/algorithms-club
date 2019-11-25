# Merge Sort

Last month we covered `O(n^2)` sorting algorithms. While they do the job, they're not known for their efficiency. To start off our faster algorithms, we'll start with Merge Sort. Merge sort is a general purpose algorithm that uses a divide and conquer strategy to sort faster than other algorithms. Also, for reference it's an algorithm that relies on comaprison sorting.

### Divide & Conquer
```swift
let arr = [10, 2, 3, 20, 77, 292, 6, 42]

// First lets split in half

let arr1 = [10, 2, 3, 20]
let arr2 = [77, 292, 6, 42]

// Then again
let arr1 = [10, 2]
let arr2 = [3, 20]
let arr3 = [77, 292]
let arr4 = [6, 42]

// See how at this point sorting becomes much simpler?
// We sort the small arrays
// We take arr1 & arr2 and merge them and sort the merged values
// Then do it again and again until we're done
```

```swift
import Foundation

public func mergeSort<Element>(_ array: [Element]) -> [Element] where Element: Comparable {
  
    // If you have 1 element you're done
    guard array.count > 1 else { return array }
    
    // Get middle'ish index (it will round down on odd #'s)
    let middle = array.count / 2
    
    // 0 index to middle - 1
    print("LeftSplit: ", Array(array[..<middle]))
    let left = mergeSort(Array(array[..<middle]))
    
    // Middle to end index
    print("RightSplit: ", Array(array[middle...]))
    let right = mergeSort(Array(array[middle...]))
    
    print("Left: \(left)", "<-->", "Right: \(right)")
    return merge(left, right)
}

private func merge<Element>(_ left: [Element], _ right: [Element]) -> [Element] where Element: Comparable {
    var leftIndex = 0
    var rightIndex = 0
    
    var result: [Element] = []
    
    // Iterate while w/in bounds of left & right
    while leftIndex < left.count && rightIndex < right.count {
        let leftElement = left[leftIndex]
        let rightElement = right[rightIndex]
        
        // If left is less than right add it to the results
        if leftElement < rightElement {
            
            // Add it to the results
            result.append(leftElement)
            
            // Up the index count by 1
            leftIndex += 1
            
            // if the right element is less than the left
        } else if leftElement > rightElement {
            
            // Append it to the results
            result.append(rightElement)
            
            // Advance the index
            rightIndex += 1
        } else {
            // The 2 elements are equal
            // add them to the results array
            // and advance the index
            result.append(leftElement)
            leftIndex += 1
            
            result.append(rightElement)
            rightIndex += 1
        }
    }
    
    // Because the above loop runs until left or right is empty we know
    // Both arrays are sorted (any leftover elements are greater or equal
    // to any in the result array
    if leftIndex < left.count {
        result.append(contentsOf: left[leftIndex...])
    }
    
    if rightIndex < right.count {
        result.append(contentsOf: right[rightIndex...])
    }
    
    return result
}
```