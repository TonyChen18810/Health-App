//
//  TestParameterCell.h
//  HealthZip
//
//  Created by Tristate on 6/1/16.
//  Copyright © 2016 Tristate. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddTestParameterDelegate <NSObject>
-(void)getTestValue:(id)obj;

@end

@interface TestParameterCell : UITableViewCell<UITextFieldDelegate>
@property (nonatomic) float minVal;
@property (nonatomic) float maxVal;
@property (weak, nonatomic) IBOutlet UILabel *lblParameterName;
@property (weak, nonatomic) IBOutlet UILabel *lblNormalValue;
@property (weak, nonatomic) IBOutlet UILabel *lblValueUnit;
@property (nonatomic) id delegate;
@property (weak, nonatomic) IBOutlet UITextField *txtTestValue;


@end
