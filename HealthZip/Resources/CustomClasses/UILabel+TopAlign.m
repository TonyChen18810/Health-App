//
//  UILabel+TopAlign.m
//  FinanceSwipe
//
//  Created by Parth on 26/11/15.
//  Copyright © 2015 TriState. All rights reserved.
//

#import "UILabel+TopAlign.h"

@implementation UILabel_TopAlign

- (void)drawTextInRect:(CGRect)rect {
    
    if (self.text) {
        CGSize labelStringSize = [self.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.frame), CGFLOAT_MAX)
            options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
            attributes:@{NSFontAttributeName:self.font}
            context:nil].size;
        
        [super drawTextInRect:CGRectMake(0, 0, ceilf(CGRectGetWidth(self.frame)),ceilf(labelStringSize.height))];
    } else {
        [super drawTextInRect:rect];
    }
    self.lineBreakMode = NSLineBreakByTruncatingTail;
}

- (void)prepareForInterfaceBuilder {
    [super prepareForInterfaceBuilder];
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor blackColor].CGColor;
}
@end
