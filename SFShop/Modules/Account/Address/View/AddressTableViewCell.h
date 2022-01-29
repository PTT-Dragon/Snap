//
//  AddressTableViewCell.h
//  SFShop
//
//  Created by 游挺 on 2021/10/15.
//

#import <UIKit/UIKit.h>
#import "addressModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^AddressTableViewCellBlock)(addressModel *model);


@interface AddressTableViewCell : UITableViewCell
@property (nonatomic,copy) AddressTableViewCellBlock block;
- (void)setContent:(addressModel *)model;
/**
 当前地址标记
 */
@property (nonatomic, copy) NSString *curAddress;
@end

NS_ASSUME_NONNULL_END
