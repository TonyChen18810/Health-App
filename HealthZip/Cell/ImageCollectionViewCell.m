//
//  ImageCollectionViewCell.m
//  OneTrackHealth
//
//  Created by Pragnesh Dixit on 01/09/17.
//  Copyright © 2017 Tristate. All rights reserved.
//

#import "ImageCollectionViewCell.h"
#import "Constants.h"
@implementation ImageCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.lblStap2.layer.borderColor = [UIColor whiteColor].CGColor;
    self.lblStap2.layer.borderWidth = 1;
    self.lblStap4.text = @"Click on test semi-circle to see \n blood test details graphed over time";
    self.lblStep6.text = @"Scroll easily between\ndifferent profiles";
    self.viewalertBg.layer.cornerRadius = 5;
    [self.lblStep10 shine];
    [self fadeIn:self.viewStap1 withDuration:.2 andWait:1.0];
    
    if (IS_IPHONE_4_OR_LESS) {
        self.conStep1Top.constant = 20;
        self.conStep2Top.constant = 5;
        self.conStep3Top.constant = -10;
        self.conStep4Top.constant = 35;
        self.conStep4Left.constant = 5;
        self.conStep5Top.constant = 55;
        self.conStep6Top.constant = 40;
        self.conStep9Top.constant = 70;
    }else if (IS_IPHONE_6) {
        self.conStep1Top.constant = 35;
        self.conStep2Top.constant = 22;
        self.conStep3Top.constant = 10;
        self.conStep4Top.constant = 115;
        self.conStep4Left.constant = 25;
        self.conStep5Top.constant = 100;
        self.conStep6Top.constant = 60;
        self.conStep9Top.constant = 130;
        
    } else if (IS_IPHONE_6P) {
        self.conStep1Top.constant = 35;
        self.conStep2Top.constant = 40;
        self.conStep3Top.constant = 20;
        self.conStep4Top.constant = 135;
        self.conStep4Left.constant = 45;
        self.conStep5Top.constant = 110;
        self.conStep6Top.constant = 70;
        self.conStep9Top.constant = 150;
    }
}
-(void) fadeIn:(UIView*)viewToFadeIn withDuration:(NSTimeInterval)duration andWait:(NSTimeInterval)wait

{
    [UIView beginAnimations: @"Fade In" context:nil];
    
    // wait for time before begin
    [UIView setAnimationDelay:wait];
    
    // druation of animation
    [UIView setAnimationDuration:duration];
    viewToFadeIn.alpha = 1;
    [UIView commitAnimations];
    
}
@end
