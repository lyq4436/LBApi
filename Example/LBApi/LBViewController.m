//
//  LBViewController.m
//  LBApi
//
//  Created by 872472634@qq.com on 10/09/2018.
//  Copyright (c) 2018 872472634@qq.com. All rights reserved.
//

#import "LBViewController.h"
#import <LBApi/LBApi-umbrella.h>


@interface LBViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>




@end

@implementation LBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    LBBaseRequest *base = [[LBBaseRequest alloc]init];
    base.tag = 10000;
    base.requestMethod = LBRequestMethodGET;
    base.requestURL = @"http://beta.zej.onlyou.com/app/h5/home/queryUserType.json";
    base.requestParameters = @{@"name":@"16"};
    [base startRequestSuccessCallback:^(__kindof LBBaseRequest *request, id responseObject) {
        
        NSLog(@"%@",responseObject);
        
    } failureCallback:^(__kindof LBBaseRequest *request, NSError *error) {
        
        NSLog(@"%@",error.userInfo);
        
    }];
    
 
    
    
}
- (IBAction)click:(id)sender {
    
    
    
    
    
    
//    [LBCheckPrivilegeInfo showAlertControllerTitle:@"提示" message:@"内容" cancle:@"取消" actions:nil preferredStyle:UIAlertControllerStyleAlert viewController:self];
    
    
    
    if ([LBCheckPrivilegeInfo checkCameraPrivacyViewController:self]) {
        UIImagePickerController *pic = [[UIImagePickerController alloc]init];
        pic.delegate = self;
        pic.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:pic animated:YES completion:nil];
    }
    
    
    
    
    
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
