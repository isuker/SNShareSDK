//
//  SNShareManger.m
//  SNShareSDK
//
//  Created by libo on 9/18/14.
//  Copyright (c) 2014 sina. All rights reserved.
//

#import "SNShareManager.h"
#import "SNShareHeaders.h"
#import "SNShareResModel.h"

#import "ALToastView.h"

@implementation SNShareManager

static SNShareManager *instance = nil;
+(SNShareManager *)sharedSNShareManager
{
    if (instance == nil) {
        @synchronized(instance){
            if (instance == nil) {
                instance = [[SNShareManager alloc] init];
            }
        }
    }
    return instance;
}

#pragma mark - Init

-(void)shareConditionInit
{
     [self performSelector:@selector(shareInit) withObject:nil afterDelay:0.5];
}

-(void)shareInit
{
    //分享初始化
    [self registerShareConfig];
    [[VDShareManager sharedInstance] registerApp];
    
    [self loadResource];
    [SNShareWindow sharedSNShareWindow];
}

//设置相关的分享appkey等信息
- (void) registerShareConfig
{
    [VDShareAppInfoUtil sharedInstance].weiboAppKey = kWeiboAppKey;
    [VDShareAppInfoUtil sharedInstance].weiboAppSecret = kWeiboAppSecret;
    [VDShareAppInfoUtil sharedInstance].weiboRedirectUrl = kWeiboRedirectURI;
    
    [VDShareAppInfoUtil sharedInstance].weixinAppID = KVDWXAppID;
    [VDShareAppInfoUtil sharedInstance].weixinAppKey = kVDWXAppKey;
    
    [VDShareAppInfoUtil sharedInstance].mobileQQAppID = kVDQQAppID;
    [VDShareAppInfoUtil sharedInstance].mobileQQAppKey = kVDQQAppKey;
}

#pragma mark - data Manager
-(void)loadResource
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"snsres" ofType:@"plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    
    NSMutableArray *res = [[NSMutableArray alloc] init];
    for (NSDictionary *item in array) {
        SNShareResModel *model = [[SNShareResModel alloc] init];
        model.title = [item objectForKey:@"title"];
        model.dest = [SNShareTool getShareDest:[item objectForKey:@"dest"]];
        model.img = [item objectForKey:@"img"];
        [res addObject:model];
    }
    _resourceArray = [NSArray arrayWithArray:res];
}

#pragma mark - share Handle

-(BOOL)handleOpenUrl:(UIApplication *)app url:(NSURL *)url
{
    [[VDShareManager sharedInstance] handleOpenUrl:app url:url];
    return YES;
}

-(void)test
{
    VDShareParam *params = [[VDShareParam alloc] init];
    params.title = @"hello";
    NSString *_desc = @"world";
    if (_desc.length >= 140) {
        params.description = [_desc substringToIndex:138];
    }else {
        params.description = _desc;
    }
    
    params.image = [UIImage imageNamed:@"app.png"];
    //NSData *data = UIImageJPEGRepresentation(params.image, 1.0f);
    
    params.imgUrl = @"http://img0.bdstatic.com/img/image/shouye/mxlyf-9632102318.jpg";
    params.videoID = @"1234";
    params.url = @"http://video.sina.com.cn/app";
    VDShareVideoParam *videoParam = [[VDShareVideoParam alloc] init];
    videoParam.videoUrl = @"http://video.sina.com.cn/app";
    params.videoUrl = videoParam;
    
    NSArray *titleArray = [NSArray arrayWithObjects:@"微博", @"朋友圈",  @"微信好友", @"QQ空间", @"QQ好友", nil];
    NSString *title = [titleArray objectAtIndex:1];
    if ([title isEqualToString:@"微博"]) {
        //[self sinaweiboLoginClicked:btn];
        return;
    }
    
    if ([title isEqualToString:@"微信好友"]) {
        [[VDShareManager sharedInstance] shareToWXWithObject:params delegate:self shareType:eVDWXShareTypeLink messageType:eVDWXMessageTypeMultimedia];
    }
    
    if ([title isEqualToString:@"朋友圈"]) {
        
        [[VDShareManager sharedInstance] shareToWXMomentsWithObject:params delegate:self shareType:eVDWXShareTypeLink messageType:eVDWXMessageTypeMultimedia];
        
    }
    
    if ([title isEqualToString:@"QQ空间"]) {
        
        [[VDShareManager sharedInstance] shareToQzoneWithObject:params delegate:self messageType:eVDQQMessageTypeNews];
    }
    
    if ([title isEqualToString:@"QQ好友"]) {
        
        [[VDShareManager sharedInstance] shareToShouQQWithObject:params delegate:self messageType:eVDQQMessageTypeNews];
    }
    
}

#pragma mark - VDShareManagerDelegate

-(void)onShareResponse2:(VDShareErrCode)errCode {
    
    NSString *msg = [SNShareTool parseResponseCode:errCode];
    [ALToastView toastInView:[UIApplication sharedApplication].keyWindow withText:msg];

}


@end
