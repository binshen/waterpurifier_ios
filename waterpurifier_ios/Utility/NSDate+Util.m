//
//  NSDate+Util.m
//  LAEducation
//
//  Created by JiangXiaotao on 14-12-10.
//  Copyright (c) 2014年 13980.com. All rights reserved.
//

#import "NSDate+Util.h"

static const unsigned componentFlags = (NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit);

@implementation NSDate (Util)

+ (NSString *)currentDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter stringFromDate:[NSDate new]];
}

+ (NSString *)currentDate:(NSString *)formatString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatString];
    return [dateFormatter stringFromDate:[NSDate new]];
}

+ (NSDate *)dateFromString:(NSString *)str {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    if (str.length == 10) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
//    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    return [dateFormatter dateFromString:str];
}

- (NSString *)stringWithFormat:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:self];
}

- (NSInteger)getDiffernceInHoursForDate:(NSDate *)date {
    NSTimeInterval distanceBetweenDates = [self timeIntervalSinceDate:date];
    NSInteger hoursBetweenDates = distanceBetweenDates / 3600;
    return hoursBetweenDates;
}

- (NSInteger)getDiffernceInMinutesForDate:(NSDate *)date {
    NSTimeInterval distanceBetweenDates = [self timeIntervalSinceDate:date];
    NSInteger hoursBetweenDates = distanceBetweenDates / 60;
    return hoursBetweenDates;
}

- (NSInteger)getDiffernceInSecondsForDate:(NSDate *)date {
    NSTimeInterval distanceBetweenDates = [self timeIntervalSinceDate:date];
    NSInteger hoursBetweenDates = distanceBetweenDates / 1;
    return hoursBetweenDates;
}

- (NSDate *)dateByAddingDays:(int)numberOfDays {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = numberOfDays;
    return [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:self options:0];
}

- (NSDate*)dateByAddingMonths:(int)numberOfMonths {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = numberOfMonths;
    return [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)dateByAddingHours:(int)numberOfHours {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.hour = numberOfHours;
    return [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)dateByAddingMinutes:(int)numberOfMinutes {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.minute = numberOfMinutes;
    return [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)dateByAddingSeconds:(int)numberOfSeconds {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.second = numberOfSeconds;
    return [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:self options:0];
}


- (BOOL)isBeforeDate:(NSDate *)date {
    return [self compare:date] == NSOrderedAscending;
}

- (BOOL)isAfterDate:(NSDate *)date {
    return [self compare:date] == NSOrderedDescending;
}

- (BOOL)isToday {
    return [self isEqualToDateIgnoringTime:[NSDate date]];
}

- (BOOL)isYesterday {
    return [self isEqualToDateIgnoringTime:[NSDate dateWithTimeIntervalSinceNow:(-24 * 3600)]];
}

- (BOOL)isTomorrow {
    return [self isEqualToDateIgnoringTime:[NSDate dateWithTimeIntervalSinceNow:(24 * 3600)]];
}

- (BOOL)isEqualToDateIgnoringTime:(NSDate *)date {
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:componentFlags fromDate:self];
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:componentFlags fromDate:date];
    return (components1.year == components2.year && components1.month == components2.month && components1.day == components2.day);
}

@end
