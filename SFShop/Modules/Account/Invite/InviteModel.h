//
//  InviteModel.h
//  SFShop
//
//  Created by 游挺 on 2021/10/22.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface InviteModel : JSONModel
@property (nonatomic,copy) NSString <Optional>*beInvdUser;
@property (nonatomic,copy) NSString <Optional>*beInvdUserName;
@property (nonatomic,copy) NSString <Optional>*inviterGift;
@property (nonatomic,copy) NSString <Optional>*regTime;
@property (nonatomic,copy) NSString <Optional>*url;
@property (nonatomic,copy) NSArray <Optional>*gift;
/**
 {
beInvdUser = 1228;
beInvdUserName = "hxf12@qq.com";
gift =             (
 "invite new"
);
inviterGift = "<null>";
regTime = "2021-07-21 16:35:48";
url = "<null>";
}
 **/
@end

NS_ASSUME_NONNULL_END
