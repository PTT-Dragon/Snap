//
//  SFNetworkArticlesModule.m
//  SFShop
//
//  Created by MasterFly on 2021/9/25.
//

#import "SFNetworkArticlesModule.h"

@implementation SFNetworkArticlesModule

- (NSString *)articles {
    return K_articles_domain(@"");
}

- (NSString *)articleCatgs {
    return K_articles_domain(@"catgs");
}

- (NSString *)getDetailOf: (NSString *)articleId {
    return K_articles_domain(articleId);
}

- (NSString *)addEvaluatelOf: (NSString *)articleId {
    NSString *url = [NSString stringWithFormat:@"%@/evaluate/add",K_articles_domain(articleId)];
    return url;
}
- (NSString *)likeEvaluatelOf: (NSString *)articleId {
    NSString *url = [NSString stringWithFormat:@"%@/useful",K_articles_evaluates_domain(articleId)];
    return url;
}

- (NSString *)getEvaluateOf: (NSString *)articleId {
    return K_articles_evaluate_domain(articleId);
}

@end
