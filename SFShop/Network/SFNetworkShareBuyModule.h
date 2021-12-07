//
//  SFNetworkShareBuyModule.h
//  SFShop
//
//  Created by 游挺 on 2021/12/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFNetworkShareBuyModule : NSObject
@property (nonatomic, readonly, copy) NSString *group;
- (NSString *)getAShareBuyGroupNbr: (NSString *)GroupNbr;
@end

NS_ASSUME_NONNULL_END
