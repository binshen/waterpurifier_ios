//
//  BaseWebPage.h
//  airtree
//
//  Created by WindShan on 2016/11/15.
//  Copyright © 2016年 Gloria. All rights reserved.
//

#import "BaseNavPage.h"
#import <WebKit/WebKit.h>

@interface BaseWebPage : BaseNavPage
{
    WKWebView  *_webView;
}

@property(nonatomic, strong) NSString   *urlString;

- (void)loadHtml;

@end
