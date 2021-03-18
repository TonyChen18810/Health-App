//
//  BookAppointmentVC.m
//  OneTrackHealth
//
//  Created by Pragnesh Dixit on 09/08/17.
//  Copyright © 2017 Tristate. All rights reserved.
//

#import "BookAppointmentVC.h"
#import "ActionSheetPicker.h"
#import "NSDate+TCUtils.h"

@interface BookAppointmentVC ()

@end

@implementation BookAppointmentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"> > > > > > > > > > > >%@ > > > > > > > > >",NSStringFromClass([self class]));
    
    objUserDetail=[UserDetail sharedInstance];
    objUserDetail=[objUserDetail getDetail];
    
    // Do any additional setup after loading the view.
    for (UIView *viewTemp in self.arrViewBorder) {
        
        viewTemp.layer.borderColor = [UIColor lightGrayColor].CGColor;
        viewTemp.layer.borderWidth = 1.0;
        viewTemp.layer.cornerRadius = 2.0;
        viewTemp.layer.masksToBounds = true;
    }
    self.btnBookAppointmnt.layer.cornerRadius=2.0;
    [self.txtMessage setInputAccessoryView:self.toolbarView];
    [self.txtPostalAdress setInputAccessoryView:self.toolbarView];
    self.selectedDate = [NSDate date];
    self.selectedTime = [NSDate date];
    
    [self updateAuthorizationStatusToAccessEventStore];
    [self updateAuthorizationStatusToAccessEventStoreReminder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)btnBackAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)addReminder {
    EKEventStore *store = [EKEventStore new];
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if (!granted) { return; }
        EKEvent *event = [EKEvent eventWithEventStore:store];
        dispatch_async(dispatch_get_main_queue(), ^{
            event.title = self.txtName.text;
            event.notes = self.txtMessage.text;
        });
        event.startDate = self.selectedDate; //today
        event.endDate = [event.startDate dateByAddingTimeInterval:60*60];  //set 1 hour meeting
        event.calendar = [store defaultCalendarForNewEvents];
        
        NSTimeInterval aInterval = -3600;
        EKAlarm *alaram = [EKAlarm alarmWithRelativeOffset:aInterval];
        [event addAlarm:alaram];
        
        NSError *err = nil;
        [store saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
        NSString *savedEventId = event.eventIdentifier;  //save the event id if you want to access this later
        NSLog(@"%@",savedEventId);
        [self addReminderForToDoItem];
        
    }];
}

- (void)apiCallForBookAppointment {
    if ([self isNetworkReachable]) {
        [self showSpinnerWithUserActionEnable:false];
        NSTimeInterval interval  = [self.selectedDate timeIntervalSince1970] ;
        NSString *strBookTime = [NSString stringWithFormat:@"%d",(int)interval];
        
        Webservice *webserviceObj = [[Webservice alloc]init];
        NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
        [dictParam setObject:strBookTime forKey:@"appointment_time"];
        [dictParam setObject:self.txtName.text forKey:@"title"];
        [dictParam setObject:self.txtMessage.text forKey:@"description"];
        [dictParam setObject:self.txtPostalAdress.text forKey:@"postal_address"];
        
        [dictParam setObject:SAFESTRING([objUserDetail.str_user_id trimSpaces]) forKey:@"user_id"];
        [webserviceObj callJSONMethod:@"book_appointment" withParameters:dictParam isEncrpyted:NO onSuccessfulResponse:^(NSMutableDictionary *dict) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideSpinner];
                NSString *strMsg=[dict valueForKey:@"message"];
                
                if ([[dict valueForKey:@"status"] integerValue] == 1 ) {
                    NSArray *arrayList=[BlogDetail initWithArrayBookAppointment:[dict valueForKey:@"data"] ];
                    if ([self->_delegate respondsToSelector:@selector(btnBookAppointmentGetData:)]) {
                        [self->_delegate btnBookAppointmentGetData:arrayList];
                    }
                    [self addReminder];
                } else{
                    [UIAlertController infoAlertWithMessage:strMsg andTitle:APPNAME controller:self];
                }
            });
        } onFailure:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIAlertController infoAlertWithMessage:[error localizedDescription] andTitle:APPNAME controller:self];
                [self hideSpinner];
            });
        }];
    }
    else{
        [UIAlertController infoAlertWithMessage:ALERT_NO_INTERNET andTitle:APPNAME controller:self];
    }
}

- (IBAction)btnBookAppointmntAction:(id)sender {
    
    if ([self validateTextField]==YES) {
        [self apiCallForBookAppointment];
    }
}
// 1
- (EKEventStore *)eventStore {
    if (!_eventStore) {
        _eventStore = [[EKEventStore alloc] init];
    }
    return _eventStore;
}

- (EKCalendar *)calendar {
    if (!_calendar) {
        
        // 1
        NSArray *calendars = [self.eventStore calendarsForEntityType:EKEntityTypeReminder];
        
        // 2
        NSString *calendarTitle = APPNAME;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title matches %@", calendarTitle];
        NSArray *filtered = [calendars filteredArrayUsingPredicate:predicate];
        
        if ([filtered count]) {
            _calendar = [filtered firstObject];
        } else {
            
            // 3
            _calendar = [EKCalendar calendarForEntityType:EKEntityTypeReminder eventStore:self.eventStore];
            _calendar.title = APPNAME;
            _calendar.source = self.eventStore.defaultCalendarForNewReminders.source;
            
            // 4
            NSError *calendarErr = nil;
            BOOL calendarSuccess = [self.eventStore saveCalendar:_calendar commit:YES error:&calendarErr];
            if (!calendarSuccess) {
                // Handle error
            }
        }
    }
    return _calendar;
}
- (IBAction)btnDoneTextViewAction:(id)sender {
    [self.view endEditing:YES];
}
#pragma mark TEXTFIELD DELEGATE METHODS

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self.view endEditing:YES];
    id sender=textField;
    if (textField == self.txtDate) {
        //        _actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@"" datePickerMode:UIDatePickerModeDate selectedDate:self.selectedDate target:self action:@selector(dateWasSelected:element:) origin:sender];
        
        self.actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@"Select a Date" datePickerMode:UIDatePickerModeDate selectedDate:self.selectedDate minimumDate:[NSDate date] maximumDate:nil target:self action:@selector(dateWasSelected:element:) origin:sender];
        
        [self.actionSheetPicker addCustomButtonWithTitle:@"Today" value:[NSDate date]];
        self.actionSheetPicker.hideCancel = YES;
        [self.actionSheetPicker showActionSheetPicker];
        
        float slidePoint = 0.0f;
        float keyBoard_Y_Origin = self.view.bounds.size.height - 320.0f;
        float textFieldButtomPoint = textField.superview.frame.origin.y + (textField.frame.origin.y + textField.frame.size.height);
        if (keyBoard_Y_Origin < textFieldButtomPoint - self.scrollview.contentOffset.y) {
            slidePoint = textFieldButtomPoint - keyBoard_Y_Origin + 10.0f;
            //            CGPoint point = CGPointMake(0.0f, slidePoint);
            //            self.scrollview.contentOffset = point;
            [self.scrollview setContentOffset:CGPointMake(0.0f, slidePoint) animated:YES];
        }
        
        return NO;
    }else if (textField == self.txtTime ) {
        NSInteger minuteInterval = 5;
        //clamp date
        NSInteger referenceTimeInterval = (NSInteger)[self.selectedDate timeIntervalSinceReferenceDate];
        NSInteger remainingSeconds = referenceTimeInterval % (minuteInterval *60);
        NSInteger timeRoundedTo5Minutes = referenceTimeInterval - remainingSeconds;
        if(remainingSeconds>((minuteInterval*60)/2)) {/// round up
            timeRoundedTo5Minutes = referenceTimeInterval +((minuteInterval*60)-remainingSeconds);
        }
        self.selectedTime = [NSDate dateWithTimeIntervalSinceReferenceDate:(NSTimeInterval)timeRoundedTo5Minutes];
        ActionSheetDatePicker *datePicker = [[ActionSheetDatePicker alloc] initWithTitle:@"Select a time" datePickerMode:UIDatePickerModeTime selectedDate:self.selectedDate minimumDate:[NSDate date] maximumDate:nil target:self action:@selector(timeWasSelected:element:) origin:sender];
        datePicker.minuteInterval = minuteInterval;
        [datePicker showActionSheetPicker];
        
        float slidePoint = 0.0f;
        float keyBoard_Y_Origin = self.view.bounds.size.height - 320.0f;
        float textFieldButtomPoint = textField.superview.frame.origin.y + (textField.frame.origin.y + textField.frame.size.height);
        if (keyBoard_Y_Origin < textFieldButtomPoint - self.scrollview.contentOffset.y) {
            slidePoint = textFieldButtomPoint - keyBoard_Y_Origin + 10.0f;
            //            CGPoint point = CGPointMake(0.0f, slidePoint);
            //            self.scrollview.contentOffset = point;
            [self.scrollview setContentOffset:CGPointMake(0.0f, slidePoint) animated:YES];
        }
        return NO;
    }else{
        return YES;
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)dateWasSelected:(NSDate *)selectedDate element:(id)element {
    self.selectedDate = selectedDate;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    self.txtDate.text = [dateFormatter stringFromDate:selectedDate];
    
    [self.scrollview setContentOffset:CGPointMake(0.0f, 0.0f) animated:YES];
}

-(void)timeWasSelected:(NSDate *)selectedTime element:(id)element {
    self.selectedTime = selectedTime;
    self.selectedDate = selectedTime;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"h:mm a"];
    self.txtTime.text = [dateFormatter stringFromDate:selectedTime];
//    CGPoint point = CGPointMake(0.0f, 0.0f);
//    self.scrollview.contentOffset = point;
    [self.scrollview setContentOffset:CGPointMake(0.0f, 0.0f) animated:YES];
}
-(BOOL)validateTextField
{
    if ([self.txtName.text trimSpaces].length == 0) {
        [UIAlertController infoAlertWithMessage:@"Please enter name of appointment." andTitle:APPNAME controller:self];
        return NO;
    }
    else if ([self.txtDate.text trimSpaces].length == 0) {
        [UIAlertController infoAlertWithMessage:@"Please enter Date." andTitle:APPNAME controller:self];
        return NO;
    }
    else if ([self.txtTime.text trimSpaces].length == 0) {
        [UIAlertController infoAlertWithMessage:@"Please enter Time." andTitle:APPNAME controller:self];
        return NO;
    }else if ([self.txtMessage.text trimSpaces].length == 0) {
        [UIAlertController infoAlertWithMessage:@"Please enter any Message." andTitle:APPNAME controller:self];
        return NO;
    }else{
        return YES;
    }
}
#pragma mark - Reminders

- (void)updateAuthorizationStatusToAccessEventStoreReminder {
    // 2
    EKAuthorizationStatus authorizationStatus = [EKEventStore authorizationStatusForEntityType:EKEntityTypeReminder];
    
    switch (authorizationStatus) {
            // 3
        case EKAuthorizationStatusDenied:
        case EKAuthorizationStatusRestricted: {
            self.isAccessToEventStoreGranted = NO;
            [UIAlertController infoAlertWithMessageWithCancel:@"This app doesn't have access to your Reminders." andTitle:@"Access Denied" controller:self buttonTitle:@"DISMISS"];
            break;
        }
            
            // 4
        case EKAuthorizationStatusAuthorized:
            self.isAccessToEventStoreGranted = YES;
            break;
            
            // 5
        case EKAuthorizationStatusNotDetermined: {
          
            [self.eventStore requestAccessToEntityType:EKEntityTypeReminder
                                            completion:^(BOOL granted, NSError *error) {
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    self.isAccessToEventStoreGranted = YES;
                                                });
                                            }];
            break;
        }
    }
}
- (void)updateAuthorizationStatusToAccessEventStore {
    // 2
    EKAuthorizationStatus authorizationStatus = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    
    switch (authorizationStatus) {
            // 3
        case EKAuthorizationStatusDenied:
        case EKAuthorizationStatusRestricted: {
            self.isAccessToEventStoreGranted = NO;
            [UIAlertController infoAlertWithMessageWithCancel:@"This app doesn't have access to your Reminders." andTitle:@"Access Denied" controller:self buttonTitle:@"DISMISS"];
            break;
        }
            // 4
        case EKAuthorizationStatusAuthorized:
            self.isAccessToEventStoreGranted = YES;
            break;
            
            // 5
        case EKAuthorizationStatusNotDetermined: {
            
            [self.eventStore requestAccessToEntityType:EKEntityTypeEvent
                                            completion:^(BOOL granted, NSError *error) {
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    self.isAccessToEventStoreGranted = YES;
                                                });
                                            }];
            break;
        }
    }
}

- (void)addReminderForToDoItem {
    // 1
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self.isAccessToEventStoreGranted){
            [self updateAuthorizationStatusToAccessEventStore];
            [self updateAuthorizationStatusToAccessEventStoreReminder];
            return;
        }
    });
    
    
    // 2
    EKReminder *reminder = [EKReminder reminderWithEventStore:self.eventStore];
    dispatch_async(dispatch_get_main_queue(), ^{
        reminder.title = self.txtName.text;
        reminder.notes=self.txtMessage.text;
    });
    reminder.calendar = self.calendar;
    reminder.dueDateComponents = [self dateComponentsForDefaultDueDate];
    
    // 3
    NSError *error = nil;
    BOOL success = [self.eventStore saveReminder:reminder commit:YES error:&error];
    if (!success) {
        // Handle error.
        
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    }
}
- (NSDateComponents *)dateComponentsForDefaultDueDate {
    NSDateComponents *oneDayComponents = [[NSDateComponents alloc] init];
    oneDayComponents.day = 0;
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *tomorrow = [gregorianCalendar dateByAddingComponents:oneDayComponents toDate:self.selectedDate options:0];
    
    NSUInteger unitFlags = NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *tomorrowAt4PM = [gregorianCalendar components:unitFlags fromDate:tomorrow];
    
    NSDateComponents *components = [gregorianCalendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:self.selectedDate];
    
    tomorrowAt4PM.hour = [components hour];
    tomorrowAt4PM.minute = [components minute];
    tomorrowAt4PM.second = [components second];
    
    return tomorrowAt4PM;
}
@end
