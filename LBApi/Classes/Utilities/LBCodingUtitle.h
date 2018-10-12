//
//  LBCodingUtitle.h
//  LBApi_Example
//
//  Created by 林波 on 2018/10/11.
//  Copyright © 2018年 872472634@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBCodingUtitle : NSObject


/**
 字典转json
 @param object 字典
 @return json字符串
 */
+ (NSString*)dataTOjsonString:(id)object;




/**
 json 转字典
 @param jsonString json字符串
 @return 字典
 */
+(NSDictionary*)jsonStringToDictionary:(NSString*)jsonString;




/**
 判断字符串是否为空

 @param string 字符串
 @return YES(空)  NO(不为空)
 */
+ (BOOL)isEmptyString:(NSString *)string;



/**
 将nil、NSNull转成空字符串
 @param string 字符串
 @return @""
 */
+ (NSString *)safeString:(NSString *)string;



/**
 url 编码
 @param str
 @return
 */
+ (NSString *)URLEncodedString:(NSString *)str;


/**
 URL 解码
 @param str
 @return
 */
+ (NSString *)URLDecodedString:(NSString *)str;



@end
