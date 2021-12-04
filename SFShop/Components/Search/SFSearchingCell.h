//
//  SFSearchingCell.h
//  SFShop
//
//  Created by MasterFly on 2021/12/4.
//

#import <UIKit/UIKit.h>
#import "SFSearchingModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SFSearchingCell : UITableViewCell

@property (nonatomic, readwrite, copy) SFSearchingModel *model;

@end

NS_ASSUME_NONNULL_END
