//
//  ONLYOUCheckInfo.m
//  OnlyouCombine
//
//  Created by 林波 on 2018/9/5.
//  Copyright © 2018年 onlyou. All rights reserved.
//

#import "LBCheckPrivilegeInfo.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>

@implementation LBCheckPrivilegeInfo


+(void)showAlertControllerTitle:(NSString*)title message:(NSString*)message cancle:(NSString*)cancle actions:(NSMutableArray*)actions preferredStyle:(UIAlertControllerStyle)preferredStyle viewController:(UIViewController*)viewController{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
        __weak typeof(alert) weakAlert = alert;
        UIAlertAction *action = [UIAlertAction actionWithTitle:cancle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [weakAlert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:action];
        for (UIAlertAction *action11 in actions) {
            [alert addAction:action11];
        }
        [viewController presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 检查权限
+(BOOL)checkCameraPrivacyViewController:(UIViewController*)viewController
{
    NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        NSString *errorStr = @"相机访问权限受限,请在设置中启用";
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:errorStr preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"暂不使用" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           
        }];
        UIAlertAction *goToSetteingAction = [UIAlertAction actionWithTitle:@"前往设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [LBCheckPrivilegeInfo pushToSystemSetting];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:goToSetteingAction];
        [viewController presentViewController:alertController animated:YES completion:nil];
        return NO;
    }
    
    return YES;
    
}

#pragma mark - 检查相册权限
+ (BOOL)checkPhotoLibraryPrivacyViewController:(UIViewController*)viewController
{

    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if(author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied){
        //无权限
        NSString *errorStr = @"相册访问权限受限,请在设置中启用";
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:errorStr preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"暂不使用" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *goToSetteingAction = [UIAlertAction actionWithTitle:@"前往设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [LBCheckPrivilegeInfo pushToSystemSetting];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:goToSetteingAction];
        [viewController presentViewController:alertController animated:YES completion:nil];
        return NO;
    }
    
    return YES;
}

//跳转到设置界面
+ (void)pushToSystemSetting
{
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url])
        {
            [[UIApplication sharedApplication] openURL:url];
        }
}

@end
