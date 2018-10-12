//
//  ONLYOUCheckInfo.h
//  OnlyouCombine
//
//  Created by 林波 on 2018/9/5.
//  Copyright © 2018年 onlyou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBCheckPrivilegeInfo : NSObject



#pragma mark - 提示框

/**
 alertController简单封装
 @param title title
 @param message message
 @param cancle 取消按钮的名称
 @param actions 传入多个actions
 @param preferredStyle 类型
 @param viewController 显示在哪个controller
 */
+(void)showAlertControllerTitle:(NSString*)title message:(NSString*)message cancle:(NSString*)cancle actions:(NSMutableArray*)actions preferredStyle:(UIAlertControllerStyle)preferredStyle viewController:(UIViewController*)viewController;


/**
 检查相机权限
 @param viewController 显示在哪个controller
 @return YES(通过)  NO(不通过)
 */
+(BOOL)checkCameraPrivacyViewController:(UIViewController*)viewController;




/**
 检查相册权限
 @param viewController 显示在哪个controller
 @return YES(通过)  NO(不通过)
 */
+ (BOOL)checkPhotoLibraryPrivacyViewController:(UIViewController*)viewController;


@end
