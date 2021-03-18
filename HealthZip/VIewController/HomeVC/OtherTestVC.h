//
//  OtherTestVC.h
//  OneTrackHealth
//
//  Created by Tristate on 6/19/19.
//  Copyright © 2019 Tristate. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OtherTestVC : UIViewController

@property (weak,nonatomic) IBOutlet UILabel *lblOtherTest;
@property (weak,nonatomic) IBOutlet UIButton *btnBack;


- (IBAction)btnBack :(id)sender;

@end

NS_ASSUME_NONNULL_END
