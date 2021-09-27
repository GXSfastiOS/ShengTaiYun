//
//  NSDate+MNHelper.h
//  MNKit
//
//  Created by Vincent on 2018/8/3.
//  Copyright © 2018年 小斯. All rights reserved.
//  日期处理

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, MNDateComponents) {
    MNDateComponentAll = 1 << 0,
    MNDateComponentYear = 1 << 1,
    MNDateComponentMonth = 1 << 2,
    MNDateComponentDay = 1 << 3,
    MNDateComponentHour = 1 << 4,
    MNDateComponentMinute = 1 << 5,
    MNDateComponentSecond = 1 << 6
};

FOUNDATION_EXPORT NSDateFormatter * _Nonnull NSDateFormatterLocal (void);

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (MNHelper)
#pragma mark - 时间戳

/**
 当前时间戳
 @return 数字时间戳(秒)
 */
+ (NSInteger)timestamp;
NSInteger NSDateTimestamp (void);

/**
 当前时间戳
 @return 数字时间戳(毫秒)
 */
+ (long long)shortTimestamp;
long long NSDateShortTimestamp (void);

/**
 当前时间戳
 @return 字符串时间戳(秒)
 */
+ (NSString *)timestamps;
NSString * NSDateTimestamps (void);

/**
 当前时间戳
 @return 字符串时间戳(毫秒)
 */
+ (NSString *)shortTimestamps;
NSString * NSDateLongTimestamps (void);

#pragma mark - 时间字符串
/**
 当前时间字符串
 @return 当前时间字符串
 */
- (NSString *)dateString;

/**
 当前时间字符串
 @return 当前时间日期字符串
 */

- (NSString *)dateDayString;

/**
 当前时间字符串
 @param obj 时间格式<格式化器/字符串/nil则为此时>
 @return 当前时间字符串
 */
- (NSString *)dateStringWithFormat:(id _Nullable)obj;

/**
 时间戳/日期 时间字符串
 @param obj 时间戳/日期 <支持 NSDate, NSString, NSNumber>
 @param format 时间格式器/时间格式 <支持 NSDateFormatter, NSString>
 @return 时间字符串
 */
+ (NSString *)dateStringWithTimestamp:(id)obj format:(id)format;

/**
 时间戳/日期 时间字符串
 @param obj 时间戳/日期 <支持 NSDate, NSString, NSNumber>
 @param options 格式化部件
 @return 时间字符串
 */
+ (NSString *)dateStringWithTimestamp:(id)obj options:(MNDateComponents)options;

/**
 播放时间字符串
 @param obj 播放秒数 <支持 NSString, NSNumber>
 @return 播放时间字符串
 */
+ (NSString *)playTimeStringWithInterval:(id)obj;

/**
 星期
 @return 星期
 */
- (NSString *)weekday;

/**
 获取星期
 @param obj 日期<NSDate, NSString NSNumber时间戳, nil则为此时>
 @return 星期
 */
+ (NSString *)weekdayFromDate:(id)obj;

#pragma mark - 时间比较

/**
 日期与指定日期(或时间戳)的间隔
 @param obj 日期/时间戳 <支持 NSDate, NSString, NSNumber>
 @return 时间间隔
 */
- (NSDateComponents * _Nullable)dateComponentSince:(id)obj;

/**
 当前日期与指定日期(或时间戳)的间隔
 @param obj 日期/时间戳 <支持 NSDate, NSString, NSNumber>
 @return 时间间隔
 */
+ (NSDateComponents *_Nullable)dateComponentSince:(id)obj;

/**
 日期与指定日期(或时间戳)的间隔字符串
 @param obj 日期/时间戳 <支持 NSDate, NSString, NSNumber>
 @param options 格式化类型
 @return 间隔字符串
 */
- (NSString *_Nullable)dateIntervalSince:(id)obj options:(MNDateComponents)options;

/**
 当前日期与指定日期(或时间戳)的间隔字符串
 @param obj 日期/时间戳 <支持 NSDate, NSString, NSNumber>
 @param options 格式化类型
 @return 间隔字符串
 */
+ (NSString *_Nullable)dateIntervalSince:(id)obj options:(MNDateComponents)options;

/**
 指定格式的日期格式化器
 @param options 格式化部件
 @return 时间格式化器
 */
+ (NSDateFormatter *)dateFormatterWithOptions:(MNDateComponents)options;

/**
 @parm date  时间
 @return //例如：农历戊戌（狗）年
 */
+ (NSString *)getChineseCalendarWithDate:(NSDate *)date;

/**
  当前农历日期
 */
+ (NSString *)getChineseCalendar:(NSDate *)date;

@end
NS_ASSUME_NONNULL_END
