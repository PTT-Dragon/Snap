//
//  SFNetworkManager.h
//  SFShop
//
//  Created by MasterFly on 2021/9/23.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFNetworkManager : NSObject

/// POST 请求
/// @param url 地址
/// @param success 成功回调
/// @param failed 失败回调
+ (void)post:(NSString *)url success:(void(^)(_Nullable id response))success failed:(void(^)(NSError *error))failed;
/// @param parameters 字典参数
+ (void)post:(NSString *)url parameters:(nullable NSDictionary *)parameters success:(void(^)(_Nullable id response))success failed:(void(^)(NSError *error))failed;

/// GET 请求
/// @param url 地址
/// @param success 成功回调
/// @param failed 失败回调
+ (void)get:(NSString *)url success:(void(^)(_Nullable id response))success failed:(void(^)(NSError *error))failed;
/// @param parameters 字典参数
+ (void)get:(NSString *)url parameters:(nullable NSDictionary *)parameters success:(void(^)(_Nullable id response))success failed:(void(^)(NSError *error))failed;
//数组传参的post请求
+ (void)post:(NSString *)url parametersArr:(nullable NSArray *)parametersArr success:(void(^)(_Nullable id response))success failed:(void(^)(NSError *error))failed;
//上传图片
+ (void)postImage:(NSString *)url image:(nullable UIImage *)image success:(void(^)(_Nullable id response))success failed:(void(^)(NSError *error))failed;
//下载PDF
+ (void)downloadPDF:(NSString *)url success:(void(^)(NSURL *fileURL))success failed:(void(^)(NSError *error))failed;
@end

NS_ASSUME_NONNULL_END
