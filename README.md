# **CircularWordsCloud**

<p align="left">
<img src="https://img.shields.io/badge/platform-iOS-blue.svg?style=flat" alt="Platform iOS" />
<a href="https://cocoapods.org/pods/CircularWordsCloud"><img src="https://img.shields.io/cocoapods/v/CircularWordsCloud.svg?style=flat" alt="Carthage compatible" /></a>
<a href="https://cocoapods.org/pods/CircularWordsCloud"><img src="http://img.shields.io/badge/license-MIT-blue.svg?style=flat" alt="License: MIT" />
</a>    
</p>

Circular Words Cloud with N-Words Selector ( + M-Depth Searching)

Made with Team SISISI by [k-elon](https://github.com/minsub0922).

Circular Words Cloud for iOS !

**CircularWordsCloud** is a *Container View* that allows us to implement word map easily. You can use it for presenting **Word Relationships** or **TItle-Subtitles Architecture** (like Tree).



<table>
   <tr>
     <th align="center">
       <img width="200" alt="1" src="https://user-images.githubusercontent.com/9532432/72524690-c8edac00-38a5-11ea-9cb9-96874a0a7b25.gif"/>
    </th>
     <th align="center">
      <img width="200" alt="1" src="https://user-images.githubusercontent.com/9532432/72530222-415a6a00-38b2-11ea-8723-daa30bc880c3.gif"/>
    </th>
     <th align="center">
      <img width="200" alt="1" src="https://user-images.githubusercontent.com/9532432/72524778-fd616800-38a5-11ea-9fae-1baa74f4b7f1.gif"/>
    </th>
  </tr>
</table>





## CircularWordsCloud Types



### n-words  selecting type

<table>
   <tr>
     <th align="center">
       <img width="200" alt="1" src="https://user-images.githubusercontent.com/9532432/72524354-11589a00-38a5-11ea-957b-d0a793e9952b.gif"/>
       <br><br>[nWords = 3]
     </th>
     <th align="center">
       <img width="200" alt="1" src="https://user-images.githubusercontent.com/9532432/72524685-c68b5200-38a5-11ea-8861-ad7f36465fcd.gif"/>
       <br><br>[nWords = 6] 
    </th>
     <th align="center">
      <img width="200" alt="1" src="https://user-images.githubusercontent.com/9532432/72531106-22f56e00-38b4-11ea-8a0b-436fbe42b285.gif"/>
       <br><br>[nWords = 8]
    </th>
     <th align="center">
      <img width="200" alt="1" src="https://user-images.githubusercontent.com/9532432/72524690-c8edac00-38a5-11ea-9cb9-96874a0a7b25.gif"/>
       <br><br>[nWords = 11]
    </th>
  </tr>
</table>



### m-depth searching type

<img width="200" alt="1" src="https://user-images.githubusercontent.com/9532432/72524778-fd616800-38a5-11ea-9fae-1baa74f4b7f1.gif"/>



### position types

<table>
   <tr>
     <th align="center">
       <img width="200" alt="1" src="https://user-images.githubusercontent.com/9532432/72524553-7f9d5c80-38a5-11ea-81f8-f3c00fdde7ff.gif"/>
       <br><br>[position = bottom]
     </th>
     <th align="center">
       <img width="200" alt="1" src="https://user-images.githubusercontent.com/9532432/72524745-e6227a80-38a5-11ea-9013-c2fd4eefd9e4.gif"/>
       <br><br>[position = center]
    </th>
     <th align="center">
      <img width="200" alt="1" src="https://user-images.githubusercontent.com/9532432/72524649-af4c6480-38a5-11ea-9817-8ee711377263.gif"/>
       <br><br>[position = top]
    </th>
  </tr>
</table>



## Usage

Basically, we just need to add CircularWordsCloud as subview of your view which will be superview of it. And you should set *delegate* of it. 

The size of the view and the autolayouts are set automatically. Ofcourse you can custom if you want!


Let's see the steps to do this:

##### 

#### Set CircularWordsCloud 

```swift
override func viewDidLoad() {
    super.viewDidLoad()

  let circularWordsCloud = CircularWordsCloud()
  circularWordsCloud.delegate = self
  view.addSubview(circularWordsCloud)
}
```

Isn't it really simple ?! Now you can use CircularWordsCloud if you meet a few things.

```swift
extension ViewController: CircularWorsCloudDelegate {
    var wordForAxis: String {
        return "CenterWord"
    }
    
    var wordsForCloud: [String] {
        return ["Words","That","You","Want","Show","Around", "The", "Central Word"]
    }
}
```

What you need to do. s really over.



### Options

You can do some customization with the support of CircularWordsCloud.

#### Select Position

```swift
public enum CircularWordsCloudPosition {
    case top, bottom, center
}

let circularWordsCloud = CircularWordsCloud(position: .top)    // default = .center
```

#### M-Depth Seaching Process

```swift
circularWordsCloud.enableLongPressGesture = true
```

You can press and hold a word to use the feature to move to the new word cloud. Like below.

<img width="200" alt="1" src="https://user-images.githubusercontent.com/9532432/72524778-fd616800-38a5-11ea-9fae-1baa74f4b7f1.gif"/>

#### Give Weight on Words

```swift
extension ViewController: CircularWorsCloudDelegate {
    var ranksForWords: [Int] {
        return [1,7,5,2,6,2,7,3]
    }
}    
```

You can give weight on your words. Then the size changes to match the weight assigned to each word.

<img width="200" alt="1" src="https://user-images.githubusercontent.com/9532432/72530222-415a6a00-38b2-11ea-8723-daa30bc880c3.gif"/>

#### Event Listeners

```swift
@objc public protocol CircularWorsCloudDelegate: NSObjectProtocol {
    // MARK:- Functions
    @objc optional func circularWordsCloud(_ circularWordsCloud: CircularWordsCloud,
                                           didSelectWord: String)
    
    @objc optional func circularWordsCloud(_ circularWordsCloud: CircularWordsCloud,
                                           didDeselectWord: String)
    
    @objc optional func circularWordsCloudDidExpand()
    
    @objc optional func circularWordsCloudDidCollapse()
    
    @objc optional func circularWordsCloud(_ circularWordsCloud: CircularWordsCloud,
                                           newAxisWord: String,
                                           depth: Int,
                                           completion: @escaping ( _ newCloudWords: [String])-> Void)
}
```

You can handle various events in CircularWordsCloud.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

- Xcode 10+
- Swift4+

## Installation

CircularWordsCloud is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'CircularWordsCloud'
```

## Author

minsub0922, minsub0922@naver.com

## License

CircularWordsCloud is available under the MIT license. See the LICENSE file for more info.
