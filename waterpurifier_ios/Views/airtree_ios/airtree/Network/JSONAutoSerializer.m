//
//  JSONAutoSerializer.m
//  TestOCRuntimeProgramming
//
//  Created by freeZn on 11-12-13.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "JSONAutoSerializer.h"
#import <Foundation/NSObjCRuntime.h>
#import <objc/runtime.h>
#import "ResultInfo.h"
#import "HTool.h"
//#import "CJSONSerializer.h"

@implementation JSONAutoSerializer
static JSONAutoSerializer *_sharedSerializer = nil;

//判断字典是否有某key
-(BOOL)judgeDicContainKey:(NSMutableDictionary *)dic withKey:(NSString *)key
{
    if(dic)
    {
        NSEnumerator *enumerator = [dic keyEnumerator];
        id m_key;
        
        while ((m_key = [enumerator nextObject])) {
            /* code that uses the returned key */
            if ([[m_key uppercaseString] isEqualToString:[key uppercaseString]]) {
                return YES;
            }
        }
        return NO;
    }else
    {
        return NO;
    }
    
}

-(NSInteger)judgeData:(id)data
{
    if ([data isKindOfClass:[NSString class]] || [data isKindOfClass:[NSNumber class]] || [data isKindOfClass:[NSDictionary class]] || [data isEqual:[NSNull null]] || data == nil) {
        //字符串或者包装类型的数字
        return 1;
    }else if ([data isKindOfClass:[NSArray class]])
    {
        //数组
        BOOL flag = NO;
        for (id object in data) {
           NSInteger tag = [self judgeData:object];
            if (tag == 3) {
                //数组里面包含自定义类
                flag = YES;
                break;
            }
        }
        //包含自定义类的数组返回2，包含简单类型的数组返回1
        return flag ? 2 : 1;
    }else
    {
        //自定义类
        return 3;
    }
    return 0;
}

-(NSMutableArray *)parseObjectArrayToDic:(id)theObject
{
    NSMutableArray *finalArray = [[NSMutableArray alloc] init];
    
    for(id value in theObject)
    {
        if (nil != value) {
            NSMutableDictionary *classDic = [self parseObjectToDic:value];
            [finalArray addObject:classDic];
        }
    }
   
    return finalArray;
}

-(NSMutableDictionary *)parseObjectArrayToDic:(id)theObject withKey:(NSString *)key
{
    NSMutableDictionary *finalDict = [[NSMutableDictionary alloc] initWithCapacity:1];
    NSMutableArray *finalArray = [[NSMutableArray alloc] init];
    
    for(id value in theObject)
    {
        if (nil != value) {
            NSMutableDictionary *classDic = [self parseObjectToDic:value];
            [finalArray addObject:classDic];
        }
    }
    [finalDict setObject:finalArray forKey:key];
    return finalDict;

}

-(NSMutableDictionary *)parseObjectToDic:(id)theObject
{
    if(theObject == nil || [theObject isEqual:[NSNull null]])
    {
        return nil;
    }
    
    NSString *className = NSStringFromClass([theObject class]);
    
    const char *cClassName = [className UTF8String];
    
    id theClass = objc_getClass(cClassName);
    
    unsigned int outCount, i;
    
    objc_property_t *properties = class_copyPropertyList(theClass, &outCount);
    
    NSMutableDictionary *finalDict = [[NSMutableDictionary alloc] initWithCapacity:1];
    
    for (i = 0; i < outCount; i++) {
        
        objc_property_t property = properties[i];
        
        //获取属性名称
        NSString *propertyNameString = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        
        SEL selector = NSSelectorFromString(propertyNameString);
        id value = [theObject performSelector:selector];
    
        if(value == nil || [value isEqual:[NSNull null]])
        {
            [finalDict setObject:[NSNull null] forKey:propertyNameString];
        }else
        {
            switch ([self judgeData:value]) {
                case 1:
                    //如果属性是基本类型
                    [finalDict setObject:value forKey:propertyNameString];
                    break;
                case 2:
                    //如果是数组
                {
                    NSMutableArray *finalArray = [[NSMutableArray alloc] initWithCapacity:1];
                    for(id object in value)
                    {
                        [finalArray addObject:[self parseObjectToDic:object]];
                    }
                    [finalDict setObject:finalArray forKey:propertyNameString];
                }
                    break;
                case 3:
                    //如果是自定义类
                    [finalDict setObject:[self parseObjectToDic:value] forKey:propertyNameString];
                    break;
                default:
                    break;
            }  
 
        }
        
    }
    
    return finalDict;
}

- (NSMutableDictionary *)serializeObject:(NSMutableDictionary *)theObject
{
    NSArray *array = [theObject allKeys];
    for (int i = 0 ; i < [array count]; i++) {
        NSString *keyString = [array objectAtIndex:i];
        //获取key对应的值
        id object = [theObject objectForKey:keyString];
        NSInteger tag = [self judgeData:object];
        if (tag == 3) {
            //是自定义的类
            NSString *key = [[theObject allKeys] objectAtIndex:i];
            [theObject setObject:[self parseObjectToDic:object] forKey:key];
        }else if (tag == 2)
        {
            NSMutableArray *contentArray = (NSMutableArray *)object;
            for(int j = 0; j < [contentArray count]; j++)
            {
                NSMutableDictionary *contentDic = [contentArray objectAtIndex:j];
                [contentArray replaceObjectAtIndex:j withObject:[self parseObjectToDic:contentDic]];
            }
        }
    }
    return theObject;
}

//将字典转成类
-(id)deserializeObject:(NSMutableDictionary *)dicObject withClass:(NSString *)classObject
{
    if (dicObject == nil || [dicObject isEqual:[NSNull null]] || classObject == nil || classObject.length == 0) {
        return nil;
    }
    id instance = [[NSClassFromString(classObject) alloc] init];
    unsigned int outCount = 0;
    // 获取到所有的成员变量列表
    Ivar *vars = class_copyIvarList(NSClassFromString(classObject), &outCount);
    // 遍历所有的成员变量
    for (int i = 0; i < outCount; i++) {
        // 取出第i个位置的成员变量
        Ivar ivar = vars[i];
        // 获取变量名
        const char *propertyName = ivar_getName(ivar);
        // 获取变量编码类型
        const char *propertyType = ivar_getTypeEncoding(ivar);
        
        NSString *propertyString = [[[NSString alloc] initWithUTF8String:propertyName] substringFromIndex:1];
        
        NSString *propertyTypeString = [[NSString alloc] initWithUTF8String:propertyType];
        if (propertyTypeString && propertyTypeString.length > 3) {
           propertyTypeString = [propertyTypeString substringWithRange:NSMakeRange(2, [propertyTypeString length]-3)];
        }
        
        if([self judgeDicContainKey:dicObject withKey:propertyString])
        {
            id value = [dicObject objectForKey:propertyString];
            if (value != nil) {
                if ([value isKindOfClass:[NSNumber class]]) {
                    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
                    if([value compare:[NSNumber numberWithBool:NO]] == NSOrderedSame || [value compare:[NSNumber numberWithBool:YES]] == NSOrderedSame)
                    {
                        //如果是bool型
                      object_setIvar(instance, ivar, value);
                    }else
                    {
                        //NSString *valueString = [numberFormatter stringFromNumber:value];
                        //object_setIvar(instance, ivar, valueString);
                        object_setIvar(instance, ivar, value);
                    }
                }else if ([value isKindOfClass:[NSDictionary class]]) {
                    NSMutableDictionary *valueDic = (NSMutableDictionary *)value;
                    //将对象转成类
                    id valueClass = [self deserializeObject:valueDic withClass:propertyTypeString];
                    if (valueClass != nil) {
                        object_setIvar(instance, ivar, valueClass);
                    }
                }else if ([value isKindOfClass:[NSArray class]]) {
                    NSMutableArray *valueArray = (NSMutableArray *)value;
                    NSMutableArray *classArray = [[NSMutableArray alloc] init];
                    NSString *className = [propertyString substringFromIndex:4];
//                    NSLog(@"打印类名:%@",className);
                    for (id item in valueArray) {
                        if ([item isKindOfClass:[NSDictionary class]]) {
//                            NSString *dicKey = [[item allKeys] objectAtIndex:0];
//                            NSString *firstLetter = [[dicKey substringToIndex:1] uppercaseString];
//                            NSString *afterLetter = [dicKey substringWithRange:NSMakeRange(1, [dicKey length]-1)];
//                            NSString *className = [firstLetter stringByAppendingString:afterLetter];
//                            NSLog(@"打印类名:%@",className);
                            
//                            NSMutableDictionary *dicValue = [[item allValues] objectAtIndex:0];
//                           id itemObject = [self deserializeObject:dicValue withClass:className];
                            id itemObject = [self deserializeObject:item withClass:className];
                            if (itemObject != nil) {
                                [classArray addObject:itemObject];
                            }
                        }else if ([item isKindOfClass:[NSString class]])
                        {
                            [classArray addObject:item];
                        }
                    }
                    if ([classArray count] > 0) {
                        object_setIvar(instance, ivar, classArray);
                    }
                }else if([value isKindOfClass:[NSString class]])
                {
                    NSString *valueString = (NSString *)value;
                    if ([HTool isEmptyObject:valueString]) {
                        
                    }else
                    {
                        object_setIvar(instance, ivar, value);
                    }
                    
                }
            }
            //printf("---属性名：%s-- 属性类型:%s- 值：%s\n", propertyName, propertyType,value);
        }
        
        
    }
//    classObject = nil;
//    dicObject = nil;
    return instance;
}

+ (JSONAutoSerializer *)sharedSerializer
{
    if (_sharedSerializer == nil)
    {
        
        _sharedSerializer = [[JSONAutoSerializer alloc] init];
    
    }
    

    return _sharedSerializer;
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        
        
    
    }

    return self;
}


@end
