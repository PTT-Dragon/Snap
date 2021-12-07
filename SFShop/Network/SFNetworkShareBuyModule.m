//
//  SFNetworkShareBuyModule.m
//  SFShop
//
//  Created by 游挺 on 2021/12/8.
//

#import "SFNetworkShareBuyModule.h"

@implementation SFNetworkShareBuyModule
- (NSString *)group
{
    return K_shareBuy_domain(@"group");
}
- (NSString *)getAShareBuyGroupNbr: (NSString *)GroupNbr
{
    NSString *url = [NSString stringWithFormat:@"group/%@",GroupNbr];
    return K_shareBuy_domain(url);
}
@end
