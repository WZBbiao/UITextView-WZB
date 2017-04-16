//
//  ViewController.m
//  WZBTextView-demo
//
//  Created by normal on 2016/11/14.
//  Copyright © 2016年 WZB. All rights reserved.
//

#import "ViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface ViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, strong) UITextView *tView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test1];
}

- (void)test1 {
    self.textView.hidden = NO;
    self.textView.placeholder = @"i love you";
    self.textView.maxHeight = 100.05;
    self.textView.placeholderColor = [UIColor redColor];
    
}

- (void)test2 {
    self.textView.hidden = YES;
    
    UITextView *textView = [[UITextView alloc] initWithFrame:(CGRect){0, 0, 200, 30}];
    [self.view addSubview:textView];
    textView.center = self.view.center;
    textView.placeholder = @"i love you";
    textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    textView.layer.borderWidth = 1;
    
    // 避免循环引用
//    __weak typeof (self) weakSelf = self;
//    __weak typeof (textView) weakTextView = textView;
    
    // 最大高度为100，监听高度改变的block
    [textView autoHeightWithMaxHeight:100 textViewHeightDidChanged:^(CGFloat currentTextViewHeight) {
//        CGRect frame = weakTextView.frame;
//        frame.size.height = currentTextViewHeight;
//        [UIView animateWithDuration:0.2 animations:^{
//            weakTextView.frame = frame;
//            weakTextView.center = weakSelf.view.center;
//        }];
    }];
    self.tView = textView;
    UIButton *button = [[UIButton alloc] initWithFrame:(CGRect){20, 30, 100, 25}];
    [self.view addSubview:button];
    [button setTitle:@"添加图片" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(addImage) forControlEvents:UIControlEventTouchUpInside];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.textView resignFirstResponder];
}

- (void)addImage {
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
            [self.tView addImage:theImage];
        }
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
