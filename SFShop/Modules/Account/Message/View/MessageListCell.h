//
//  MessageListCell.h
//  SFShop
//
//  Created by 游挺 on 2021/12/10.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MessageListCell : UITableViewCell
@property (nonatomic,strong) MessageUnreadModel *unreadModel;
@property (nonatomic,strong) MessageContactModel *contactModel;
@end

NS_ASSUME_NONNULL_END
