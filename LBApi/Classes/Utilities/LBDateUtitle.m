//
//  LBDateUtitle.m
//  LBApi_Example
//
//  Created by 林波 on 2018/10/11.
//  Copyright © 2018年 872472634@qq.com. All rights reserved.
//

#import "LBDateUtitle.h"

@implementation LBDateUtitle


/*************************   时间戳   **************************************************************/

#pragma mark - 获取当前时间戳 （以毫秒为单位）
+(NSString *)getNowTimeTimestamp3{
    
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time=[date timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;
}


#pragma mark - 获取当前时间戳
+(NSTimeInterval )getNowTimeTimestamp{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time=[date timeIntervalSince1970];
    return time;
}


#pragma mark - 获取当前时间戳不保留小数位
+(NSString *)getNowTimeTimestampWithString{
    
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time=[date timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;
}


#pragma mark - 获取当前时间戳保留小数位
+(NSString *)getNowTimeTimestampWithPreciseString{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time=[date timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;
}



/********************************** 时间  ******************************************/

#pragma mark - 获取当前时间 (需要传入类型)
+(NSString *)getNowTimeWithType:(NSString*)type{
    
    NSDate *date = [NSDate date];
    NSDateFormatter *forMatter = [[NSDateFormatter alloc] init];
    [forMatter setDateFormat:type];
    NSString *dateStr = [forMatter stringFromDate:date];
    return dateStr;
    
}

#pragma mark - 获取当前时间 2018-10-11 14:44:34
+(NSString *)getNowTimeWithyyyyMMddHHmmss{
    return [LBDateUtitle getNowTimeWithType:@"yyyy-MM-dd HH:mm:ss"];
}

#pragma mark - 获取当前时间 2018-10-11
+(NSString *)getNowTimeWithyyyyMMdd{
    return [LBDateUtitle getNowTimeWithType:@"yyyy-MM-dd"];
}

#pragma mark - 获取当前时间 2018-10
+(NSString *)getNowTimeWithyyyyMM{
    return [LBDateUtitle getNowTimeWithType:@"yyyy-MM"];
}

#pragma mark - 获取当前时间 2018
+(NSString *)getNowTimeWithyyyy{
    return [LBDateUtitle getNowTimeWithType:@"yyyy"];
}



@end
