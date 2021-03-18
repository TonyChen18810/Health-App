//
//  UIImageView+CustomDesign.h
//  iDeals
//
//  Created by Pragnesh Dixit on 09/02/16.
//  Copyright © 2016 Pragnesh Dixit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView_CustomDesign : UIImageView
@property (nonatomic) IBInspectable NSInteger borderWidth;
@property (nonatomic) IBInspectable UIColor* borderColor;
@property (nonatomic) IBInspectable CGFloat cornerRadius;
@property (nonatomic) IBInspectable CGFloat topLeftcornerRadius;
@property (nonatomic) IBInspectable CGFloat topRightcornerRadius;
@property (nonatomic) IBInspectable CGFloat bottomLeftcornerRadius;
@property (nonatomic) IBInspectable CGFloat bottomRightcornerRadius;
@end
