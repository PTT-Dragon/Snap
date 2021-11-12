//
//  AddressTableViewCell.h
//  SFShop
//
//  Created by 游挺 on 2021/10/15.
//

#import <UIKit/UIKit.h>
#import "addressModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddressTableViewCell : UITableViewCell
- (void)setContent:(addressModel *)model;

@end

NS_ASSUME_NONNULL_END
