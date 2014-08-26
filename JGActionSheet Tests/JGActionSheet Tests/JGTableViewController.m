//
//  JGTableViewController.m
//  JGActionSheet Tests
//
//  Created by Jonas Gessner on 29.07.14.
//  Copyright (c) 2014 Jonas Gessner. All rights reserved.
//

#import "JGTableViewController.h"

#import "JGActionSheet.h"

@interface JGTableViewController () <JGActionSheetDelegate> {
    JGActionSheet *_currentAnchoredActionSheet;
    UIView *_anchorView;
    BOOL _anchorLeft;
    JGActionSheet *_simple;
}

@end

@implementation JGTableViewController

#ifndef kCFCoreFoundationVersionNumber_iOS_7_0
#define kCFCoreFoundationVersionNumber_iOS_7_0 838.00
#endif

#define iOS7 (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_7_0)
#define iPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#pragma mark - JGActionSheetDelegate

- (void)actionSheetWillPresent:(JGActionSheet *)actionSheet {
    NSLog(@"Action sheet %p will present", actionSheet);
}

- (void)actionSheetDidPresent:(JGActionSheet *)actionSheet {
    NSLog(@"Action sheet %p did present", actionSheet);
}

- (void)actionSheetWillDismiss:(JGActionSheet *)actionSheet {
    NSLog(@"Action sheet %p will dismiss", actionSheet);
    _currentAnchoredActionSheet = nil;
}

- (void)actionSheetDidDismiss:(JGActionSheet *)actionSheet {
    NSLog(@"Action sheet %p did dismiss", actionSheet);
}

#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"JGActionSheet";
    
    if ([self.tableView respondsToSelector:@selector(registerClass:forCellReuseIdentifier:)]) {
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    }
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Action" style:UIBarButtonItemStyleBordered target:self action:@selector(showFromBarButtonItem:withEvent:)];
}

- (void)showFromBarButtonItem:(UIBarButtonItem *)barButtonItem withEvent:(UIEvent *)event {
    UIView *view = [event.allTouches.anyObject view];
    
    JGActionSheetSection *section = [JGActionSheetSection sectionWithTitle:@"A Nice Title" message:@"Some message" buttonTitles:@[@"Destructive Button", @"Normal Button", @"Some Button"] buttonStyle:JGActionSheetButtonStyleDefault];
    
    [section setButtonStyle:JGActionSheetButtonStyleRed forButtonAtIndex:0];
    
    NSArray *sections = (iPad ? @[section] : @[section, [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"Cancel"] buttonStyle:JGActionSheetButtonStyleCancel]]);
    
    JGActionSheet *sheet = [[JGActionSheet alloc] initWithSections:sections];
    
    sheet.delegate = self;
    
    [sheet setButtonPressedBlock:^(JGActionSheet *sheet, NSIndexPath *indexPath) {
        [sheet dismissAnimated:YES];
    }];
    
    if (iPad) {
        [sheet setOutsidePressBlock:^(JGActionSheet *sheet) {
            [sheet dismissAnimated:YES];
        }];
        
        CGPoint point = (CGPoint){CGRectGetMidX(view.bounds), CGRectGetMaxY(view.bounds)};
        
        point = [self.navigationController.view convertPoint:point fromView:view];
        
        _currentAnchoredActionSheet = sheet;
        _anchorView = view;
        _anchorLeft = NO;
        
        [sheet showFromPoint:point inView:self.navigationController.view arrowDirection:JGActionSheetArrowDirectionTop animated:YES];
    }
    else {
        [sheet showInView:self.navigationController.view animated:YES];
    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if (!iOS7) {
        //Use this on iOS < 7 to prevent the UINavigationBar from overlapping your action sheet!
        [self.navigationController.view.superview bringSubviewToFront:self.navigationController.view];
    }
    
    if (_currentAnchoredActionSheet) {
        UIView *view = _anchorView;
        
        CGPoint point = (_anchorLeft ? (CGPoint){-5.0f, CGRectGetMidY(view.bounds)} : (CGPoint){CGRectGetMidX(view.bounds), CGRectGetMaxY(view.bounds)});
        
        point = [self.navigationController.view convertPoint:point fromView:view];
        
        [_currentAnchoredActionSheet moveToPoint:point arrowDirection:(_anchorLeft ? JGActionSheetArrowDirectionRight : JGActionSheetArrowDirectionTop) animated:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    if (!cell.accessoryView) {
        UIButton *accessory = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [accessory addTarget:self action:@selector(accessoryTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.accessoryView = accessory;
    }
    
    cell.accessoryView.tag = indexPath.row;
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Simple Action Sheet";
    }
    else if (indexPath.row == 1) {
        cell.textLabel.text = @"Multiple Sections";
    }
    else {
        cell.textLabel.text = @"Multiple Sections & Content View";
    }
    
    return cell;
}

- (void)accessoryTapped:(UIButton *)button {
    if (button.tag == 0) {
        [self showSimple:button];
    }
    else if (button.tag == 1) {
        [self multipleSections:button];
    }
    else {
        [self multipleAndContentView:button];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        [self showSimple:nil];
    }
    else if (indexPath.row == 1) {
        [self multipleSections:nil];
    }
    else {
        [self multipleAndContentView:nil];
    }
}

- (void)showSimple:(UIView *)anchor {
    //This is am example of an action sheet that is reused!
    if (!_simple) {
        _simple = [JGActionSheet actionSheetWithSections:@[[JGActionSheetSection sectionWithTitle:@"Title" message:@"Message" buttonTitles:@[@"Yes", @"No"] buttonStyle:JGActionSheetButtonStyleDefault], [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"Cancel"] buttonStyle:JGActionSheetButtonStyleCancel]]];
        
        _simple.delegate = self;
        
        _simple.insets = UIEdgeInsetsMake(20.0f, 0.0f, 0.0f, 0.0f);
        
        if (iPad) {
            [_simple setOutsidePressBlock:^(JGActionSheet *sheet) {
                [sheet dismissAnimated:YES];
            }];
        }
        
        [_simple setButtonPressedBlock:^(JGActionSheet *sheet, NSIndexPath *indexPath) {
            [sheet dismissAnimated:YES];
        }];
    }
    
    if (anchor && iPad) {
        _anchorView = anchor;
        _anchorLeft = YES;
        _currentAnchoredActionSheet = _simple;
        
        CGPoint p = (CGPoint){-5.0f, CGRectGetMidY(anchor.bounds)};
        
        p = [self.navigationController.view convertPoint:p fromView:anchor];
        
        [_simple showFromPoint:p inView:[[UIApplication sharedApplication] keyWindow] arrowDirection:JGActionSheetArrowDirectionRight animated:YES];
    }
    else {
        [_simple showInView:self.navigationController.view animated:YES];
    }
}

- (void)multipleSections:(UIView *)anchor {
    JGActionSheetSection *s1 = [JGActionSheetSection sectionWithTitle:@"A Title" message:@"A short message" buttonTitles:@[@"Button 1", @"Button 2", @"Button 3"] buttonStyle:JGActionSheetButtonStyleDefault];
    
    JGActionSheetSection *s2 = [JGActionSheetSection sectionWithTitle:@"Another Title" message:@"A long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long, very long message!" buttonTitles:@[@"Red Button", @"Green Button", @"Blue Button"] buttonStyle:JGActionSheetButtonStyleDefault];
    
    [s2 setButtonStyle:JGActionSheetButtonStyleRed forButtonAtIndex:0];
    [s2 setButtonStyle:JGActionSheetButtonStyleGreen forButtonAtIndex:1];
    [s2 setButtonStyle:JGActionSheetButtonStyleBlue forButtonAtIndex:2];
    
    JGActionSheet *sheet = [JGActionSheet actionSheetWithSections:@[s1, s2, [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"Cancel"] buttonStyle:JGActionSheetButtonStyleCancel]]];
    
    sheet.delegate = self;
    
    sheet.insets = UIEdgeInsetsMake(20.0f, 0.0f, 0.0f, 0.0f);
    
    if (anchor && iPad) {
        _anchorView = anchor;
        _anchorLeft = YES;
        _currentAnchoredActionSheet = sheet;
        
        CGPoint p = (CGPoint){-5.0f, CGRectGetMidY(anchor.bounds)};
        
        p = [self.navigationController.view convertPoint:p fromView:anchor];
        
        [sheet showFromPoint:p inView:self.navigationController.view arrowDirection:JGActionSheetArrowDirectionRight animated:YES];
    }
    else {
        [sheet showInView:self.navigationController.view animated:YES];
    }
    
    if (iPad) {
        [sheet setOutsidePressBlock:^(JGActionSheet *sheet) {
            [sheet dismissAnimated:YES];
        }];
    }
    
    [sheet setButtonPressedBlock:^(JGActionSheet *sheet, NSIndexPath *indexPath) {
        [sheet dismissAnimated:YES];
    }];
}

- (void)multipleAndContentView:(UIView *)anchor {
    JGActionSheetSection *s1 = [JGActionSheetSection sectionWithTitle:@"A Title" message:@"A short message" buttonTitles:@[@"Button 1", @"Button 2", @"Button 3"] buttonStyle:JGActionSheetButtonStyleDefault];
    
    JGActionSheetSection *s2 = [JGActionSheetSection sectionWithTitle:@"Another Title" message:@"A message!" buttonTitles:@[@"Red Button", @"Green Button", @"Blue Button"] buttonStyle:JGActionSheetButtonStyleDefault];
    
    UISlider *c = [[UISlider alloc] init];
    c.frame = (CGRect){CGPointZero, {290.0f, c.frame.size.height}};
    
    JGActionSheetSection *s3 = [JGActionSheetSection sectionWithTitle:@"Content View Section" message:nil contentView:c];
    
    [s2 setButtonStyle:JGActionSheetButtonStyleRed forButtonAtIndex:0];
    [s2 setButtonStyle:JGActionSheetButtonStyleGreen forButtonAtIndex:1];
    [s2 setButtonStyle:JGActionSheetButtonStyleBlue forButtonAtIndex:2];
    
    JGActionSheet *sheet = [JGActionSheet actionSheetWithSections:@[s1, s2, s3, [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"Cancel"] buttonStyle:JGActionSheetButtonStyleCancel]]];
    
    sheet.delegate = self;
    
    sheet.insets = UIEdgeInsetsMake(20.0f, 0.0f, 0.0f, 0.0f);
    
    if (anchor && iPad) {
        _anchorView = anchor;
        _anchorLeft = YES;
        _currentAnchoredActionSheet = sheet;
        
        CGPoint p = (CGPoint){-5.0f, CGRectGetMidY(anchor.bounds)};
        
        p = [self.navigationController.view convertPoint:p fromView:anchor];
        
        [sheet showFromPoint:p inView:self.navigationController.view arrowDirection:JGActionSheetArrowDirectionRight animated:YES];
    }
    else {
        [sheet showInView:self.navigationController.view animated:YES];
    }
    
    if (iPad) {
        [sheet setOutsidePressBlock:^(JGActionSheet *sheet) {
            [sheet dismissAnimated:YES];
        }];
    }
    
    [sheet setButtonPressedBlock:^(JGActionSheet *sheet, NSIndexPath *indexPath) {
        [sheet dismissAnimated:YES];
    }];
}

@end
