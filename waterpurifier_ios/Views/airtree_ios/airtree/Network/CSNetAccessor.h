//
//  CSNetAccessor.h
//  太仓团
//
//  Created by zxt on 14-1-9.
//
//

#import <Foundation/Foundation.h>
#import "ResultInfo.h"
#import "HTool.h"

@interface CSNetAccessor : NSObject

+ (NSString*)UTF8_To_GB2312:(NSString*)urlString;

+(ResultInfo *)getNetData:(NSString *)urlStr PostUrl:(NSString *)postURL;
@end
