//
//  UIButtonCustom.m
//  WHEREZZIT
//
//  Created by Pragnesh Dixit on 16/10/15.
//  Copyright © 2015 Pragnesh Dixit. All rights reserved.
//

#import "UIButtonCustom.h"

@implementation UIButtonCustom
@synthesize cornerRadius;
@synthesize borderWidth;

@synthesize borderColor;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
*/

- (void)drawRect:(CGRect)rect {
   
    self.layer.cornerRadius = cornerRadius;
    self.layer.borderWidth = borderWidth;
    self.layer.borderColor = borderColor.CGColor;
    self.layer.masksToBounds = true;

}


@end
