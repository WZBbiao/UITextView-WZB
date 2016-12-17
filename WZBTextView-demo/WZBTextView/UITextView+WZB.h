//
//  UITextView+WZB.h
//  WZBTextView-demo
//
//  Created by normal on 2016/11/14.
//  Copyright © 2016年 WZB. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^textViewHeightDidChangedBlock)(CGFloat currentTextViewHeight);

@interface UITextView (WZB)

/* 占位文字 */
@property (nonatomic, copy) NSString *placeholder;

/* 占位文字颜色 */
@property (nonatomic, strong) UIColor *placeholderColor;

/* 最大高度，如果需要随文字改变高度的时候使用 */
@property (nonatomic, assign) CGFloat maxHeight;
@property (nonatomic, copy) textViewHeightDidChangedBlock textViewHeightDidChanged;
/* 自动高度的方法，maxHeight：最大高度， textHeightDidChanged：高度改变的时候调用 */
- (void)autoHeightWithMaxHeight:(CGFloat)maxHeight textViewHeightDidChanged:(textViewHeightDidChangedBlock)textViewHeightDidChanged;
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

@end
