//
//  ViewController.m
//  S2icode_iPad_ios
//
//  Created by zzc_copy on 16/9/29.
//  Copyright © 2016年 zzc_copy. All rights reserved.
//

#import "ViewController.h"
#import <RestKit/RestKit.h>
@interface ViewController ()
 
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(200, 300, 200, 100);
    button.backgroundColor = [UIColor greenColor];
    [button addTarget:self action:@selector(updataClick) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"上传数据" forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
}
- (void)updataClick{
    NSLog(@"上传数据进行编码");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
