//
//  JGActionSheet.h
//  JGActionSheet
//
//  Created by Jonas Gessner on 25.07.14.
//  Copyright (c) 2014 Jonas Gessner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 Button styles for JGActionSheetSection.
 @sa JGActionSheetSection.
 */
typedef NS_ENUM(NSUInteger, JGActionSheetButtonStyle) {
    JGActionSheetButtonStyleDefault,
    JGActionSheetButtonStyleCancel,
    JGActionSheetButtonStyleRed,
    JGActionSheetButtonStyleGreen,
    JGActionSheetButtonStyleBlue
};

/**
 Arrow directions for JGActionSheet on iPad.
 @sa JGActionSheetSection.
 */
typedef NS_ENUM(NSUInteger, JGActionSheetArrowDirection) {
    JGActionSheetArrowDirectionLeft,
    JGActionSheetArrowDirectionRight,
    JGActionSheetArrowDirectionTop,
    JGActionSheetArrowDirectionBottom,
};







/**
 A section for JGActionSheet.
 @sa JGActionSheet.
 */
@interface JGActionSheetSection : UIView

/**
 The label containing the title of the section.
 */
@property (nonatomic, strong, readonly) UILabel *titleLabel;

/**
 The label containing the message of the section.
 */
@property (nonatomic, strong, readonly) UILabel *messageLabel;

/**
 If the section was initialized with button titles, the corresponding buttons are in this array. You may access these to modify the text color, the font etc.
 */
@property (nonatomic, strong, readonly) NSArray *buttons;

/**
 If the section was initialized with a custom contentView it is available from this property.
 @Note The content view will be resized to match the width of the action sheet. This is minimally 290 points. The height of the content view will not be changed.
 */
@property (nonatomic, strong, readonly) UIView *contentView;


/**
 Returns a standard cancel section. The button title is "Cancel" (localized string), and the button style is the cancel button style.
*/
+ (instancetype)cancelSection;

/**
 Convenience initializer for the @c initWithTitle:message:buttonTitles:buttonStyle: initializer.
 */
+ (instancetype)sectionWithTitle:(NSString *)title message:(NSString *)message buttonTitles:(NSArray *)buttonTitles buttonStyle:(JGActionSheetButtonStyle)buttonStyle;

/**
 Initializes the section with buttons.
 @param title The title of the section. (Optional)
 @param message The message of the section. (Optional)
 @param buttonTitles The titles for the buttons in the section.
 @param buttonStyle The style to apply to the buttons. This can be altered later with the @c setButtonStyle:forButtonAtIndex: method
 */
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message buttonTitles:(NSArray *)buttonTitles buttonStyle:(JGActionSheetButtonStyle)buttonStyle;

/**
 Convenience initializer for the @c initWithTitle:message:contentView: method.
 */
+ (instancetype)sectionWithTitle:(NSString *)title message:(NSString *)message contentView:(UIView *)contentView;

/**
 Initializes the section with a custom content view.
 @param title The title of the section. (Optional)
 @param message The message of the section. (Optional)
 @param contentView The custom content view to display in the section.
 */
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message contentView:(UIView *)contentView;

/**
 Sets the button style for a specific button.
 @param buttonStyle
 @Warning If the section does not have any buttons or @c index exceeds the number of buttons an exception is thrown.
 */
- (void)setButtonStyle:(JGActionSheetButtonStyle)buttonStyle forButtonAtIndex:(NSUInteger)index;

@end






@class JGActionSheet;

/**
 The delegate for JGActionSheet.
 @sa JGActionSheet.
 */
@protocol JGActionSheetDelegate <NSObject>

@optional

/**
 Called before the action sheet will present. (Optional)
 */
- (void)actionSheetWillPresent:(JGActionSheet *)actionSheet;

/**
 Called after the action sheet did present. (Optional)
 */
- (void)actionSheetDidPresent:(JGActionSheet *)actionSheet;

/**
 Called before the action sheet will dismiss. (Optional)
 */
- (void)actionSheetWillDismiss:(JGActionSheet *)actionSheet;

/**
 Called after the action sheet did present. (Optional)
 */
- (void)actionSheetDidDismiss:(JGActionSheet *)actionSheet;

/**
 Called when a button in any section of the action sheet is pressed. (Optional)
 @param indexPath The index path of the pressed button. (Section, Row)
 
  @Note Unlike UIActionSheet, JGActionSheet does not automatically dismiss when a button is pressed. You need to manually call @c dismissAnimated: to dismiss the action sheet.
 */
- (void)actionSheet:(JGActionSheet *)actionSheet pressedButtonAtIndexPath:(NSIndexPath *)indexPath;

@end






/**
 A feature rich replacement for UIActionSheet.
 */
@interface JGActionSheet : UIView

/**
 The view in which the action sheet is presented.
 */
@property (nonatomic, weak, readonly) UIView *targetView;

/**
 The sections of the action sheet.
 */
@property (nonatomic, strong, readonly) NSArray *sections;

/**
 The delegate of the action sheet.
 */
@property (nonatomic, weak) id <JGActionSheetDelegate> delegate;

/**
 A block that is invoked when a button in any section is pressed. Can be used instead of assigning a delegate to the action sheet.
 @param indexPath The index path of the pressed button. (Section, Row)
 
 @Note Unlike UIActionSheet, JGActionSheet does not automatically dismiss when a button is pressed. You need to manually call @c dismissAnimated: to dismiss the action sheet.
 */
@property (nonatomic, copy) void (^buttonPressedBlock)(JGActionSheet *actionSheet, NSIndexPath *indexPath);

/**
 If the action sheet is visible on screen.
 */
@property (nonatomic, assign, readonly, getter=isVisible) BOOL visible;

/**
 A block that is invoked when the area outside of the action sheet but inside the hosting view is tapped. Can be used to dismiss the action sheet when tapped outside of the action sheet (like UIActionSheet on iPad).
 */
@property (nonatomic, copy) void (^outsidePressBlock)(JGActionSheet *sheet);

/**
 Insets for the action sheet inside its hosting view.
 */
@property (nonatomic, assign) UIEdgeInsets insets;

/**
 Convenience initializer for the @c initWithSections: method.
 */
+ (instancetype)actionSheetWithSections:(NSArray *)sections;

/**
 Initializes the action sheet with one or more sections.
 
 @param sections An array containing all the sections that should be displayed in the action sheet. You must at least provide one section or an exception is thrown.
 */
- (instancetype)initWithSections:(NSArray *)sections;

/**
 Shows the action sheet.
 @param view The hosting view in which the action sheet should be shown.
 @param animated Whether the action sheet should show with an animation.
 */
- (void)showInView:(UIView *)view animated:(BOOL)animated;

/**
 Shows the action sheet from a specific point.
 @param point The point to show the action sheet from. An arrow will point towards this point.
 @param view The hosting view in which the action sheet should be shown.
 @param arrowDirection The direction in which the arrow should show and the side of the section at which the arrow should be placed.
 @param animated Whether the action sheet should show with an animation.
 
 @Attention This method is only available on iPad devices.
 */
- (void)showFromPoint:(CGPoint)point inView:(UIView *)view arrowDirection:(JGActionSheetArrowDirection)arrowDirection animated:(BOOL)animated;

/**
 Moves the action sheet to a new point.
 
 @param point The point to show the action sheet from. An arrow will point towards this point.
 @param arrowDirection The direction in which the arrow should show and the side of the section at which the arrow should be placed.
 @param animated Whether the action sheet should change point with an animation. If you are invoking this method from the animated interface orientation change methods of UIViewController (@c willAnimateRotationToInterfaceOrientation:) pass @c NO because the UIViewController will itself do the animation.
 
 @Note This method can only be called if the action sheet is already visible on screen.
 @Attention This method is only available on iPad devices.
 */
- (void)moveToPoint:(CGPoint)point arrowDirection:(JGActionSheetArrowDirection)arrowDirection animated:(BOOL)animated;

/**
 Dismisses the action sheet.
 @param animated Whether the action sheet should be dismissed with an animation.
 */
- (void)dismissAnimated:(BOOL)animated;

@end
