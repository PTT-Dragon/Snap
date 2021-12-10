//
//  SFNetworkFlashSaleModule.h
//  SFShop
//
//  Created by 游挺 on 2021/12/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFNetworkFlashSaleModule : NSObject
@property (nonatomic, readonly, copy) NSString *next;
@property (nonatomic, readonly, copy) NSString *productList;

- (NSString *)getCatg:(NSString *)catgId;
@end

NS_ASSUME_NONNULL_END
