//
//  LoginViewController.h
//  SFShop
//
//  Created by Jacue on 2021/9/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginViewController : UIViewController

typedef void(^DidLoginBlock)(void);

@property (nonatomic, copy) DidLoginBlock didLoginBlock;


@end

NS_ASSUME_NONNULL_END
