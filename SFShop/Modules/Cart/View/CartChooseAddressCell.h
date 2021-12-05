//
//  CartChooseAddressCell.h
//  SFShop
//
//  Created by 游挺 on 2021/10/30.
//

#import <UIKit/UIKit.h>
#import "addressModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^SelBlock)(addressModel *model);

@interface CartChooseAddressCell : UITableViewCell
- (void)setContent:(addressModel *)model;
@property (nonatomic, copy) SelBlock selBlock;
@end

NS_ASSUME_NONNULL_END
