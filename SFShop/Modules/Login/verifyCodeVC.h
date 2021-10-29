//
//  verifyCodeVC.h
//  SFShop
//
//  Created by 游挺 on 2021/9/24.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    LoginType_Code = 0,
    
} LoginType;

NS_ASSUME_NONNULL_BEGIN

@interface verifyCodeVC : UIViewController
@property (nonatomic,copy) NSString *account;
@property (nonatomic,assign) LoginType type;
@end

NS_ASSUME_NONNULL_END
