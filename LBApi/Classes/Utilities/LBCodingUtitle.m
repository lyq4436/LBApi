//
//  LBCodingUtitle.m
//  LBApi_Example
//
//  Created by 林波 on 2018/10/11.
//  Copyright © 2018年 872472634@qq.com. All rights reserved.
//

#import "LBCodingUtitle.h"

@implementation LBCodingUtitle



#pragma mark - NSDictionary -> Json String
+ (NSString*)dataTOjsonString:(id)object
{
    
    
    
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

#pragma mark - Json String -> NSDictionary
+(NSDictionary*)jsonStringToDictionary:(NSString*)jsonString{
    
    
    if ([LBCodingUtitle safeString:jsonString].length<1) {
        return @{};
    }
    NSError *error;
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        return @{};
    }else{
        return dic;
    }
}





#pragma mark - 判断字符串是否为空
+ (BOOL)isEmptyString:(NSString *)string
{
    if (string == nil || [string isEqual:[NSNull null]] || string.length <= 0 || [string isEqualToString:@""] || [string isEqualToString:@"null"] || [string isEqualToString:@"<null>"]) {
        return YES;
    }
    return NO;
}

#pragma mark - 将nil、NSNull转成空字符串
+ (NSString *)safeString:(NSString *)string
{
    if (string == nil || [string isEqual:[NSNull null]] || string.length <= 0 || [string isEqualToString:@""]) {
        return @"";
    }
    return string;
}

#pragma mark - URL 编码
+(NSString *)URLEncodedString:(NSString *)str
{
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)str,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    return encodedString;
}

#pragma mark - URL 解码
+(NSString *)URLDecodedString:(NSString *)str
{
    NSString *decodedString=(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)str, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
    
}

@end
