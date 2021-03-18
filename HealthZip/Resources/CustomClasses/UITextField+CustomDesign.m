//
//  UITextField+CustomDesign.m
//  iDeals
//
//  Created by Pragnesh Dixit on 09/02/16.
//  Copyright © 2016 Pragnesh Dixit. All rights reserved.
//

#import "UITextField+CustomDesign.h"

@implementation UITextField_CustomDesign

@synthesize cornerRadius;
@synthesize borderWidth;
@synthesize borderColor;
@synthesize placeholderTextColor;
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {

    self.layer.cornerRadius     = cornerRadius;
    self.layer.borderWidth      = borderWidth;
    self.layer.borderColor      = borderColor.CGColor;
    self.layer.masksToBounds    = true;
    if (placeholderTextColor) {

         [self setValue:self.placeholderTextColor forKeyPath:@"placeholderLabel.textColor"];
    }
}


@end
