//
//  accountInfoCell.h
//  SFShop
//
//  Created by 游挺 on 2021/9/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface accountInfoCell : UITableViewCell
@property (nonatomic,assign) NSInteger favoriteCount;
@property (nonatomic,assign) NSInteger noReadMessageCount;
@property (nonatomic,assign) NSInteger recentCount;
- (void)updateData;
@end

NS_ASSUME_NONNULL_END
