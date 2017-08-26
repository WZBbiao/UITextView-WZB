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
@property (nonatomic, copy) NSString *wzb_placeholder;
@property (nonatomic, copy) NSString *placeholder NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, "请使用wzb_placeholder");

/* 占位文字颜色 */
@property (nonatomic, strong) UIColor *wzb_placeholderColor;
@property (nonatomic, strong) UIColor *placeholderColor NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, "请使用wzb_placeholderColor");

/* 最大高度，如果需要随文字改变高度的时候使用 */
@property (nonatomic, assign) CGFloat wzb_maxHeight;
@property (nonatomic, assign) CGFloat maxHeight NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, "请使用wzb_maxHeight");

/* 最小高度，如果需要随文字改变高度的时候使用 */
@property (nonatomic, assign) CGFloat wzb_minHeight;
@property (nonatomic, assign) CGFloat minHeight NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, "请使用wzb_minHeight");

@property (nonatomic, copy) textViewHeightDidChangedBlock wzb_textViewHeightDidChanged;
@property (nonatomic, copy) textViewHeightDidChangedBlock textViewHeightDidChanged NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, "请使用wzb_textViewHeightDidChanged");

/* 获取图片数组 */
- (NSArray *)wzb_getImages;
- (NSArray *)getImages NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, "请使用wzb_getImages");

/* 自动高度的方法，maxHeight：最大高度 */
- (void)wzb_autoHeightWithMaxHeight:(CGFloat)maxHeight;
- (void)autoHeightWithMaxHeight:(CGFloat)maxHeight NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, "请使用wzb_autoHeightWithMaxHeight:");

/* 自动高度的方法，maxHeight：最大高度， textHeightDidChanged：高度改变的时候调用 */
- (void)wzb_autoHeightWithMaxHeight:(CGFloat)maxHeight textViewHeightDidChanged:(textViewHeightDidChangedBlock)textViewHeightDidChanged;
- (void)autoHeightWithMaxHeight:(CGFloat)maxHeight textViewHeightDidChanged:(textViewHeightDidChangedBlock)textViewHeightDidChanged NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, "请使用autoHeightWithMaxHeight:textViewHeightDidChanged:");

/* 添加一张图片 image:要添加的图片 */
- (void)wzb_addImage:(UIImage *)image;
- (void)addImage:(UIImage *)image NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, "请使用wzb_addImage:");

/* 添加一张图片 image:要添加的图片 size:图片大小 */
- (void)wzb_addImage:(UIImage *)image size:(CGSize)size;
- (void)addImage:(UIImage *)image size:(CGSize)size  NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, "请使用wzb_addImage:size:");

/* 插入一张图片 image:要添加的图片 size:图片大小 index:插入的位置 */
- (void)wzb_insertImage:(UIImage *)image size:(CGSize)size index:(NSInteger)index;
- (void)insertImage:(UIImage *)image size:(CGSize)size index:(NSInteger)index NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, "请使用insertImage:size:index:");

/* 添加一张图片 image:要添加的图片 multiple:放大／缩小的倍数 */
- (void)wzb_addImage:(UIImage *)image multiple:(CGFloat)multiple;
- (void)addImage:(UIImage *)image multiple:(CGFloat)multiple NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, "请使用wzb_addImage:multiple:");

/* 插入一张图片 image:要添加的图片 multiple:放大／缩小的倍数 index:插入的位置 */
- (void)wzb_insertImage:(UIImage *)image multiple:(CGFloat)multiple index:(NSInteger)index;
- (void)insertImage:(UIImage *)image multiple:(CGFloat)multiple index:(NSInteger)index NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, "请使用wzb_insertImage:multiple:index:");

@end
