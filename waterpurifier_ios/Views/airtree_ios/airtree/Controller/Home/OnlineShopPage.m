//
//  OnlineShopPage.m
//  airtree
//
//  Created by WindShan on 2016/11/15.
//  Copyright © 2016年 Gloria. All rights reserved.
//

#import "OnlineShopPage.h"
#import "MBProgressHUD.h"

@interface OnlineShopPage ()

@end

@implementation OnlineShopPage



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"在线商城";
    [self setNavigationLeft:@"返回" sel:@selector(backAction)];
    
    [self getUserToken];
}

-(void)getUserToken
{
//    {"success":true,"user":{"token":"5aab2778597f865405047e40e3b9720b1b5dfac76f4356e098241d977e2f55fb","_id":"57b4117ecd5f86740fe26cb1","username":"15950198162","password":"21218cca77804d2ba1922c33e0151105","nickname":"15950198162","__v":0}7692171.1998705856.i1"]];
//    [self setUrlString:[NSString stringWithUTF8String:"http://moral.tmall.com"]];
//    [self loadHtml];
//    return;
    
    NSString *path = [[NSString alloc] initWithFormat:@"/user/%@/refresh_token",[UserDefault stringForKey:@"user_id"]];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    
    MKNetworkHost *host = [[MKNetworkHost alloc] initWithHostName:MORAL_API_BASE_PATH];
    MKNetworkRequest *request = [host requestWithPath:path params:param httpMethod:HTTPPOST];
    [request addCompletionHandler: ^(MKNetworkRequest *completedRequest) {
        NSError *error = [completedRequest error];
        NSData *data = [completedRequest responseData];
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        NSString *success = [json objectForKey:@"success"];
        //FxLog(@"Success: %@", success);
        if(success != nil && [success boolValue])
        {
            NSDictionary *user = [json objectForKey:@"user"];
            NSString *token = [user objectForKey:@"token"];
            NSString *_id = [user objectForKey:@"_id"];
            
            NSString * pathUrl = [NSString stringWithFormat:Moral_Shop_Url,_id,token,self.alarmType];
            BASE_INFO_FUN(pathUrl);
            [self setUrlString:pathUrl];
            [self loadHtml];
        }
        else
        {
            NSString* errorTips = [json objectForKey:@"error"] == nil?@"获取数据异常":[json objectForKey:@"error"];
            [Global alertMessageEx:errorTips title:@"错误信息" okTtitle:nil cancelTitle:@"OK" delegate:self];
        }
    }];
    
    [host startRequest:request];
}

-(void) backAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
