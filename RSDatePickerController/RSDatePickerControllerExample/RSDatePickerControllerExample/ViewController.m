//
//  ViewController.m
//  RSDatePickerControllerExample
//
//  Created by Rushi Sangani on 12/06/16.
//  Copyright © 2016 Rushi Sangani. All rights reserved.
//

#import "ViewController.h"
#import "RSDatePickerController.h"

@interface ViewController () <RSDatePickerDelegate, UITextFieldDelegate>

- (IBAction)dateButtonClicked:(id)sender;
- (IBAction)timeButtonClicked:(id)sender;
- (IBAction)textFieldTapped:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

#pragma mark- RSDatePickerDelegate methods

- (void)didSelectDate:(NSDate *)date dateString:(NSString *)dateString forView:(id)view {
    
    if(view == self.btnDate){
        [self.btnDate setTitle:dateString forState:UIControlStateNormal];
    }
    else if (view == self.btnTime){
        [self.btnTime setTitle:dateString forState:UIControlStateNormal];
    }
    else if (view == self.txtSelectDate){
        self.txtSelectDate.text = dateString;
    }
}

#pragma mark- UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}

- (IBAction)dateButtonClicked:(id)sender {
    
    [[RSDatePickerController sharedInstance] showDatePickerWithDate:nil dateFormat:nil fromView:sender inViewController:self];
}

- (IBAction)timeButtonClicked:(id)sender {
    
    [[RSDatePickerController sharedInstance] showTimePickerWithDate:nil dateFormat:nil fromView:sender inViewController:self];
}

- (IBAction)textFieldTapped:(id)sender {
    
    [[RSDatePickerController sharedInstance] showDatePickerWithDate:nil dateFormat:@"MMM dd yyyy" minimumDate:[NSDate date] maximumDate:nil fromView:sender inViewController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
