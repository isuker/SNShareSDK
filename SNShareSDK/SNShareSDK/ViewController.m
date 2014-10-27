//
//  ViewController.m
//  SNShareSDK
//
//  Created by libo on 9/18/14.
//  Copyright (c) 2014 sina. All rights reserved.
//

#import "ViewController.h"
#import "SNShareHeaders.h"

@interface ViewController ()<SNShareDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn setTitle:@"Test" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    btn.frame = CGRectMake(100, 200, 80, 50);
    [btn addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
    
    [self SNShareDataSource];
    
}

-(void)test
{
    SNShareShow(self)
}

#pragma mark - SNShareDelegate
-(SNShareModel *)SNShareDataSource
{
    NSError *error = [SNShareTool checkDataModel:nil];
    NSLog(@"%@",[error localizedDescription]);
    return nil;
    
}

-(void)SNShareResponse:(VDShareErrCode)errCode Msg:(NSString *)msg
{
    
}

@end
