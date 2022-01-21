//
//  ArticleProductCell.h
//  SFShop
//
//  Created by Jacue on 2021/10/3.
//

#import <UIKit/UIKit.h>
#import "ArticleDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ArticleProductCell : UIView

typedef void(^BuyBlock)(ArticleProduct *);

@property(nonatomic, strong) ArticleProduct *model;
@property (nonatomic, copy) BuyBlock buyBlock;

@end

NS_ASSUME_NONNULL_END
