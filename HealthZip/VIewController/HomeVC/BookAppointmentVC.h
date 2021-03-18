//
//  BookAppointmentVC.h
//  OneTrackHealth
//
//  Created by Pragnesh Dixit on 09/08/17.
//  Copyright © 2017 Tristate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZTextView.h"
#import "BaseViewController.h"
#import "Webservice.h"
#import "UserDetail.h"
#import "BlogDetail.h"
#import <EventKit/EventKit.h>

@protocol BookAppointmetnDelegate<NSObject>
-(void)btnBookAppointmentGetData:(NSArray *)arrBook;
@end
@class AbstractActionSheetPicker;
@interface BookAppointmentVC : BaseViewController
{
    UserDetail *objUserDetail;
}
- (IBAction)btnBackAction:(id)sender;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *arrViewBorder;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UIButton *btnBookAppointmnt;
- (IBAction)btnBookAppointmntAction:(id)sender;
@property (strong, nonatomic) id <BookAppointmetnDelegate> delegate;

@property (weak, nonatomic) IBOutlet SZTextView *txtMessage;
@property (weak, nonatomic) IBOutlet SZTextView *txtPostalAdress;
@property (weak, nonatomic) IBOutlet UITextField *txtDate;
@property (weak, nonatomic) IBOutlet UITextField *txtTime;
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, strong) NSDate *selectedTime;
@property (nonatomic, strong) AbstractActionSheetPicker *actionSheetPicker;

@property (strong, nonatomic) IBOutlet UIToolbar *toolbarView;
- (IBAction)btnDoneTextViewAction:(id)sender;

// The database with calendar events and reminders
@property (strong, nonatomic) EKEventStore *eventStore;

// Indicates whether app has access to event store.
@property (nonatomic) BOOL isAccessToEventStoreGranted;

@property (strong, nonatomic) EKCalendar *calendar;


@end
