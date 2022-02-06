//
//  NSDictionary+add.h
//  SFShop
//
//  Created by 游挺 on 2022/2/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (add)
//模型转字典
- (NSDictionary *)dicFromObject:(NSObject *)object;
@end

NS_ASSUME_NONNULL_END
