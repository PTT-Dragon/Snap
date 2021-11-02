//
//  SFNetworkManager.m
//  SFShop
//
//  Created by MasterFly on 2021/9/23.
//

#import "SFNetworkManager.h"
#import "SFNetworkURL.h"
#import <AFNetworking/AFNetworking.h>

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
    UserModel *model = [FMDBManager sharedInstance].currentUser;
    [manager GET:url parameters:parameters headers:@{@"accessToken":model ? model.accessToken: @""} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *error;
        id obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves|NSJSONReadingFragmentsAllowed error:&error];
        !success?:success(obj);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        !failed?:failed(error);
    }];
}

@end
