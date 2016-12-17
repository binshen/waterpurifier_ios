//
//  JSONAutoSerializer.h
//  TestOCRuntimeProgramming
//
//  Created by freeZn on 11-12-13.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBJson.h"

@interface JSONAutoSerializer : NSObject

+ (JSONAutoSerializer *)sharedSerializer;
-(NSMutableArray *)parseObjectArrayToDic:(id)theObject;
-(NSMutableDictionary *)parseObjectToDic:(id)theObject;
-(NSMutableDictionary *)parseObjectArrayToDic:(id)theObject withKey:(NSString *)key;
- (NSMutableDictionary *)serializeObject:(NSMutableDictionary *)theObject;
-(id)deserializeObject:(NSMutableDictionary *)dicObject withClass:(NSString *)classObject;
@end
