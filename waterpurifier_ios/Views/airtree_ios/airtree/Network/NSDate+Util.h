//
//  NSDate+Util.h
//  LAEducation
//
//  Created by JiangXiaotao on 14-12-10.
//  Copyright (c) 2014年 13980.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Util)

/**
 * string of currentDate
 * DateFormat:"yyyy-MM-dd HH:mm:ss"
 */
+ (NSString *)currentDate;

/**
 * string of currentDate
 */
+ (NSString *)currentDate:(NSString *)formatString;

/**
 * date of string
 * DateFormat:"yyyy-MM-dd HH:mm:ss" or "yyyy-MM-dd"
 */
+ (NSDate *)dateFromString:(NSString *)str;

/**
 * string with date format
 */
- (NSString *)stringWithFormat:(NSString *)format;

/**
 * date by adding days
 */
- (NSDate *)dateByAddingDays:(int)numberOfDays;

/**
 * date by adding months
 */
- (NSDate*)dateByAddingMonths:(int)numberOfMonths;

/**
 * date by adding hours
 */
- (NSDate *)dateByAddingHours:(int)numberOfHours;

/**
 * date by adding minutes
 */
- (NSDate *)dateByAddingMinutes:(int)numberOfMinutes;

/**
 * date by adding minutes
 */
- (NSDate *)dateByAddingSeconds:(int)numberOfSeconds;

- (BOOL)isBeforeDate:(NSDate *)date;

- (BOOL)isAfterDate:(NSDate *)date;

- (BOOL)isToday;

- (BOOL)isYesterday;

- (BOOL)isTomorrow;

- (BOOL)isEqualToDateIgnoringTime:(NSDate *)date;

@end
