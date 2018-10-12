//
//  LBBaseRequest.m
//  LBNetWorking
//
//  Created by 林波 on 16/7/8.
//  Copyright © 2016年 linbo1. All rights reserved.
//

#import "LBBaseRequest.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "AFNetworking.h"



@interface LBBaseRequest ()

//数组的弱引用
@property (nonatomic, strong, readwrite) NSPointerArray *accessories;
@property (nonatomic, strong, readwrite) NSURLSessionDataTask *task;

@property (nonatomic, assign, getter=isRunning) BOOL running;
@property (nonatomic, assign, getter=isCanceling) BOOL canceling;

@end



@implementation LBBaseRequest



#pragma mark - init


/**
 *  初始化
 *
 *  @return <#return value description#>
 */
- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestMethod = LBRequestMethodGET;
        self.requestTimeoutInterval = 30;
        self.requestSerializerType = LBRequestSerializerTypeJSON;
        self.responseSerializerType = LBResponseSerializerTypeJSON;
    }
    return self;
}

-(void)setRequestDefaultHeader:(NSDictionary *)requestDefaultHeader
{
    
    
    
    
    
}



#pragma mark - Event

/**
 *  开始请求
 */
- (void)start {
    
    if (self.isRunning) return;
    AFNetworkReachabilityStatus  status = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    
    switch (status) {
        case AFNetworkReachabilityStatusNotReachable:
            NSLog(@"无网络状态");
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
            NSLog(@"使用流量");
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
            NSLog(@"使用Wi-Fi");
            break;
        case AFNetworkReachabilityStatusUnknown:
            break;
        default:
            break;
    }
    self.running = YES;
    [self toggleAccessoriesRequestWillStart];
    [[LBRequestManager sharedManager] addRequest:self];
}


/**
 *  开始请求这里开始任务
 *
 *  @param success 设置成功后的回调
 *  @param failure 设置失败后的回调
 */
- (void)startRequestSuccessCallback:(LBRequestSuccessCallback)success failureCallback:(LBRequestFailureCallback)failure {
    [self setSuccessCallback:success failure:failure];
    [self start];
}

/**
 *  设置成功和失败的回调
 *
 *  @param success 设置成功后的回调
 *  @param failure 设置失败后的回调
 */
- (void)setSuccessCallback:(LBRequestSuccessCallback)success failure:(LBRequestFailureCallback)failure {
    self.successCallback = success;
    self.failureCallback = failure;
}

/**
 *  加入任务
 *
 *  @param accessory <#accessory description#>
 */
- (void)addAccessory:(id<LBRequestAccessory>)accessory {
    [self.accessories addPointer:(__bridge void *)accessory];
}

/**
 *  取消请求
 */
- (void)cancel {
    if (self.canceling) return;
    [self toggleAccessoriesRequestWillStop];
    self.delegate = nil;
    self.canceling = YES;
    [[LBRequestManager sharedManager] removeRequest:self];
    [self toggleAccessoriesRequestDidStop];
}

- (void)cancelWithCallback:(LBRequestCancelCallback)cancel {
    self.cancelCallback = cancel;
    [self cancel];
}

#pragma mark - delegate


/**
 *  请求成功的代理
 */
- (void)requestDidFinishSuccess
{
    
    
    
}

/**
 *  请求失败的代理
 */
- (void)requestDidFinishFailure
{
    
}


#pragma mark - Private

// 任务将要开始
- (void)toggleAccessoriesRequestWillStart {
    for (id<LBRequestAccessory> obj in self.accessories) {
        if ([obj respondsToSelector:@selector(requestWillStart:)]) {
            [obj requestWillStart:self];
        }
    }
}

// 任务开始
- (void)toggleAccessoriesRequestDidStart {
    for (id<LBRequestAccessory> obj in self.accessories) {
        if ([obj respondsToSelector:@selector(requestDidStart:)]) {
            [obj requestDidStart:self];
        }
    }
}

// 任务将要停止
- (void)toggleAccessoriesRequestWillStop {
    for (id<LBRequestAccessory> obj in self.accessories) {
        if ([obj respondsToSelector:@selector(requestWillStop:)]) {
            [obj requestWillStop:self];
        }
    }
}

// 任务停止
- (void)toggleAccessoriesRequestDidStop {
    for (id<LBRequestAccessory> obj in self.accessories) {
        if ([obj respondsToSelector:@selector(requestDidStop:)]) {
            [obj requestDidStop:self];
        }
    }
}

#pragma mark - Getter

/**
 *  请求的任务状态
 *
 *  @return 状态值（例如:404 ）
 */
- (NSInteger)responseStatusCode {
    return [(NSHTTPURLResponse *)self.task.response statusCode];
}

/**
 *  请求任务是否可以停止
 *
 *  @return YES:可以  NO:不可以
 */
- (BOOL)canCancel {
    return self.task ? YES : NO;
}


/**
 *  返回信息的头部
 *
 *  @return 头部信息
 */
- (NSDictionary *)responseHeader {
    return [(NSHTTPURLResponse *)self.task.response allHeaderFields];
}


/**
 *  初始化多个请求任务的数组
 *
 *  @return 数组
 */
- (NSPointerArray *)accessories {
    if (!_accessories) {
        _accessories = [NSPointerArray pointerArrayWithOptions:NSPointerFunctionsWeakMemory];;
    }
    return _accessories;
}



@end


#pragma mark -  LBRequestManager

static NSDictionary * LBHeadDictionaryFromRequest(LBBaseRequest *request)
{
    NSDictionary *defaultHeader = request.requestDefaultHeader;
    NSDictionary *normalHeader = request.requestHeader;
    NSMutableDictionary *header = [NSMutableDictionary dictionaryWithDictionary:defaultHeader];
    [header addEntriesFromDictionary:normalHeader];
    return header;
}


static NSString * LBURLStringFromRequest(LBBaseRequest *request)
{
    NSString *detailURL = request.requestURL;
    if ([[detailURL lowercaseString] hasPrefix:@"http"]) {
        return detailURL;
    }
    NSString *baseURL = request.requestBaseURL;
    NSString *version = request.appVersion;
    if ([[baseURL lowercaseString] hasPrefix:@"http"]) {
        return [NSString stringWithFormat:@"%@%@%@", baseURL, detailURL.length==0?@"":detailURL,version.length==0?@"":version];
    } else {
        return nil;
    }
}

static NSString * LBHashStringFromTask(NSURLSessionDataTask *task)
{
    return [NSString stringWithFormat:@"%lu", (unsigned long)[task hash]];
}


@interface LBRequestManager ()


@property (nonatomic, strong) NSMutableDictionary *requests;

@end


@implementation LBRequestManager


#pragma mark - init


/**
 *  单例
 *
 *  @return <#return value description#>
 */
+ (instancetype)sharedManager {
    static LBRequestManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [LBRequestManager new];
    });
    return instance;
}

/**
 *   初始化信息
 *
 *  @return <#return value description#>
 */
- (instancetype)init {
    self = [super init];
    if (self) {
        self.sessionManager = [AFHTTPSessionManager manager];
        self.sessionManager.completionQueue = dispatch_queue_create("io.dazuo.github.request.session.completion.queue", DISPATCH_QUEUE_CONCURRENT);
        self.requests = [NSMutableDictionary dictionary];
        self.sessionManager.securityPolicy = [self customSecurityPolicy];
        self.sessionManager.securityPolicy.allowInvalidCertificates = YES;

    }
       return self;
}


#pragma mark- 配置https
- (AFSecurityPolicy *)customSecurityPolicy
{
    /** https */
    NSString*cerPath = [[NSBundle mainBundle] pathForResource:@"kyfw.12306.cn.cer"ofType:nil];
    NSData*cerData = [NSData dataWithContentsOfFile:cerPath];
    NSSet*set = [[NSSet alloc] initWithObjects:cerData,nil];
    AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:set];
    return policy;
}


/**
 *   移除请求任务
 *
 *  @param request  请求接口
 */
- (void)removeTask:(LBBaseRequest *)request
{
    NSString *key = LBHashStringFromTask(request.task);
    @synchronized(self) {
        [self.requests removeObjectForKey:key];
    }
}

#pragma mark - Private

/**
 *  处理请求成功
 *
 *  @param request        请求接口
 *  @param responseObject  服务器返回的信息
 */
- (void)handleResponseSuccess:(LBBaseRequest *)request responseObject:(id)responseObject
{
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        request.responseObject = responseObject;
        request.error = nil;
        [request requestDidFinishSuccess];
        !request.successCallback?:request.successCallback(request, request.responseObject);
        [request.delegate requestFinished:request];
    });
    
    

}


/**
 *  处理请求失败
 *
 *  @param request 请求接口
 *  @param error   请求错误信息
 */
- (void)handleResponseFailure:(LBBaseRequest *)request error:(NSError *)error {
   
    dispatch_sync(dispatch_get_main_queue(), ^{
        request.responseObject = nil;
        request.error = error;
        [request requestDidFinishFailure];
        !request.failureCallback?:request.failureCallback(request, request.error);
        [request.delegate requestFailed:request];
        
    });
    
}


/**
 *  处理取消请求
 *
 *  @param request 取消的请求
 */
- (void)handleResponseCancelled:(LBBaseRequest *)request
{
    !request.cancelCallback?:request.cancelCallback(request);
    [request.delegate clearRequest];

}


/**
 *  处理返回信息
 *
 *  @param task           请求任务
 *  @param responseObject 返回信息
 *  @param error          错误信息
 */
- (void)handleResponse:(NSURLSessionDataTask *)task response:(id)responseObject error:(NSError *)error
{
    
    NSString *key = LBHashStringFromTask(task);
    LBBaseRequest *request = self.requests[key];
    if (error.code == NSURLErrorCancelled)
    {
        request.running = NO;
        [self handleResponseCancelled:request];
        request.canceling = NO;
    } else
    {
        request.running = NO;
        request.canceling = NO;
        [request toggleAccessoriesRequestWillStop];
        if (!error)
        {
            if (request.responseFilterCallback)
            {
                NSError *filterError = request.responseFilterCallback(request, responseObject);
                if (filterError)
                {
                    [self handleResponseFailure:request error:filterError];
                }
                else
                {
                    [self handleResponseSuccess:request responseObject:responseObject];
                }
            }
            else
            {
                [self handleResponseSuccess:request responseObject:responseObject];
            }
        }
        else
        {
            [self handleResponseFailure:request error:error];
        }
        [request toggleAccessoriesRequestDidStop];
    }
    
    [self removeTask:request];
}

#pragma mark - Public


/**
 *  加入请求并执行开始请求任务（这里才是真正开始执行请求）
 *
 *  @param request 请求接口
 */

- (void)addRequest:(LBBaseRequest *)request
{
    LBRequestSerializerType requestSerializerType = request.requestSerializerType;
    switch (requestSerializerType) {
        case LBRequestSerializerTypeHTTP:{
            self.sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        } break;
        case LBRequestSerializerTypeJSON: {
            self.sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        } break;
        default:
            break;
    }
    self.sessionManager.requestSerializer.timeoutInterval = request.requestTimeoutInterval;
    NSDictionary *headers = LBHeadDictionaryFromRequest(request);
    for (id field in headers.allKeys) {
        id value = headers[field];
        if ([field isKindOfClass:[NSString class]] && [value isKindOfClass:[NSString class]]) {
            [self.sessionManager.requestSerializer setValue:value forHTTPHeaderField:field];
        } else {
            
            NSLog(@"Error, the key and value in HTTPRequestHeaders should be string."); // 红色
        }
    }
    LBResponseSerializerType responseSerializerType = request.responseSerializerType;
    switch (responseSerializerType) {
        case LBResponseSerializerTypeJSON:
            self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
            break;
        case LBResponseSerializerTypeHTTP:
            self.sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
            break;
        default:
            break;
    }
    self.sessionManager.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"application/json", @"sparql-results+json", @"text/json", @"text/html",@"text/plain", @"text/xml",@"text/text",@"image/jpeg",@"text/css",@"image/png", nil];
    NSString *url = LBURLStringFromRequest(request);
    if (url.length == 0)
    {
         NSLog(@"Error, the request URL format is wrong.");
    }else
    {
         NSLog(@"URL===%@",url);
    }
    LBRequestMethod method = request.requestMethod;
    id params = request.requestParameters;
    LBRequestConstructionCallback constructionBlock = request.requestConstructionCallback;
    LBRequestProgressCallback uploadProgressCallback = request.uploadProgressCallback;
    LBRequestProgressCallback downloadProgressCallback = request.downloadProgressCallback;
    
    NSURLSessionDataTask *task = nil;
    switch (method) {
        case LBRequestMethodGET: {
            task = [self.sessionManager GET:url parameters:params progress:^(NSProgress *downloadProgress) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    !downloadProgressCallback?:downloadProgressCallback(downloadProgress);
                });
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self handleResponse:task response:responseObject error:nil];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self handleResponse:task response:nil error:error];
            }];
        } break;
            
        case LBRequestMethodPOST: {
            if (constructionBlock) {
                task = [self.sessionManager POST:url parameters:params constructingBodyWithBlock:constructionBlock progress:^(NSProgress * _Nonnull uploadProgress) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        !uploadProgressCallback?:uploadProgressCallback(uploadProgress);
                    });
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    [self handleResponse:task response:responseObject error:nil];
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [self handleResponse:task response:nil error:error];
                }];
            } else {
                task = [self.sessionManager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    [self handleResponse:task response:responseObject error:nil];
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [self handleResponse:task response:nil error:error];
                }];
            }
        } break;
            
        case LBRequestMethodPUT: {
            task = [self.sessionManager PUT:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self handleResponse:task response:responseObject error:nil];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self handleResponse:task response:nil error:error];
            }];
        } break;
            
        case LBRequestMethodDELETE: {
            task = [self.sessionManager DELETE:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self handleResponse:task response:responseObject error:nil];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self handleResponse:task response:nil error:error];
            }];
        } break;
            
        case LBRequestMethodPATCH: {
            task = [self.sessionManager PATCH:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self handleResponse:task response:responseObject error:nil];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self handleResponse:task response:nil error:error];
            }];
        } break;
            
        case LBRequestMethodHEAD: {
            task = [self.sessionManager HEAD:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task) {
                [self handleResponse:task response:nil error:nil];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self handleResponse:task response:nil error:error];
            }];
        } break;
            
        default:
            break;
    }
    
    
    [AFNetworkActivityIndicatorManager sharedManager].enabled = request.showActivityIndicator;
    request.task = task;
    [self addTask:request];
    [request toggleAccessoriesRequestDidStart];
}

/**
 *  加入请求任务
 *
 *  @param request 请求接口
 */
- (void)addTask:(LBBaseRequest *)request
{
    if (request.task) {
        NSString *key = LBHashStringFromTask(request.task);
        @synchronized(self) {
            [self.requests setValue:request forKey:key];
        }
    }
}

/**
 *  取消请求
 *
 *  @param request 请求接口
 */
- (void)removeRequest:(LBBaseRequest *)request
{
    [request.task cancel];
}

@end

