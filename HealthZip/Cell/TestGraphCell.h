//
//  TestGraphCell.h
//  HealthZip
//
//  Created by Tristate on 6/13/16.
//  Copyright © 2016 Tristate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBCircularProgressBarView.h"

@interface TestGraphCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet MBCircularProgressBarView *viewGraph;
@property (weak, nonatomic) IBOutlet UILabel *lblDetail;
@property (weak, nonatomic) IBOutlet UILabel *lblTestName;

@end
