//
//  UITextField+CustomDesign.h
//  iDeals
//
//  Created by Pragnesh Dixit on 09/02/16.
//  Copyright © 2016 Pragnesh Dixit. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface UITextField_CustomDesign : UITextField


@property (nonatomic,strong)IBInspectable UIColor *placeholderTextColor;
@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (nonatomic) IBInspectable UIColor* borderColor;
@property (nonatomic) IBInspectable CGFloat cornerRadius;
@end
