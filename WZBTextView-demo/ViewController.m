//
//  ViewController.m
//  WZBTextView-demo
//
//  Created by normal on 2016/11/14.
//  Copyright © 2016年 WZB. All rights reserved.
//

#import "ViewController.h"
#import "DemoViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"UITextView-WZB";
    [self.view addSubview:self.tableView];
}

#pragma mark - lazy
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

#pragma mark - UITableViewDelegate&&UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DemoViewController *vc = [[DemoViewController alloc] initWithTitle:self.dataSource[indexPath.row] type:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSArray *)dataSource
{
    return @[@"占位符", @"自动高度", @"添加图片"];
}

@end
