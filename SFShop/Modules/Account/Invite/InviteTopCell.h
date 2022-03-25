//
//  InviteTopCell.h
//  SFShop
//
//  Created by 游挺 on 2021/10/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InviteTopCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (nonatomic,assign) NSInteger totalCount;
@property (nonatomic,copy) NSDictionary *ruleDic;

@end

NS_ASSUME_NONNULL_END
