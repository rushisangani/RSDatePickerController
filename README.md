# RSDatePickerController

The convinient control to show **UIDatePicker** for Date and Time selection.
RSDatePickerController can be used to show Date Picker or Time Picker from any View/ViewController.


![Alt text](/Images/datepicker.png?raw=true "Date Picker")       ![Alt text](/Images/timepicker.png?raw=true "Time Picker")


## Features

- Show Date/Time Picker as a ViewController in iPhone and as a PopOverController in iPad.
- Specify any Date/Time format to get selected date or time in secified format.
- Specify Maximum and Minimum date to control DatePicker behaviour.
- Automatic dimiss on Tap outside.
- Reset, Done buttons along with Title are visible in the toolbar which is attched to DatePickerView.

## How To Use

### Show DatePicker

```objective-c
[[RSDatePickerController sharedInstance] showDatePickerWithDate:nil dateFormat:nil fromView:sender inViewController:self];
```

### Show TimePicker

```objective-c
[[RSDatePickerController sharedInstance] showTimePickerWithDate:nil dateFormat:nil fromView:sender inViewController:self];
```

### Show DatePicker from UITextField

```objective-c

[textField addTarget:self action:@selector(openDatePicker:) forControlEvents:UIControlEventTouchDown];

/* Disable textfield editing */
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}

-(void)openDatePicker:(id)sender {    
    [[RSDatePickerController sharedInstance] showDatePickerWithDate:nil dateFormat:nil fromView:sender inViewController:self];
}
```

### Get Date in specified format

```objective-c
[[RSDatePickerController sharedInstance] showDatePickerWithDate:nil dateFormat:@"MMM dd yyyy" minimumDate:[NSDate date] maximumDate:nil fromView:sender inViewController:self];
```

```objective-c
#pragma mark- RSDatePickerDelegate methods

- (void)didSelectDate:(NSDate *)date dateString:(NSString *)dateString forView:(id)view {
   
   // Get date and date as string in specified format
}
```

## License

RSDatePickerController is released under the MIT license. See LICENSE for details.
