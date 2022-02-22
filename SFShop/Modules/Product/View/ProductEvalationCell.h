//
//  ProductEvalationCell.h
//  SFShop
//
//  Created by 游挺 on 2021/12/9.
//

#import <UIKit/UIKit.h>
#import "ProductDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProductEvalationCell : UITableViewCell
@property (nonatomic,strong) ProductEvalationModel *model;
@property (nonatomic,assign) BOOL showLine;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

NS_ASSUME_NONNULL_END
