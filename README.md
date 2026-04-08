# UITextView-WZB

`UITextView-WZB` 现在改为 Swift 版本，实现三个核心能力：

- `placeholder`
- 自动高度增长
- 在文本流里插入图片附件

## Preview

Demo 工程保留了三个示例页面：

- 占位符
- 自动高度输入框
- 添加图片

## Installation

### Swift Package Manager

```swift
.package(url: "https://github.com/WZBbiao/UITextView-WZB.git", from: "2.0.0")
```

然后在 target 里依赖 `WZBTextView`。

### CocoaPods

```ruby
pod "UITextView-WZB", "~> 2.0"
```

## Usage

```swift
import UIKit
import WZBTextView

let textView = WZBTextView()
textView.placeholder = "请输入内容"
textView.placeholderColor = .systemRed
textView.minHeight = 44
textView.autoHeight(maxHeight: 140) { height in
    print("current height:", height)
}
```

### Insert Image

```swift
textView.addImage(image)
textView.addImage(image, size: CGSize(width: 120, height: 80))
textView.insertImage(image, multiple: 0.4, index: 0)
let images = textView.images()
```

## API

```swift
open class WZBTextView: UITextView {
    public var placeholder: String
    public var placeholderColor: UIColor
    public var minHeight: CGFloat
    public var maxHeight: CGFloat
    public var onHeightChange: ((CGFloat) -> Void)?

    public func autoHeight(maxHeight: CGFloat, onHeightChange: ((CGFloat) -> Void)?)
    public func images() -> [UIImage]
    public func addImage(_ image: UIImage)
    public func addImage(_ image: UIImage, size: CGSize)
    public func insertImage(_ image: UIImage, size: CGSize, index: Int)
    public func addImage(_ image: UIImage, multiple: CGFloat)
    public func insertImage(_ image: UIImage, multiple: CGFloat, index: Int)
}
```

## Notes

- Demo 工程入口已经切到 Swift。
- 发布源码位于 `Sources/WZBTextView/WZBTextView.swift`。
- 旧的 Objective-C demo 和 category 已从当前实现链路中移除。
