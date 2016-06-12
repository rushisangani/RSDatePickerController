//
//  RSDatePickerController.m
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

#define kDatePickerBackgroundColor [UIColor colorWithRed:(239/255.f) green:(239/255.f) blue:(241/255.f) alpha:1]

#import "RSDatePickerController.h"

static CGFloat kDefaultDatePickerHeight = 216;
static CGFloat kDefaultToolBarHeight = 44;
static CGFloat kDefaultPopOverWidth = 340;

static NSString *kSourceViewNilMessage  =   @"SourceView can not be nil";


@interface RSDatePickerController ()<UIPopoverPresentationControllerDelegate>

@property (nonatomic, strong) UIView *backGroundView;           // transparent background View

@property (nonatomic, strong) UIDatePicker    *datePicker;      // date picker view
@property (nonatomic, assign) UIDatePickerMode datepickerMode;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;   // date formatter

/* Tool bar objects */
@property (nonatomic, strong) UIToolbar         *toolBar;
@property (nonatomic, strong) UIBarButtonItem   *doneButton;
@property (nonatomic, strong) UIBarButtonItem   *resetButton;
@property (nonatomic, strong) UILabel           *titleLabel;
@property (nonatomic, strong) UIBarButtonItem   *flexibleSpace;

@end

@implementation RSDatePickerController

#pragma mark - Singleton instance

+(instancetype)sharedInstance {
    
    RSDatePickerController *_sharedInstance;
    if(!_sharedInstance){
        _sharedInstance = [[self alloc] init];
    }
    return _sharedInstance;
}

#pragma mark- Life Cycle

- (instancetype)init {
    self = [super init];
    
    if(self){
        [self initialize];
    }
    return self;
}

-(void)initialize {
    
    self.datepickerMode = UIDatePickerModeDate;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        self.modalPresentationStyle = UIModalPresentationPopover;
        self.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
        self.popoverPresentationController.delegate = self;
    }
    else{
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
}

#pragma mark- Methods

-(instancetype)showDatePickerWithDate:(NSDate *)date dateFormat:(NSString *)dateFormat minimumDate:(NSDate *)minimumDate maximumDate:(NSDate *)maximumDate fromView:(id)sourceView inViewController:(UIViewController *)viewController {
    
    self.minimumDate = minimumDate;
    self.maximumDate = maximumDate;
    
   return [self showDatePickerWithDate:date dateFormat:dateFormat fromView:sourceView inViewController:viewController];
}

-(instancetype)showTimePickerWithDate:(NSDate *)date dateFormat:(NSString *)dateFormat fromView:(id)sourceView inViewController:(UIViewController *)viewController {
    
    self.datepickerMode = UIDatePickerModeTime;
    return [self showDatePickerWithDate:date dateFormat:dateFormat fromView:sourceView inViewController:viewController];
}

-(instancetype)showDatePickerWithDate:(NSDate *)date dateFormat:(NSString *)dateFormat fromView:(id)sourceView inViewController:(id)viewController {
    
    self.date = date;
    self.dateFormat = dateFormat;
    self.sourceView = sourceView;
    self.delegate = viewController;
    
    [self setupLayout];
    
    // present controller
    [viewController presentViewController:self animated:NO completion:nil];
    
    return self;
}

-(void)setupLayout {
    
    // add background view
    [self.view insertSubview:self.backGroundView atIndex:0];
    
    // create date picker and add to view
    [self.view addSubview:self.datePicker];
    
    // create tool bar with BarButtonItems and add to view
    
    UIBarButtonItem *labelButton = [[UIBarButtonItem alloc] initWithCustomView:self.titleLabel];
    NSArray *buttons = @[self.resetButton, self.flexibleSpace, labelButton, self.flexibleSpace, self.doneButton];
    
    [self.toolBar setItems:buttons];
    [self.view addSubview:self.toolBar];
}

#pragma mark- UIPopoverPresentationControllerDelegate

-(void)prepareForPopoverPresentation:(UIPopoverPresentationController *)popoverPresentationController {
    
    NSAssert(self.sourceView, kSourceViewNilMessage);

    self.preferredContentSize = CGSizeMake(kDefaultPopOverWidth, kDefaultDatePickerHeight + kDefaultToolBarHeight);
    
    popoverPresentationController.sourceView = self.sourceView;
    popoverPresentationController.sourceRect = CGRectMake(0, 0, ((UIView *)self.sourceView).frame.size.width, ((UIView *)self.sourceView).frame.size.height);
}

#pragma mark- Actions

-(void)dateChanged:(UIDatePicker *)datePicker {
    self.date = datePicker.date;
    self.titleLabel.text = [self.dateFormatter stringFromDate:self.date];
}

-(void)doneButtonClicked:(id)sender {
    
    NSString *dateString = [self.dateFormatter stringFromDate:self.date];
    
    if([self.delegate respondsToSelector:@selector(didSelectDate:dateString:forView:)]){
        [self.delegate didSelectDate:self.date dateString:dateString forView:self.sourceView];
    }
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)resetButtonClicked:(id)sender {
    
    if([self.delegate respondsToSelector:@selector(didSelectDate:dateString:forView:)]){
        [self.delegate didSelectDate:nil dateString:@"" forView:self.sourceView];
    }
    
    self.date = nil;
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)backgroundViewTapped:(UITapGestureRecognizer *)gestureRecognizer {
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark- Custom methods

-(CGRect)frameForToolBar {
    
    CGRect datePickerFrame = [self frameForDatePicker];
    return CGRectMake(0, datePickerFrame.origin.y - kDefaultToolBarHeight, datePickerFrame.size.width, kDefaultToolBarHeight);
}

-(CGRect)frameForDatePicker {
    
    CGFloat y = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? kDefaultToolBarHeight : self.view.bounds.size.height - kDefaultDatePickerHeight;
    return CGRectMake(0, y, self.view.frame.size.width, kDefaultDatePickerHeight);
}

#pragma mark- Getter

-(UIView *)backGroundView {
    
    if(!_backGroundView){
        
        _backGroundView = [[UIView alloc] init];
        _backGroundView.frame = self.view.bounds;
        _backGroundView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewTapped:)];
        [_backGroundView addGestureRecognizer:tapGesture];
        
    }
    return _backGroundView;
}

-(UIDatePicker *)datePicker {
    
    if(!_datePicker){
        
        _datePicker = [[UIDatePicker alloc]init];
        _datePicker.datePickerMode = self.datepickerMode;
        _datePicker.frame = [self frameForDatePicker];
        _datePicker.date = self.date;
        _datePicker.backgroundColor = kDatePickerBackgroundColor;
        _datePicker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [_datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _datePicker;
}

-(UIToolbar *)toolBar {
    
    if(!_toolBar){
        
        _toolBar = [[UIToolbar alloc] init];
        _toolBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _toolBar.frame = [self frameForToolBar];
        _toolBar.backgroundColor = [UIColor lightGrayColor];
        _toolBar.translucent = YES;
    }
    return _toolBar;
}

-(NSDate *)date {
    
    if(!_date){
        _date = [NSDate date];
    }
    return _date;
}

-(NSString *)dateFormat {
    
    if(!_dateFormat){
        _dateFormat = (self.datepickerMode == UIDatePickerModeDate) ?  @"dd MMM yyyy" : @"hh:mm a";
    }
    return _dateFormat;
}

-(NSDateFormatter *)dateFormatter {
    
    if(!_dateFormatter){
        
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:self.dateFormat];
    }
    return _dateFormatter;
}

-(UIBarButtonItem *)doneButton {
    
    if(!_doneButton){
        _doneButton = [[UIBarButtonItem alloc] initWithTitle:@" Done " style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonClicked:)];
        _doneButton.tintColor = [UIColor darkTextColor];
    }
    return _doneButton;
}

-(UIBarButtonItem *)resetButton {
    
    if(!_resetButton){
        _resetButton = [[UIBarButtonItem alloc] initWithTitle:@" Reset " style:UIBarButtonItemStyleDone target:self action:@selector(resetButtonClicked:)];
        _resetButton.tintColor = [UIColor darkTextColor];
    }
    return _resetButton;
}

-(UILabel *)titleLabel {
    
    if(!_titleLabel){
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, kDefaultToolBarHeight)];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor darkGrayColor];
        _titleLabel.text = [self.dateFormatter stringFromDate:self.date];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

-(UIBarButtonItem *)flexibleSpace {
    
    if(!_flexibleSpace){
        _flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    }
    return _flexibleSpace;
}

#pragma mark- Setter

-(void)setMinimumDate:(NSDate *)minimumDate {
    
    _minimumDate = minimumDate;
    self.datePicker.minimumDate = minimumDate;
}

-(void)setMaximumDate:(NSDate *)maximumDate {
    
    _maximumDate = maximumDate;
    self.datePicker.maximumDate = maximumDate;
}

@end
