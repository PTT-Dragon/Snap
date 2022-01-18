//
//  ReviewChildViewController.h
//  SFShop
//
//  Created by 游挺 on 2021/10/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN



@interface ReviewChildViewController : UIViewController
@property (nonatomic,assign) NSInteger type;//1.To review 2.rated
@property (nonatomic,copy) NSString *orderItemId;//1.To review 2.rated

@end

NS_ASSUME_NONNULL_END
