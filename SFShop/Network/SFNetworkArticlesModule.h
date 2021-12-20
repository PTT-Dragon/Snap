//
//  SFNetworkArticlesModule.h
//  SFShop
//
//  Created by MasterFly on 2021/9/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFNetworkArticlesModule : NSObject

@property (nonatomic, readonly, copy) NSString *articles;

@property (nonatomic, readonly, copy) NSString *articleCatgs;

- (NSString *)getDetailOf: (NSString *)articleId;

- (NSString *)getEvaluateOf: (NSString *)articleId;

- (NSString *)addEvaluatelOf: (NSString *)articleId;

@end

NS_ASSUME_NONNULL_END
