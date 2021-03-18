//
//  HealthBlogCell.h
//  HealthZip
//
//  Created by Tristate on 6/14/16.
//  Copyright © 2016 Tristate. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HealthBlogCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UIButton *btnRightArrow;
@property (weak, nonatomic) IBOutlet UIImageView *ivBlog;

@end
