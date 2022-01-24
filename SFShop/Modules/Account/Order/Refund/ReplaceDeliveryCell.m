//
//  ReplaceDeliveryCell.m
//  SFShop
//
//  Created by 游挺 on 2022/1/24.
//

#import "ReplaceDeliveryCell.h"
#import "UITextField+expand.h"

@interface ReplaceDeliveryCell ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UITextField *field1;
@property (weak, nonatomic) IBOutlet UITextField *field2;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel1;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel2;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic,strong) NSMutableDictionary *infoDic;
@property (nonatomic,assign) NSInteger row;

@end

@implementation ReplaceDeliveryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = RGBColorFrom16(0xf5f5f5);
    self.field1.layer.borderWidth = 1;
    self.field2.layer.borderWidth = 1;
    self.field1.delegate = self;
    self.field2.delegate = self;
    [self.field1 addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    [self.field2 addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    _label1.text = kLocalizedString(@"PACKAGE_CODE");
    _label2.text = kLocalizedString(@"LOGISTICS");
    _field1.placeholder = kLocalizedString(@"PACKAGE_CODE");
    _field2.placeholder = kLocalizedString(@"LOGISTICS");
    _tipLabel1.text = [NSString stringWithFormat:@"%@%@",kLocalizedString(@"PACKAGE_CODE"),kLocalizedString(@"IS_REQUIRE")];
    _tipLabel2.text = [NSString stringWithFormat:@"%@%@",kLocalizedString(@"LOGISTICS"),kLocalizedString(@"IS_REQUIRE")];
}
- (void)layoutSubviews
{
    
}
- (void)changedTextField:(UITextField *)textField
{
    if (textField == _field1) {
//            [textField textFieldState:ANOTHERTYPE editType:EIDTTYPE labels:@[_label1]];
        [textField textFieldState:ANOTHERTYPE label:_label1 tipLabel:_tipLabel1];
    }else{
        [textField textFieldState:ANOTHERTYPE label:_label2 tipLabel:_tipLabel2];
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == _field1) {
        _label1.hidden = NO;
    }else{
        _label2.hidden = NO;
    }
//    if (textField == _accountField) {
//        if (_type == 1) {
//            _accountSuccess = [textField textFieldState:CHECKPHONETYPE editType:BEGINEDITTYPE labels:@[_label1]];
//        }else{
//            _accountSuccess = [textField textFieldState:CHECKEMAILTYPE editType:BEGINEDITTYPE labels:@[_label1]];
//        }
//    }else if (textField == _passwordField){
//        _passwordSuccess = [textField textFieldState:CHECKPASSWORDTYPE editType:BEGINEDITTYPE labels:@[_label2]];
//    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _field1) {
        _label1.hidden = [textField.text isEqualToString:@""];
        [_infoDic setValue:textField.text forKey:@"text1"];
//        _infoDic[@"text1"] = textField.text;
    }else{
        _label2.hidden = [textField.text isEqualToString:@""];
        [_infoDic setValue:textField.text forKey:@"text2"];
//        _infoDic[@"text2"] = textField.text;
    }
    if (self.block) {
        self.block(_infoDic, _row);
    }
    
//    if (textField == _accountField) {
//        if (_type == 1) {
//            _accountSuccess = [textField textFieldState:CHECKPHONETYPE editType:ENDEDITTYPE labels:@[_label1]];
//        }else{
//            _accountSuccess = [textField textFieldState:CHECKEMAILTYPE editType:ENDEDITTYPE labels:@[_label1]];
//        }
//    }else if (textField == _passwordField){
//        _passwordSuccess = [textField textFieldState:CHECKPASSWORDTYPE editType:ENDEDITTYPE labels:@[_label2]];
//    }
}
- (void)setContent:(NSMutableDictionary *)dic row:(NSInteger)row
{
    _infoDic = dic;
    _row = row;
    _field1.text = dic[@"text1"];
    _field2.text = dic[@"text2"];
    _titleLabel.text = [NSString stringWithFormat:@"%@%ld",kLocalizedString(@"PACKAGE"),row+1];
}
- (IBAction)deleteAction:(id)sender {
    if (self.deleteBlock) {
        self.deleteBlock(_row);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
