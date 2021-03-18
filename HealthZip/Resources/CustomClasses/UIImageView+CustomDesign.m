//
//  UIImageView+CustomDesign.m
//  iDeals
//
//  Created by Pragnesh Dixit on 09/02/16.
//  Copyright © 2016 Pragnesh Dixit. All rights reserved.
//

#import "UIImageView+CustomDesign.h"

@implementation UIImageView_CustomDesign
@synthesize cornerRadius;
@synthesize borderWidth;
@synthesize topLeftcornerRadius,topRightcornerRadius;
@synthesize bottomLeftcornerRadius,bottomRightcornerRadius;
@synthesize borderColor;

-(void)awakeFromNib{
    [super awakeFromNib];
    self.layer.cornerRadius = self.cornerRadius;
    self.layer.borderWidth = self.borderWidth;
    self.layer.borderColor = self.borderColor.CGColor;
    self.layer.masksToBounds = true;
    if (topLeftcornerRadius || topRightcornerRadius || bottomLeftcornerRadius || bottomRightcornerRadius)
    {
        [self cornerRadiusOfView];
    }
}

-(void)cornerRadiusOfView
{
    CGFloat radius = 0;
    UIRectCorner corner = 0; //holds the corner
    //Determine which corner(s) should be changed
    if (topLeftcornerRadius) {
        corner = corner | UIRectCornerTopLeft;
        radius = topLeftcornerRadius;
    }
    if (topRightcornerRadius) {
        corner = corner | UIRectCornerTopRight;
        radius = topRightcornerRadius;
    }
    if (bottomLeftcornerRadius) {
        corner = corner | UIRectCornerBottomLeft;
        radius = bottomLeftcornerRadius;
    }
    if (bottomRightcornerRadius) {
        corner = corner | UIRectCornerBottomRight;
        radius = bottomRightcornerRadius;
    }
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    
}

@end
