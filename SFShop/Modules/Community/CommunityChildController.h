//
//  CommunityChildController.h
//  SFShop
//
//  Created by Jacue on 2021/9/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommunityChildController : UIViewController

@property (nonatomic, strong) NSString *articleCatgId;
- (void)request;
@end

NS_ASSUME_NONNULL_END
