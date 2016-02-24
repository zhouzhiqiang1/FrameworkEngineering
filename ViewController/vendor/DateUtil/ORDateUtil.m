//
//  ORDateUtil.m
//  ORead
//
//  Created by noname on 14-9-2.
//  Copyright (c) 2014年 oread. All rights reserved.
//

#import "ORDateUtil.h"
#import "NSString+MD5Addition.h"

@implementation ORDateUtil

+(NSString *)formatDateForMessageCellWithTimeInterval:(long long)aTimeInterval
{
    NSString *dateString = nil;
    
    time_t intervalInSecond = aTimeInterval / 1000.f;
    time_t ltime;
    time(&ltime);
    
    struct tm today;
    localtime_r(&ltime, &today);
    struct tm nowdate;
    localtime_r(&intervalInSecond, &nowdate);
    struct tm yesterday;
    localtime_r(&ltime, &yesterday);
    yesterday.tm_mday -= 1;
    struct tm theDayBeforeYesterday;
    localtime_r(&ltime, &theDayBeforeYesterday);
    theDayBeforeYesterday.tm_mday -= 2;
    
	if(today.tm_year == nowdate.tm_year && today.tm_mday == nowdate.tm_mday && today.tm_mon == nowdate.tm_mon)//今天
	{
        char s[100];
        strftime(s,sizeof(s),"%R", &nowdate);
        dateString = [NSString stringWithCString:s encoding:NSUTF8StringEncoding];
	}
	else if((yesterday.tm_year == nowdate.tm_year && yesterday.tm_mon == nowdate.tm_mon && yesterday.tm_mday  == nowdate.tm_mday))//昨天
	{
        char s[100];
        strftime(s,sizeof(s),"昨天 %R", &nowdate);
        dateString = [NSString stringWithCString:s encoding:NSUTF8StringEncoding];
	}else if((theDayBeforeYesterday.tm_year == nowdate.tm_year && theDayBeforeYesterday.tm_mon == nowdate.tm_mon && theDayBeforeYesterday.tm_mday  == nowdate.tm_mday))//前天
	{
        char s[100];
        strftime(s,sizeof(s),"前天 %R", &nowdate);
        dateString = [NSString stringWithCString:s encoding:NSUTF8StringEncoding];
	}
	else if(today.tm_year == nowdate.tm_year)//今年内
	{
        char s[100];
        strftime(s,sizeof(s),"%m月%d日 %R", &nowdate);
        dateString = [NSString stringWithCString:s encoding:NSUTF8StringEncoding];
	}
	else//其他年份
	{
        char s[100];
        strftime(s,sizeof(s),"%y年%m月%d日 %R", &nowdate);
        dateString = [NSString stringWithCString:s encoding:NSUTF8StringEncoding];
	}
    
    return dateString;
}

+ (NSString *)formatedDateForBirthdayWithTimeInterval:(long long)aTimeInterval
{
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [formater stringFromDate:[NSDate dateWithTimeIntervalSince1970:aTimeInterval]];
    return dateString;
}

+(NSString *)uniqueStringFromDate
{
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
    NSString *dateString = [formater stringFromDate:[NSDate date]];
    NSString *resultString = [dateString stringFromMD5];
    return resultString;
}
@end
