//
//  HTool.h
//  XiaoNiuIOS
//


#import "HTool.h"

#define STANDARDIMAGE 500

@implementation HTool

+(ResultInfo *)changeDicToRespondMessage:(NSMutableDictionary *)dic
{

    ResultInfo *info = [[ResultInfo alloc] init];
    
    if ([[dic allKeys] containsObject:@"state"]) {
        info.state = [[dic objectForKey:@"state"] intValue];
    }else
    {
        info.state = -1;
    }
    
    info.message = [dic objectForKey:@"message"];
    info.obj = [dic objectForKey:@"obj"];
    
    return info;
}

+ (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}



+(UIColor *)bgViewWhite
{
    return [self colorWithHexString:@"#f2f2f2"];
}

+(CGSize)caculateContentWidth:(NSString *)content contentFont:(UIFont *)font contentHeight:(float)height
{
    //    CGSize contentSize = [content sizeWithFont:font constrainedToSize:CGSizeMake(MAXFLOAT, height) lineBreakMode:NSLineBreakByWordWrapping];
    
    if (!content || content.length == 0) {
        return CGSizeMake(0, 0);
    }
    
    NSDictionary *attribute = @{NSFontAttributeName: font};
    
    CGSize contentSize = [content boundingRectWithSize:CGSizeMake(MAXFLOAT, height)  options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    return contentSize;
}

+(CGSize)caculateContentHeight:(NSString *)content contentFont:(UIFont *)font contentWidth:(float)width
{
    //    CGSize contentSize = [content sizeWithFont:font constrainedToSize:CGSizeMake(MAXFLOAT, height) lineBreakMode:NSLineBreakByWordWrapping];
    
    NSDictionary *attribute = @{NSFontAttributeName: font};
    
    CGSize contentSize = [content boundingRectWithSize:CGSizeMake(width, MAXFLOAT)  options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    return contentSize;
}

+(BOOL)isEmptyObject:(id)object
{
    if (object == nil || object == NULL) {
        return YES;
    }
    if ([object isKindOfClass:[NSNull class]]) {
        return YES;
    }
    return NO;
}

+(BOOL)isEmptyString:(NSString *)string
{
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

+(NSString *)convertString:(NSString *)string
{
    if ([self isEmptyString:string]) {
        return @"";
    }else
    {
        return string;
    }
}

//将浮点型后面无效的0去掉
+(NSString *)changeFloat:(NSString *)stringFloat
{
    if (stringFloat.length == 0) {
        return @"0";
    }else if ([stringFloat rangeOfString:@"."].location == NSNotFound)
    {
        return stringFloat;
    }
    const char *floatChars = [stringFloat UTF8String];
    NSUInteger length = [stringFloat length];
    NSUInteger zeroLength = 0;
    int i = length-1;
    for(; i>=0; i--)
    {
        if(floatChars[i] == '0'/*0x30*/) {
            zeroLength++;
        } else {
            if(floatChars[i] == '.')
                i--;
            break;
        }
    }
    NSString *returnString;
    if(i == -1) {
        returnString = @"0";
    } else {
        returnString = [stringFloat substringToIndex:i+1];
    }
    return returnString;
}

//将整型传字符串
+(NSString *)convertIntToString:(NSInteger)intValue
{
    return [NSString stringWithFormat:@"%ld",intValue];
}

+(void)tipAlertViewWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

+(BOOL)validateItem:(ValidateItem)item withString:(NSString *)itemName
{
    if (nil == itemName || itemName.length == 0) {
        return NO;
    }
    switch (item) {
        case VALIDATEMOBILE:
        {
            /**
             * 手机号码
             * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
             * 联通：130,131,132,152,155,156,185,186
             * 电信：133,1349,153,180,189
             */
            NSString * MOBILE = @"^1(3[0-9]|4[0-9]|5([0-3]|[5-9])|7[0-9]|8[0-9])\\d{8}$";
            NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
            return [regextestmobile evaluateWithObject:itemName];
        }
            break;
        case VALIDATEPASSWORD:
        {
            //密码格式：数字加字母
            NSString *regex = @"[a-z0-9A-Z]+";
            NSPredicate *regexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
            return [regexTest evaluateWithObject:itemName];
        }
            break;
        default:
            break;
    }
    return NO;
}

//判断字典是否有某key
+(BOOL)judgeDicContainKey:(NSMutableDictionary *)dic withKey:(NSString *)key
{
    NSEnumerator *enumerator = [dic keyEnumerator];
    id m_key;
    
    while ((m_key = [enumerator nextObject])) {
        /* code that uses the returned key */
        if ([m_key isEqualToString:key]) {
            return YES;
        }
    }
    return NO;
}

+(NSString *)convertBoolToString:(BOOL)boolValue
{
    return boolValue ? @"1" : @"0";
}

+(BOOL)convertStringToBool:(NSString *)stringValue
{
    if ([stringValue isEqualToString:@"T"]) {
        return YES;
    }
    return NO;
}

/* 设置上传图片的大小 **/
+ (UIImage *)scaleToSize:(UIImage *)img
{
    if (img == nil) {
        return nil;
    }
    // 图片比例
    CGFloat realPer = 1.0;
    if (img.size.width > STANDARDIMAGE) { // 宽度大于屏幕的宽度
        realPer = STANDARDIMAGE / img.size.width;
    }else if (img.size.height > STANDARDIMAGE) { // 宽度高于屏幕的高度
        realPer = STANDARDIMAGE / img.size.width;
    }else{// 原比例
        realPer = 1.0;
    }
    
    // 固定图片的宽度
    CGFloat realWidth = img.size.width * realPer;
    // 等比缩放图片的高度
    CGFloat realHeight = img.size.height * realPer;
    // 获取图片新的尺寸
    CGSize E = CGSizeMake(realWidth, realHeight);
    // 创建context
    UIGraphicsBeginImageContext(E);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0,0, E.width, E.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;
}

+(NSString *)addZeroToString:(NSInteger)compt
{
    if (compt <= 9) {
        return [NSString stringWithFormat:@"0%ld",compt];
    }
    return [NSString stringWithFormat:@"%ld",compt];
}

//显示年月日时间
+(NSString *)showYMDFromServerTime:(NSString *)serverTime
{
    if ([HTool isEmptyString:serverTime]) {
        return @"";
    }
    NSString *str = @"";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *destDate = [dateFormatter dateFromString:serverTime];
    
    NSDateFormatter *myFormatter = [[NSDateFormatter alloc] init];
    [myFormatter setDateFormat: @"yyyy-MM-dd"];
    str = [myFormatter stringFromDate:destDate];
    
    return str;
}

//显示年月日 时分时间
+(NSString *)showYMDHMFromServerTime:(NSString *)serverTime
{
    NSString *str = @"";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *destDate = [dateFormatter dateFromString:serverTime];
    
    NSDateFormatter *myFormatter = [[NSDateFormatter alloc] init];
    [myFormatter setDateFormat: @"yyyy-MM-dd HH:mm"];
    str = [myFormatter stringFromDate:destDate];
    
    return [HTool convertString:str];
}

//显示年月日 时分秒时间
+(NSString *)showYMDHMSFromServerTime:(NSString *)serverTime
{
    NSString *str = @"";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *destDate = [dateFormatter dateFromString:serverTime];
    
    NSDateFormatter *myFormatter = [[NSDateFormatter alloc] init];
    [myFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    str = [myFormatter stringFromDate:destDate];
    
    return [HTool convertString:str];
}

//时间
+(NSMutableDictionary *)goodsSourceMianTimeFromServerTime:(NSString *)serverTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *destDate = [dateFormatter dateFromString:serverTime];
    
    NSMutableDictionary *timeDic = [[NSMutableDictionary alloc] init];
    if ([destDate isToday]) {
        [timeDic setObject:@"今天" forKey:@"YMD"];
    }else if ([destDate isYesterday])
    {
        [timeDic setObject:@"昨天" forKey:@"YMD"];
    }else
    {
        NSString *dayString = [serverTime substringWithRange:NSMakeRange(5, 5)];
        [timeDic setObject:[self convertString:dayString] forKey:@"YMD"];
    }
    
    NSString *timeString = [serverTime substringWithRange:NSMakeRange(11, 5)];
    [timeDic setObject:[self convertString:timeString] forKey:@"HMS"];
    
    return timeDic;
}

+(NSString *)timeFormater:(NSString *)shortTime
{
    if (shortTime.length > 0) {
        shortTime = [shortTime stringByAppendingString:@":00"];
        return shortTime;
    }
    return @"";
}

+(NSString *)timeFormater2:(NSString *)serverTime
{
    if (![HTool isEmptyString:serverTime]) {
        if (serverTime.length > 0) {
            serverTime = [serverTime substringWithRange:NSMakeRange(0, serverTime.length-6)];
            if(serverTime.length > 0)
            {
                serverTime = [serverTime stringByAppendingString:@"时"];
            }
            return serverTime;
        }
    }
    return @"";
}

//计算两个时间之间的差
+(long)caculateDifferBetweenTime:(NSString *)startTime andEndTime:(NSString *)endTime
{
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *d1=[date dateFromString:startTime];
    
    NSTimeInterval late1=[d1 timeIntervalSince1970]*1;
    
    NSDate *d2=[date dateFromString:endTime];
    
    NSTimeInterval late2=[d2 timeIntervalSince1970]*1;
    
    return late2 - late1;
}

//获取当前时间戳
+(NSString *)getCurrentTimestamp
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a = [dat timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%f", a];
    return timeString;
}

//获取当前时间
+(NSString *)getCurrentTimeString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}

+(NSString*)strmethodComma:(NSString*)string
{
    NSString *sign = nil;
    if ([string hasPrefix:@"-"]||[string hasPrefix:@"+"]) {
        sign = [string substringToIndex:1];
        string = [string substringFromIndex:1];
    }
    
    NSString *pointLast = [string substringFromIndex:[string length]-3];
    NSString *pointFront = [string substringToIndex:[string length]-3];
    
    int commaNum = ([pointFront length]-1)/3;
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < commaNum+1; i++) {
        int index = [pointFront length] - (i+1)*3;
        int leng = 3;
        if(index < 0)
        {
            leng = 3+index;
            index = 0;
            
        }
        NSRange range = {index,leng};
        NSString *stq = [pointFront substringWithRange:range];
        [arr addObject:stq];
    }
    NSMutableArray *arr2 = [NSMutableArray array];
    for (int i = [arr count]-1; i>=0; i--) {
        
        [arr2 addObject:arr[i]];
    }
    NSString *commaString = [[arr2 componentsJoinedByString:@","] stringByAppendingString:pointLast];
    if (sign) {
        commaString = [sign stringByAppendingString:commaString];
    }
    return commaString;
}

//手机号码
+(NSString *)showMobileWithPartNumber:(NSString *)phone
{
    if (phone.length == 11) {
        phone = [phone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    }
    return phone;
}

//根据url生成图片
+ (UIImage *) loadWebImageWithURL:(NSString *)url
{
    if ([HTool isEmptyString:url]) {
        return nil;
    }
    UIImage* image=nil;
    NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    if(data!=nil)
    {
        image = [[UIImage alloc] initWithData:data];
    }
    return image;
}

+(void)callOut:(NSString *)phoneNumber
{
    if (phoneNumber.length > 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneNumber]]];
    }
}
//图文详情拼接字符串
+(NSString *)stringBystring:(NSString *)bodyHTML
{
    NSString *detailString = [@"<html><head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, user-scalable=no\"><style>img{max-width:100%; width:auto; height:auto;}</style></head><body>" stringByAppendingString: bodyHTML];
    detailString = [detailString stringByAppendingString: @"</body></html>"];
    return detailString;
}

@end
