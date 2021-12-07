//
//  SFNetworkManager.m
//  SFShop
//
//  Created by MasterFly on 2021/9/23.
//

#import "SFNetworkManager.h"
#import "SFNetworkURL.h"
#import <AFNetworking/AFNetworking.h>
#import "NSString+Add.h"

@implementation SFNetworkManager

+ (void)post:(NSString *)url success:(void(^)(_Nullable id response))success failed:(void(^)(NSError *error))failed {
    [self post:url parameters:nil success:success failed:failed];
}

+ (void)post:(NSString *)url parameters:(nullable NSDictionary *)parameters success:(void(^)(_Nullable id response))success failed:(void(^)(NSError *error))failed {
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    [manager setAuthenticationChallengeHandler:^id _Nonnull(NSURLSession * _Nonnull session, NSURLSessionTask * _Nonnull task, NSURLAuthenticationChallenge * _Nonnull challenge, void (^ _Nonnull completionHandler)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable)) {
        return [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
    }];
    UserModel *model = [FMDBManager sharedInstance].currentUser;
    [manager POST:url parameters:parameters headers:@{@"accessToken":model ? model.accessToken: @""} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves|NSJSONReadingFragmentsAllowed error:nil];
        !success?:success(obj);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        !failed?:failed(error);
    }];
}

+ (void)get:(NSString *)url success:(void(^)(_Nullable id response))success failed:(void(^)(NSError *error))failed {
    [self get:url parameters:nil success:success failed:failed];
}

+ (void)get:(NSString *)url parameters:(nullable NSDictionary *)parameters success:(void(^)(_Nullable id response))success failed:(void(^)(NSError *error))failed {
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain",@"application/pdf", nil];
//    AFSecurityPolicy * securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
//    securityPolicy.allowInvalidCertificates = YES;
//    securityPolicy.validatesDomainName = NO;
//    manager.securityPolicy = securityPolicy;
    UserModel *model = [FMDBManager sharedInstance].currentUser;
    [manager GET:url parameters:parameters headers:@{@"accessToken":model ? model.accessToken: @""} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *error;
        id obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves|NSJSONReadingFragmentsAllowed error:&error];
        !success?:success(obj);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        !failed?:failed(error);
    }];
}

+ (void)post:(NSString *)url parametersArr:(nullable NSArray *)parametersArr success:(void(^)(_Nullable id response))success failed:(void(^)(NSError *error))failed {
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    [manager setAuthenticationChallengeHandler:^id _Nonnull(NSURLSession * _Nonnull session, NSURLSessionTask * _Nonnull task, NSURLAuthenticationChallenge * _Nonnull challenge, void (^ _Nonnull completionHandler)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable)) {
        return [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
    }];
    UserModel *model = [FMDBManager sharedInstance].currentUser;
    
    
      
    NSError *parseError = nil;

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parametersArr options:NSJSONWritingPrettyPrinted  error:&parseError];
      
    NSString *jsonstr =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
      
    NSData *objectData = [jsonstr dataUsingEncoding:NSUTF8StringEncoding];
      
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:objectData
                               
                                                              options:NSJSONReadingMutableContainers
                               
                                                                error:&parseError];
    [manager POST:url parameters:jsonDic headers:@{@"accessToken":model ? model.accessToken: @""} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves|NSJSONReadingFragmentsAllowed error:nil];
        !success?:success(obj);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        !failed?:failed(error);
    }];
}
+ (void)postImage:(NSString *)url image:(nullable UIImage *)image success:(void(^)(_Nullable id response))success failed:(void(^)(NSError *error))failed {
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:@"image/png" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    [manager setAuthenticationChallengeHandler:^id _Nonnull(NSURLSession * _Nonnull session, NSURLSessionTask * _Nonnull task, NSURLAuthenticationChallenge * _Nonnull challenge, void (^ _Nonnull completionHandler)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable)) {
        return [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
    }];
    UserModel *model = [FMDBManager sharedInstance].currentUser;
    [manager POST:url parameters:@{} headers:@{@"accessToken":model ? model.accessToken: @""} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *imageData = UIImagePNGRepresentation(image);
             /**
             拼接文件参数

             @fileData : 要上传的文件数据
             @name : 后台定义文件的参数名
             @fileName ： 上传到服务器的文件名称
             @mimeType : 上传的文件类型
           */
        [formData appendPartWithFileData:imageData name:@"file" fileName:@"0CR9CC45-72EC-4522-9D8E-RB8491192E01.jpeg" mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves|NSJSONReadingFragmentsAllowed error:nil];
        !success?:success(obj);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        !failed?:failed(error);
    }];
}

@end
