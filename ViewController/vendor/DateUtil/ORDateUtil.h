//
//  ORDateUtil.h
//  ORead
//
//  Created by noname on 14-9-2.
//  Copyright (c) 2014年 oread. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ORDateUtil : NSObject


/**
 *  格式化时间 聊天消息显示用
 1 当天的显示：小时和分钟，24小时制，如 15:23
 2 昨天的显示：昨天 时间（24小时制）, 如:昨天 15:23
 3 前天的显示：前天 时间（24小时制）, 如:前天 15:23
 4 本年内，且是3天前的显示：X月X日 时间，如：3月1日 15:23
 5 非本年内的，且是3天前的显示：XXXX年X月X日 时间，如：2012年3月1日 15:23
 *
 *  @param aTimeInterval 时间戳 13位 毫秒
 *
 *  @return 格式化之后的字符串
 */
+ (NSString *)formatDateForMessageCellWithTimeInterval:(long long)aTimeInterval;

/**
 *  根据当前日期生成随机字符串
 *
 *  @return 返回生产的随机字符串
 */
+ (NSString *)uniqueStringFromDate;

+ (NSString *)formatedDateForBirthdayWithTimeInterval:(long long)aTimeInterval;
@end
