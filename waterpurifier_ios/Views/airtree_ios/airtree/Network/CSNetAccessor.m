//
//  CSNetAccessor.m
//  太仓团
//
//  Created by zxt on 14-1-9.
//
//
#import "CSNetAccessor.h"
#import "SBJson.h"

@implementation CSNetAccessor

-(id)init
{
    
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (NSString*)UTF8_To_GB2312:(NSString*)urlString
{
    NSString *str = [urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return str;
}

+(ResultInfo *)getNetData:(NSString *)urlStr PostUrl:(NSString *)postURL
{
    NSError *error = nil;
    
    NSURLResponse *theResponse = nil;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *preUrl = [LOCALHOST stringByAppendingString:@"BillAndJobService.asmx/"];
    
    preUrl = [preUrl stringByAppendingString:urlStr];
    // 設置URL
    [request setURL:[NSURL URLWithString:preUrl]];
    // 設置HTTP方法
    [request setHTTPMethod:HTTPPOST];
    
    [request setTimeoutInterval:60.0];
    
    if (postURL && postURL.length > 0) {
        [request setHTTPBody:[postURL dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]];
    }
    
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    // 發送同步請求, 這裡得returnData就是返回得數據楽
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&theResponse error:&error];
    
    if (returnData == nil) {
        return nil;
    }
    NSDictionary *value = [NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingMutableLeaves error:&error];
    
    ResultInfo *info = [HTool changeDicToRespondMessage:value];
    
    return info;
}


@end

