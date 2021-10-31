//
//  ProductSpecAttrsView.h
//  SFShop
//
//  Created by Jacue on 2021/10/30.
//

#import <UIKit/UIKit.h>
#import "ProductDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProductSpecAttrsView : UIView

typedef void(^Block)(void);

@property(nonatomic, strong) ProductDetailModel *model;
@property (nonatomic, copy) Block dismissBlock;

@end

@interface ProductAttrButton : UIButton

@end


NS_ASSUME_NONNULL_END
