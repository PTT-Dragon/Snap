//
//  CancelOrderChooseReason.h
//  SFShop
//
//  Created by 游挺 on 2021/10/31.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CancelOrderChooseReasonBlock)(BOOL sel);

@interface CancelOrderChooseReason : UITableViewCell
@property (nonatomic,copy) CancelOrderChooseReasonBlock block;
@property (weak, nonatomic) IBOutlet UILabel *reasonLabel;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end

NS_ASSUME_NONNULL_END
