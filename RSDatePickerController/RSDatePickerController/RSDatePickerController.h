//
//  RSDatePickerController.h
//
// Copyright (c) Rushi Sangani.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <UIKit/UIKit.h>

@protocol RSDatePickerDelegate <NSObject>

-(void)didSelectDate:(NSDate *)date dateString:(NSString *)dateString forView:(id)view;

@end

@interface RSDatePickerController : UIViewController

@property (nonatomic, weak) id <RSDatePickerDelegate> delegate;     // delegate

@property (nonatomic, strong) id sourceView;           // specify source from where date picker will open

@property (nonatomic, strong) NSDate *date;            // specify date to be set when date picker opens, default will be current date

@property (nonatomic, strong) NSString *dateFormat;    // specify date format, default will be 'dd MMM yyyy'

@property (nonatomic, retain) NSDate *minimumDate;     // minimum date for date picker, optional

@property (nonatomic, retain) NSDate *maximumDate;     // maximum date for date picker, optional

/* singleton instance */

+(instancetype)sharedInstance;

/* global method to show date picker */

-(instancetype)showDatePickerWithDate:(NSDate *)date dateFormat:(NSString *)dateFormat fromView:(id)sourceView inViewController:(UIViewController *)viewController;

-(instancetype)showDatePickerWithDate:(NSDate *)date dateFormat:(NSString *)dateFormat minimumDate:(NSDate *)minimumDate maximumDate:(NSDate *)maximumDate fromView:(id)sourceView inViewController:(UIViewController *)viewController;

-(instancetype)showTimePickerWithDate:(NSDate *)date dateFormat:(NSString *)dateFormat fromView:(id)sourceView inViewController:(UIViewController *)viewController;

@end
