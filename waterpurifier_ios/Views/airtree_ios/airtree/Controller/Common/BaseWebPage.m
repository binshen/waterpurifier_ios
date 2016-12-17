//
//  BaseWebPage.m
//  airtree
//
//  Created by WindShan on 2016/11/15.
//  Copyright © 2016年 Gloria. All rights reserved.
//

#import "BaseWebPage.h"

@interface BaseWebPage ()<WKNavigationDelegate>
{
    MBProgressHUD *HUD;
     NSTimer * netWorkCheckTime;
}
@end

@implementation BaseWebPage

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!_webView)
    {
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-60)];
        _webView.navigationDelegate = self;
//        _webView.dataDetectorTypes = UIDataDetectorTypeAll;
//        _webView.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
    }
    
    [self.view addSubview:_webView];
    
    //[self loadHtml];
}

- (void)dealloc
{
    [_webView stopLoading];
    _webView.navigationDelegate = nil;
}

- (void)loadHtml
{
    
    // 10秒定时器
    netWorkCheckTime = [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(checkNetwork) userInfo:nil repeats:NO];
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"正在加载...";
//    // 隐藏时候从父控件中移除
//    HUD.removeFromSuperViewOnHide = YES;
//    // YES代表需要蒙版效果
//    HUD.dimBackground = YES;
    
    NSURL *url = [[NSURL alloc] initWithString:_urlString];

    //NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    //loadHTMLString
    //[_webView loadHTMLString:_urlString baseURL:nil];
    
    //[_webView loadRequest:request];
}

-(void) checkNetwork
{
    if(HUD != nil)
        HUD.hidden = YES;
    
    [Global alertMessageEx:@"请检查网络是否正常!" title:@"加载失败" okTtitle:nil cancelTitle:@"OK" delegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UIWebViewDelegate methods

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    FxLog(@"webViewDidFinishLoad");
    if(HUD != nil)
        HUD.hidden = YES;
    
    if(netWorkCheckTime)
       [netWorkCheckTime invalidate];
}


- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    FxLog(@"webViewDidStartLoad");
    
}


-(void)webView:(UIWebView*)webView  DidFailLoadWithError:(NSError*)error{
    
    FxLog(@"DidFailLoadWithError");
    if(HUD != nil)
        HUD.hidden = YES;
    
    if(netWorkCheckTime)
        [netWorkCheckTime invalidate];
    
    [Global alertMessage:error.localizedDescription];
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

#pragma mark - WKNavigationDelegate begin

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    if(HUD != nil)
        HUD.hidden = YES;
    
    if(netWorkCheckTime)
        [netWorkCheckTime invalidate];
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    if(HUD != nil)
        HUD.hidden = YES;
    
    if(netWorkCheckTime)
        [netWorkCheckTime invalidate];
    
    [Global alertMessage:navigation.description];
}

// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    
}

//// 在收到响应后，决定是否跳转
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
//    
//    NSLog(@"%@",navigationResponse.response.URL.absoluteString);
//    //允许跳转
//    decisionHandler(WKNavigationResponsePolicyAllow);
//    //不允许跳转
//    //decisionHandler(WKNavigationResponsePolicyCancel);
//}
// 在发送请求之前，决定是否跳转
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
//    
////    NSLog(@"%@",navigationAction.request.URL.absoluteString);
////    //允许跳转
////    decisionHandler(WKNavigationActionPolicyAllow);
//    //不允许跳转
//    //decisionHandler(WKNavigationActionPolicyCancel);
//}
#pragma mark - WKNavigationDelegate end
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
