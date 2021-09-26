//
//  CommunityDetailController.m
//  SFShop
//
//  Created by Jacue on 2021/9/25.
//

#import "CommunityDetailController.h"
#import "ArticleDetailModel.h"

@interface CommunityDetailController ()

@property(nonatomic, strong) ArticleDetailModel *model;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@end

@implementation CommunityDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self request];
}

- (void)request {
    [SFNetworkManager get: [SFNet.article getDetailOf: _articleId] success:^(id  _Nullable response) {
        NSError *error;
        self.model = [[ArticleDetailModel alloc] initWithDictionary: response error: &error];
        [self refresh];
        NSLog(@"get article detail success");
    } failed:^(NSError * _Nonnull error) {
        NSLog(@"get article detail failed");
    }];
}

- (void)refresh {
    NSString *detailStr = self.model.articleDetail;
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithData: [detailStr dataUsingEncoding: NSUnicodeStringEncoding] options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes: nil error: nil];
    self.detailLabel.attributedText = attrStr;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
