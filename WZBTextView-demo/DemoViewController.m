//
//  DemoViewController.m
//  WZBTextView-demo
//
//  Created by 王振标 on 2017/8/27.
//  Copyright © 2017年 WZB. All rights reserved.
//

#import "DemoViewController.h"
#import "UITextView+WZB.h"
#import <MobileCoreServices/MobileCoreServices.h>

#define kNavigationBarH self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height

@interface DemoViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) UITextView *textView;
@property (nonatomic, assign) NSUInteger type;

@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    switch (self.type) {
        case 0:
            [self test1];
            break;
        case 1:
            [self test2];
            break;
        case 2:
            [self test3];
            break;
            
        default:
            break;
    }
}

- (instancetype)initWithTitle:(NSString *)title type:(NSUInteger)type
{
    if (self = [super init]) {
        self.title = title;
        self.type = type;
    }
    return self;
}

- (void)test1 {
    self.textView.frame = CGRectMake(0, kNavigationBarH, self.view.bounds.size.width, self.view.bounds.size.height - 64);
    // 设置placeholder
    self.textView.wzb_placeholder = @"请输入文字";
//    self.textView.wzb_maxHeight = 100.05;
    // 设置placeholder的颜色
    self.textView.wzb_placeholderColor = [UIColor redColor];
}

- (void)test2 {
    self.textView.frame = (CGRect){0, 0, self.view.bounds.size.width, 30};
    self.textView.center = self.view.center;
    self.textView.wzb_placeholder = @"自动换行改变高度";
    self.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.textView.layer.borderWidth = 1;
    
    // 避免循环引用
    //    __weak typeof (self) weakSelf = self;
    //    __weak typeof (textView) weakTextView = textView;
    
    // 最大高度为100，监听高度改变的block
    [self.textView wzb_autoHeightWithMaxHeight:100 textViewHeightDidChanged:^(CGFloat currentTextViewHeight) {
        //        CGRect frame = weakTextView.frame;
        //        frame.size.height = currentTextViewHeight;
        //        [UIView animateWithDuration:0.2 animations:^{
        //            weakTextView.frame = frame;
        //            weakTextView.center = weakSelf.view.center;
        //        }];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.textView resignFirstResponder];
}

- (void)test3
{
    self.textView.frame = CGRectMake(0, kNavigationBarH, self.view.bounds.size.width, self.view.bounds.size.height - 64);
    self.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.textView.layer.borderWidth = 1;
    self.textView.wzb_placeholder = @"点击右上角按钮添加图片";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加图片" style:UIBarButtonItemStylePlain target:self action:@selector(addImage)];
    self.textView.scrollEnabled = YES;
}

- (void)addImage
{
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary] || [UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        picker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeImage,nil];
        
        picker.delegate = self;
        
        [self presentViewController:picker animated:YES completion:nil];
    } else {
        NSLog(@"设备不支持相册或者图库");
    }
}

// 当得到照片后，调用该方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        UIImage *theImage = nil;
        if ([picker allowsEditing]){
            theImage = [info objectForKey:UIImagePickerControllerEditedImage];
        } else {
            theImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        if (theImage) {
            [self.textView wzb_addImage:theImage];
        }
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (UITextView *)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        [self.view addSubview:_textView];
    }
    return _textView;
}

@end
