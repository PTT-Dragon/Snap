//
//  SFNetworkOffersModule.m
//  SFShop
//
//  Created by MasterFly on 2021/9/27.
//

#import "SFNetworkOffersModule.h"

@implementation SFNetworkOffersModule

- (NSString *)offers {
    return K_offers_domain(@"");
}

- (NSString *)getDetailOf: (NSInteger)offerId {
    NSString *url = [NSString stringWithFormat:@"detail/%ld", offerId];
    return K_offers_domain(url);
}

@end
