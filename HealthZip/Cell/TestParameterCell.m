//
//  TestParameterCell.m
//  HealthZip
//
//  Created by Tristate on 6/1/16.
//  Copyright © 2016 Tristate. All rights reserved.
//

#import "TestParameterCell.h"
#import "Constants.h"
@implementation TestParameterCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - TEXTFIELD DELEGATE METHODS -

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString *strCondition=[NSString stringWithFormat:@"%@",textField.text];
    if ([strCondition floatValue]>= _minVal && [strCondition floatValue]<= _maxVal) {
        textField.textColor = COLORCODE_GREEN;
       
    }else{
        textField.textColor = COLORCODE_RED;
    }

    if ([self.delegate respondsToSelector:@selector(getTestValue:)]) {
        [self.delegate getTestValue:self];
    }
   
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-
(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([self.delegate respondsToSelector:@selector(getTestValue:)]) {
        [self.delegate getTestValue:self];
    }
    char *x = (char*)[string UTF8String];
        //NSLog(@"char index is %i",x[0]);
        if( [string isEqualToString:@"."] || [string isEqualToString:@"0"] || [string isEqualToString:@"1"] ||  [string isEqualToString:@"2"] ||  [string isEqualToString:@"3"] ||  [string isEqualToString:@"4"] ||  [string isEqualToString:@"5"] ||  [string isEqualToString:@"6"] ||  [string isEqualToString:@"7"] ||  [string isEqualToString:@"8"] ||  [string isEqualToString:@"9"] || x[0]==0 ) {
            
            NSString *strCondition=[NSString stringWithFormat:@"%@%@",textField.text,string];
            if ([strCondition floatValue]>= _minVal && [strCondition floatValue]<= _maxVal) {
                 textField.textColor = COLORCODE_GREEN;
                return YES;
            }else{
                 textField.textColor = COLORCODE_RED;
                return YES;
            }
            
        } else {
            return NO;
        }
    
}
@end
