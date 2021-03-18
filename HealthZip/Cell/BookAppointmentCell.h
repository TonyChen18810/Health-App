//
//  BookAppointmentCell.h
//  OneTrackHealth
//
//  Created by Pragnesh Dixit on 09/08/17.
//  Copyright © 2017 Tristate. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookAppointmentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@end
