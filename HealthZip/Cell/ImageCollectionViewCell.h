//
//  ImageCollectionViewCell.h
//  OneTrackHealth
//
//  Created by Pragnesh Dixit on 01/09/17.
//  Copyright © 2017 Tristate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RQShineLabel.h"
@interface ImageCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgViewPic;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *lblStep6;
@property (weak, nonatomic) IBOutlet UILabel *lblStap2;
@property (weak, nonatomic) IBOutlet RQShineLabel *lblStep10;
@property (weak, nonatomic) IBOutlet UILabel *lblStap4;
@property (weak, nonatomic) IBOutlet UIView *viewalertBg;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *arrViewScreen;

@property (weak, nonatomic) IBOutlet UIView *viewStap1;
@property (weak, nonatomic) IBOutlet UIView *viewStap2;
@property (weak, nonatomic) IBOutlet UIView *viewStap3;
@property (weak, nonatomic) IBOutlet UIView *viewStap4;
@property (weak, nonatomic) IBOutlet UIView *viewStap5;
@property (weak, nonatomic) IBOutlet UIView *viewStap6;
@property (weak, nonatomic) IBOutlet UIView *viewStap7;
@property (weak, nonatomic) IBOutlet UIView *viewStap8;
@property (weak, nonatomic) IBOutlet UIView *viewStap9;
@property (weak, nonatomic) IBOutlet UIView *viewStap10;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conStep1Top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conStep2Top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conStep3Top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conStep4Top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conStep5Top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conStep6Top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conStep4Left;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conStep9Top;

@end
