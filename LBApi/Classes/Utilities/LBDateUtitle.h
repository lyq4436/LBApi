//
//  LBDateUtitle.h
//  LBApi_Example
//
//  Created by 林波 on 2018/10/11.
//  Copyright © 2018年 872472634@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBDateUtitle : NSObject


/*************************   时间戳   **************************************************************/

#pragma mark - 时间戳

/**
 获取当前时间戳精确到毫秒
 @return
 */
+(NSString *)getNowTimeTimestamp3;


/**
 获取当前时间戳
 @return
 */
+(NSTimeInterval )getNowTimeTimestamp;

/**
 获取当前时间戳不保留小数位
 @return
 */
+(NSString *)getNowTimeTimestampWithString;

/**
 获取当前时间戳保留小数位
 @return
 */
+(NSString *)getNowTimeTimestampWithPreciseString;





/*************************   时间    **************************************************************/

#pragma mark - 时间
/**
 获取当前时间
 @param type 传入格式（例如: yyyy-MM-dd HH:mm:ss）
 @return 字符串
 */
+(NSString *)getNowTimeWithType:(NSString*)type;



/************************* 以下是比较常用到的  **************************************************************/

/**
 获取当前时间 （如果需要其它格式请使用 getNowTimeWithType 这个方法）
 @return 2018-10-11 14:44:34
 */
+(NSString *)getNowTimeWithyyyyMMddHHmmss;

/**
 获取当前时间 （如果需要其它格式请使用 getNowTimeWithType 这个方法）
 @return 2018-10-11
 */
+(NSString *)getNowTimeWithyyyyMMdd;

/**
 获取当前时间 （如果需要其它格式请使用 getNowTimeWithType 这个方法）
 @return 2018-10
 */
+(NSString *)getNowTimeWithyyyyMM;

/**
 获取当前时间 （如果需要其它格式请使用 getNowTimeWithType 这个方法）
 @return 2018
 */
+(NSString *)getNowTimeWithyyyy;

@end
