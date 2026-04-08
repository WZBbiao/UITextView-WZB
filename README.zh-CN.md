# UITextView-WZB

[English README](./README.md)

一个更现代的 Swift 版 `UITextView` 组件，主要解决三个高频需求：

- 占位符
- 自动增高
- 文本内插图

它保持 UIKit 原生使用方式，不强行引入额外层级，适合聊天输入框、评论框、发布框这类场景。

## 功能特性

- Swift 实现
- 原生 UIKit 接入
- 支持 Swift Package Manager
- 支持 CocoaPods
- 自带 Demo 工程
- 带核心行为单元测试

## 效果

### 占位符

![Placeholder](./gif/UITextView-WZB-gif1.gif)

### 自动高度

![Auto Height](./gif/UITextView-WZB-gif2.gif)

### 插入图片

![Inline Images](./gif/UITextView-WZB-gif3.gif)

## 环境要求

- iOS 11.0+
- Swift 5
- 建议使用 Xcode 15+

## 安装

### Swift Package Manager

```swift
.package(url: "https://github.com/WZBbiao/UITextView-WZB.git", from: "2.0.1")
```

然后在 target 里添加 `WZBTextView` 依赖。

### CocoaPods

```ruby
pod "UITextView-WZB", "~> 2.0"
```

## 快速使用

```swift
import UIKit
import WZBTextView

final class ComposerViewController: UIViewController {
    private let textView = WZBTextView()
    private var heightConstraint: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.placeholder = "请输入内容..."
        textView.minHeight = 44
        textView.font = .systemFont(ofSize: 17)

        view.addSubview(textView)

        heightConstraint = textView.heightAnchor.constraint(equalToConstant: 44)
        heightConstraint?.isActive = true

        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])

        textView.autoHeight(maxHeight: 140) { [weak self] height in
            self?.heightConstraint?.constant = height
        }
    }
}
```

## API

### 属性

```swift
public var placeholder: String
public var placeholderColor: UIColor
public var minHeight: CGFloat
public var maxHeight: CGFloat
public var onHeightChange: ((CGFloat) -> Void)?
```

### 方法

```swift
public func autoHeight(maxHeight: CGFloat, onHeightChange: ((CGFloat) -> Void)? = nil)
public func images() -> [UIImage]
public func addImage(_ image: UIImage)
public func addImage(_ image: UIImage, size: CGSize)
public func insertImage(_ image: UIImage, size: CGSize, index: Int)
public func addImage(_ image: UIImage, multiple: CGFloat)
public func insertImage(_ image: UIImage, multiple: CGFloat, index: Int)
```

## Demo 内容

Demo 里现在包含：

- 占位符示例
- 居中自动增高输入框示例
- 文本内插图示例

## 目录结构

```text
Sources/WZBTextView/           组件源码
WZBTextView-demo/             Demo 工程
WZBTextView-demoTests/        单元测试
```

## 版本说明

`2.x` 是 Swift 重写版本。

如果你之前使用的是旧的 Objective-C 版，请把 `2.0.0` 视为迁移版本，而 `2.0.1` 是 Swift 重写后的首个补丁版本。

## License

项目使用 MIT 协议，详见 [LICENSE](./LICENSE)。
