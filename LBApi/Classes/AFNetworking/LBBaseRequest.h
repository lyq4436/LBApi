//
//  LBBaseRequest.h
//  LBNetWorking
//
//  Created by 林波 on 16/7/8.
//  Copyright © 2016年 linbo1. All rights reserved.

//  网络框架(基础部分)

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@class LBBaseRequest;


// Http请求的方法
typedef NS_ENUM(NSUInteger, LBRequestMethod) {
    LBRequestMethodGET = 0,
    LBRequestMethodPOST,
    LBRequestMethodPUT,
    LBRequestMethodDELETE,
    LBRequestMethodPATCH,
    LBRequestMethodHEAD,
};

// 请求的SerializerType
typedef NS_ENUM(NSUInteger, LBRequestSerializerType) {
    LBRequestSerializerTypeHTTP = 0,
    LBRequestSerializerTypeJSON,
};

// 返回的SerializerType
typedef NS_ENUM(NSUInteger, LBResponseSerializerType) {
    LBResponseSerializerTypeHTTP = 0,
    LBResponseSerializerTypeJSON,
};


//block 返回
typedef NSError *(^LBRequestResponseFilterCallback)(__kindof LBBaseRequest *request, id responseObject);
typedef void(^LBRequestSuccessCallback)(__kindof LBBaseRequest *request, id responseObject);
typedef void(^LBRequestFailureCallback)(__kindof LBBaseRequest *request, NSError *error);
typedef void(^LBRequestCancelCallback)(__kindof LBBaseRequest *request);
typedef void(^LBRequestCompletionBlock)(__kindof LBBaseRequest *request);
typedef void(^LBRequestProgressCallback)(NSProgress *progress);
typedef void(^LBRequestConstructionCallback)(id<AFMultipartFormData> formData);


//代理方法
@protocol LBBaseRequestDelegate <NSObject>

@optional

/**
 *  请求完成的方法（主要是用在链式请求和批量请求知道进行下一步请求）
 *
 *  @param request 请求接口
 */
- (void)requestFinished:(LBBaseRequest *)request;

/**
 *  请求失败
 *
 *  @param request 请求接口
 */
- (void)requestFailed:(LBBaseRequest *)request;

/**
 *  清除请求
 */
- (void)clearRequest;

@end

@protocol LBRequestAccessory <NSObject>

@optional
/** 调用start */
- (void)requestWillStart:(id)request;
/** 请求任务重新连接 */
- (void)requestDidStart:(id)request;
/** 在 `successCallback` or `failureCallback` 前调用这个方法. */
- (void)requestWillStop:(id)request;
/* 在 `successCallback` or `failureCallback` 后调用这个方法. */
- (void)requestDidStop:(id)request;
@end



@interface LBBaseRequest : NSObject


@property (nonatomic, strong, readonly) NSURLSessionDataTask *task;
@property (nonatomic, weak) id<LBBaseRequestDelegate> delegate;
@property (nonatomic, strong) AFHTTPResponseSerializer <AFURLResponseSerialization> * responseSerializer;


- (void)addAccessory:(id<LBRequestAccessory>)accessory;


/**
 *  请求配置
 */
// Tag
@property (nonatomic) NSInteger tag;
// 基础连接 例如：http://www.baidu.com
@property (nonatomic, copy) NSString *requestBaseURL;
// app的版本号
@property (nonatomic, copy) NSString *appVersion;
// 连接后面的参数   例如：user/getinfo／php
@property (nonatomic, copy)   NSString *requestURL;
// 请求方式默认为GET请求
@property (nonatomic, assign) LBRequestMethod requestMethod;
// 请求超时时间
@property (nonatomic, assign) NSTimeInterval requestTimeoutInterval;
// 请求的默认头部
@property (nonatomic, strong) NSDictionary *requestDefaultHeader;
// 请求头部
@property (nonatomic, strong) NSDictionary *requestHeader;
// 请求参数
@property (nonatomic, strong) id requestParameters;
// 设置表单提交
@property (nonatomic, copy)   LBRequestConstructionCallback requestConstructionCallback;
// 请求的SerializerType
@property (nonatomic, assign) LBRequestSerializerType requestSerializerType;
// 返回的SerializerType
@property (nonatomic, assign) LBResponseSerializerType responseSerializerType;

@property (nonatomic, assign) BOOL showActivityIndicator;
// 返回的信息
@property (nonatomic, strong) id responseObject;
// 错误信息
@property (nonatomic, strong) NSError *error;
//返回状态的标示  例如：404错误
@property (nonatomic, assign, readonly) NSInteger responseStatusCode;
//返回头部信息
@property (nonatomic, strong, readonly) NSDictionary *responseHeader;
/**
 *  请求回调配置
 */
@property (nonatomic, copy) LBRequestProgressCallback uploadProgressCallback;
@property (nonatomic, copy) LBRequestProgressCallback downloadProgressCallback;
@property (nonatomic, copy) LBRequestResponseFilterCallback responseFilterCallback;
@property (nonatomic, copy) LBRequestSuccessCallback successCallback;
@property (nonatomic, copy) LBRequestFailureCallback failureCallback;

//开始
- (void)start;
/**
 *  设置成功和错误回调（这里没有开始 如果要直接开始请调用下面那个方法）
 *
 *  @param success 成功回调
 *  @param failure 错误回调
 */
- (void)setSuccessCallback:(LBRequestSuccessCallback)success failure:(LBRequestFailureCallback)failure;

/**
 *  开始并设置成功和错误回调
 *
 *  @param success 成功回调
 *  @param failure 错误回调
 */
- (void)startRequestSuccessCallback:(LBRequestSuccessCallback)success failureCallback:(LBRequestFailureCallback)failure;
//判断是否可以取消
@property (nonatomic, assign, readonly) BOOL canCancel;
//取消回调
@property (nonatomic, copy) LBRequestCancelCallback cancelCallback;
// 取消请求
- (void)cancel;
// 取消请求回调
- (void)cancelWithCallback:(LBRequestCancelCallback)cancel;
// 请求成功
- (void)requestDidFinishSuccess;
// 请求失败
- (void)requestDidFinishFailure;
@end

//请求管理
@interface LBRequestManager : NSObject
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
// 创建单例
+ (instancetype)sharedManager;
// 加入请求
- (void)addRequest:(LBBaseRequest *)request;
// 移除请求
- (void)removeRequest:(LBBaseRequest *)request;


@end

