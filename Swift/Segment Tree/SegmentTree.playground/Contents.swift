//: Playground - noun: a place where people can play

public class SegmentTree<T> {

  private var value: T
  private var function: (T, T) -> T
  private var leftBound: Int
  private var rightBound: Int
  private var leftChild: SegmentTree<T>?
  private var rightChild: SegmentTree<T>?

  public init(array: [T], leftBound: Int, rightBound: Int, function: (T, T) -> T) {
    self.leftBound = leftBound
    self.rightBound = rightBound
    self.function = function

    if leftBound == rightBound {
      value = array[leftBound]
    } else {
      let middle = (leftBound + rightBound) / 2
      leftChild = SegmentTree<T>(array: array, leftBound: leftBound, rightBound: middle, function: function)
      rightChild = SegmentTree<T>(array: array, leftBound: middle+1, rightBound: rightBound, function: function)
      value = function(leftChild!.value, rightChild!.value)
    }
  }

  public convenience init(array: [T], function: (T, T) -> T) {
    self.init(array: array, leftBound: 0, rightBound: array.count-1, function: function)
  }

  public func queryWithLeftBound(leftBound: Int, rightBound: Int) -> T {
    if self.leftBound == leftBound && self.rightBound == rightBound {
      return self.value
    }

    guard let leftChild = leftChild else { fatalError("leftChild should not be nil") }
    guard let rightChild = rightChild else { fatalError("rightChild should not be nil") }

    if leftChild.rightBound < leftBound {
      return rightChild.queryWithLeftBound(leftBound, rightBound: rightBound)
    } else if rightChild.leftBound > rightBound {
      return leftChild.queryWithLeftBound(leftBound, rightBound: rightBound)
    } else {
      let leftResult = leftChild.queryWithLeftBound(leftBound, rightBound: leftChild.rightBound)
      let rightResult = rightChild.queryWithLeftBound(rightChild.leftBound, rightBound: rightBound)
      return function(leftResult, rightResult)
    }
  }

  public func replaceItemAtIndex(index: Int, withItem item: T) {
    if leftBound == rightBound {
      value = item
    } else if let leftChild = leftChild, rightChild = rightChild {
      if leftChild.rightBound >= index {
        leftChild.replaceItemAtIndex(index, withItem: item)
      } else {
        rightChild.replaceItemAtIndex(index, withItem: item)
      }
      value = function(leftChild.value, rightChild.value)
    }
  }
}




let array = [1, 2, 3, 4]

let sumSegmentTree = SegmentTree(array: array, function: +)

print(sumSegmentTree.queryWithLeftBound(0, rightBound: 3)) // 1 + 2 + 3 + 4 = 10
print(sumSegmentTree.queryWithLeftBound(1, rightBound: 2)) // 2 + 3 = 5
print(sumSegmentTree.queryWithLeftBound(0, rightBound: 0)) // 1 = 1

sumSegmentTree.replaceItemAtIndex(0, withItem: 2) //our array now is [2, 2, 3, 4]

print(sumSegmentTree.queryWithLeftBound(0, rightBound: 0)) // 2 = 2
print(sumSegmentTree.queryWithLeftBound(0, rightBound: 1)) // 2 + 2 = 4


//you can use any associative function (i.e (a+b)+c == a+(b+c)) as function for segment tree
func gcd(m: Int, _ n: Int) -> Int {
  var a = 0
  var b = max(m, n)
  var r = min(m, n)

  while r != 0 {
    a = b
    b = r
    r = a % b
  }
  return b
}

let gcdArray = [2, 4, 6, 3, 5]

let gcdSegmentTree = SegmentTree(array: gcdArray, function: gcd)

print(gcdSegmentTree.queryWithLeftBound(0, rightBound: 1)) // gcd(2, 4) = 2
print(gcdSegmentTree.queryWithLeftBound(2, rightBound: 3)) // gcd(6, 3) = 3
print(gcdSegmentTree.queryWithLeftBound(1, rightBound: 3)) // gcd(4, 6, 3) = 1
print(gcdSegmentTree.queryWithLeftBound(0, rightBound: 4)) // gcd(2, 4, 6, 3, 5) = 1

gcdSegmentTree.replaceItemAtIndex(3, withItem: 10) //gcdArray now is [2, 4, 6, 10, 5]

print(gcdSegmentTree.queryWithLeftBound(3, rightBound: 4)) // gcd(10, 5) = 5


//example of segment tree which finds minimum on given range
let minArray = [2, 4, 1, 5, 3]

let minSegmentTree = SegmentTree(array: minArray, function: min)

print(minSegmentTree.queryWithLeftBound(0, rightBound: 4)) // min(2, 4, 1, 5, 3) = 1
print(minSegmentTree.queryWithLeftBound(0, rightBound: 1)) // min(2, 4) = 2

minSegmentTree.replaceItemAtIndex(2, withItem: 10) // minArray now is [2, 4, 10, 5, 3]

print(minSegmentTree.queryWithLeftBound(0, rightBound: 4)) // min(2, 4, 10, 5, 3) = 2


//type of elements in array can be any type which has some associative function
let stringArray = ["a", "b", "c", "A", "B", "C"]

let stringSegmentTree = SegmentTree(array: stringArray, function: +)

print(stringSegmentTree.queryWithLeftBound(0, rightBound: 1)) // "a"+"b" = "ab"
print(stringSegmentTree.queryWithLeftBound(2, rightBound: 3)) // "c"+"A" = "cA"
print(stringSegmentTree.queryWithLeftBound(1, rightBound: 3)) // "b"+"c"+"A" = "bcA"
print(stringSegmentTree.queryWithLeftBound(0, rightBound: 5)) // "a"+"b"+"c"+"A"+"B"+"C" = "abcABC"

stringSegmentTree.replaceItemAtIndex(0, withItem: "I")
stringSegmentTree.replaceItemAtIndex(1, withItem: " like")
stringSegmentTree.replaceItemAtIndex(2, withItem: " algorithms")
stringSegmentTree.replaceItemAtIndex(3, withItem: " and")
stringSegmentTree.replaceItemAtIndex(4, withItem: " swift")
stringSegmentTree.replaceItemAtIndex(5, withItem: "!")

print(stringSegmentTree.queryWithLeftBound(0, rightBound: 5))
