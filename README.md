# UITextView-WZB
一个强大的UITextView分类，三大功能，让系统TextView自带placeholder属性、自动高度、支持输入图片

#### 一、效果:
***
##### 1、让系统TextView自带placeholder属性

![image](https://github.com/WZBbiao/UITextView-WZB/blob/master/gif/UITextView-WZB-gif1.gif?raw=true)

##### 2、自动改变高度，类似聊天输入框

![image](https://github.com/WZBbiao/UITextView-WZB/blob/master/gif/UITextView-WZB-gif2.gif?raw=true)

##### 3、支持输入图片

![image](https://github.com/WZBbiao/UITextView-WZB/blob/master/gif/UITextView-WZB-gif3.gif?raw=true)


 #### 二、使用方法
 ***
#####  1、手动添加

直接将UITextView+WZB.h和UITextView+WZB.m拖入工程


#####  2、CocoaPods添加

在你的podfile文件中添加
> pod 'UITextView-WZB'

然后执行
> pod install


*只需要在需要使用的地方直接导入头文件UITextView+WZB.h，你的UITextView就拥有了这三大功能*

```
// 直接设置placeholder属性即可
    textView.placeholder = @"i love you";
    [self.view addSubview:textView];
    
```

>如果想要计算高度，只需要调用这个方法即可，你需要在block回调里手动更改textView的高度

```

/* 自动高度的方法，maxHeight：最大高度， textHeightDidChanged：高度改变的时候调用 */
- (void)autoHeightWithMaxHeight:(CGFloat)maxHeight textViewHeightDidChanged:(textViewHeightDidChangedBlock)textViewHeightDidChanged;

```


#####  插入图片的方法如下：

```

/* 添加一张图片 image:要添加的图片 */
- (void)addImage:(UIImage *)image;
/* 添加一张图片 image:要添加的图片 size:图片大小 */
- (void)addImage:(UIImage *)image size:(CGSize)size;
/* 插入一张图片 image:要添加的图片 size:图片大小 index:插入的位置 */
- (void)insertImage:(UIImage *)image size:(CGSize)size index:(NSInteger)index;

/* 添加一张图片 image:要添加的图片 multiple:放大／缩小的倍数 */
- (void)addImage:(UIImage *)image multiple:(CGFloat)multiple;
/* 插入一张图片 image:要添加的图片 multiple:放大／缩小的倍数 index:插入的位置 */
- (void)insertImage:(UIImage *)image multiple:(CGFloat)multiple index:(NSInteger)index;

```

 #### 三、实现大致原理：
***
#####  1、使用runtime为textView添加如下属性

```

// 占位文字
static const void *WZBPlaceholderViewKey = &WZBPlaceholderViewKey;
// 占位文字颜色
static const void *WZBPlaceholderColorKey = &WZBPlaceholderColorKey;
// 最大高度
static const void *WZBTextViewMaxHeightKey = &WZBTextViewMaxHeightKey;
// 高度变化的block
static const void *WZBTextViewHeightDidChangedBlockKey = &WZBTextViewHeightDidChangedBlockKey;
// 动态添加属性的本质是: 让对象的某个属性与值产生关联
objc_setAssociatedObject(self, WZBPlaceholderViewKey, placeholderView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
objc_setAssociatedObject(self, WZBTextViewMaxHeightKey, [NSString stringWithFormat:@"%lf", maxHeight], OBJC_ASSOCIATION_COPY_NONATOMIC);
objc_setAssociatedObject(self, WZBTextViewHeightDidChangedBlockKey, textViewHeightDidChanged, OBJC_ASSOCIATION_COPY_NONATOMIC);
objc_setAssociatedObject(self, WZBPlaceholderColorKey, placeholderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

```

#####  2、监听

```

    // 监听文字改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextChange) name:UITextViewTextDidChangeNotification object:self];
    // 这些属性改变时，都要作出一定的改变，尽管已经监听了TextDidChange的通知，也要监听text属性，因为通知监听不到setText：
    NSArray *propertys = @[@"frame", @"bounds", @"font", @"text", @"textAlignment", @"textContainerInset"];
    // 监听属性
    for (NSString *property in propertys) {
       [self addObserver:self forKeyPath:property options:NSKeyValueObservingOptionNew context:nil];
    }
    
```

#####  3、当文字发生变化的时候

```

- (void)textViewTextChange {
    self.placeholderView.hidden = (self.attributedText.length > 0 && self.attributedText);
    if (self.maxHeight >= self.bounds.size.height) {
        // 计算高度
        NSInteger currentHeight = ceil([self sizeThatFits:CGSizeMake(self.bounds.size.width, MAXFLOAT)].height);
        NSInteger lastheight = ceil(self.maxHeight + self.textContainerInset.top + self.textContainerInset.bottom);
        // 如果高度有变化，调用block
        if (currentHeight != lastheight) {
            
            self.scrollEnabled = currentHeight >= self.maxHeight;
            if (self.textViewHeightDidChanged) {
                self.textViewHeightDidChanged((currentHeight >= self.maxHeight ? self.maxHeight : currentHeight));
            }
        }
    }
}

```

#####  4、添加图片是用的NSTextAttachment

```

- (void)addImage:(UIImage *)image size:(CGSize)size index:(NSInteger)index multiple:(CGFloat)multiple {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = image;
    CGRect bounds = textAttachment.bounds;
    if (!CGSizeEqualToSize(size, CGSizeZero)) {
        bounds.size = size;
        textAttachment.bounds = bounds;
    } else if (multiple > 0.0f) {
        textAttachment.image = [UIImage imageWithCGImage:textAttachment.image.CGImage scale:multiple orientation:UIImageOrientationUp];
    } else {
        CGFloat oldWidth = textAttachment.image.size.width;
        CGFloat scaleFactor = oldWidth / (self.frame.size.width - 10);
        textAttachment.image = [UIImage imageWithCGImage:textAttachment.image.CGImage scale:scaleFactor orientation:UIImageOrientationUp];
    }
    
    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
    [attributedString replaceCharactersInRange:NSMakeRange(index, 0) withAttributedString:attrStringWithImage];
    self.attributedText = attributedString;
    // 记得走下这两个方法
    [self textViewTextChange];
    [self refreshPlaceholderView];
}

```

请不要吝惜，随手点个star吧！您的支持是我最大的动力😊！
 此系列文章持续更新，您可以关注我以便及时查看我的最新文章或者您还可以加入我们的群，大家庭期待您的加入！
 
![我们的社区](https://raw.githubusercontent.com/WZBbiao/WZBSwitch/master/IMG_1850.JPG)
