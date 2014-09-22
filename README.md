JGActionSheet
=============

A feature-rich and modern action sheet for iOS.
<p align="center">
<img src="JGActionSheet Tests/Screenshots/1.png" width="36.2%"/>&nbsp;
<img src="JGActionSheet Tests/Screenshots/2.png" width="48%"/></p>

#####Current Version: 1.0.5

Introduction
===========
JGActionSheet has all features of UIActionSheet but it goes even further than that:<br>
<b>• Multiple sections.<br>
• Full customization for buttons and labels.<br>
• Sections can contain custom views.<br>
• Block callbacks.<br>
• Unlimited content capacity, thanks to UIScrollView.<br></b>

####iPad support:
While of course offering iPhone support, iPad support is crucial, as many UIActionSheet alternatives don't offer iPad support.<br>
JGActionSheet takes the ideas of UIActionSheet but implements them much better. You can precisely show the action sheet from a specific point in a view and set the arrow direction like in a UIPopoverController!<br><br>
The action sheet can also just be shown in the center of a view on iPads, like UIActionSheet.

####UIAlertController on iOS 8:
On iOS 8 `UIAlertController` replaces `UIActionSheet` and `UIAlertView`. UIAlertController has even less features than UIActionSheet on iPads. Controlling whether the action sheet should show in the center of a view without an arrow or with an arrow is gone. And setting the location of the action sheet when using an arrow has become even more difficult and annoying. JGActionSheet gets rid of all these limitations and makes placing your action sheet so much easier!

Requirements
=================

• Deployment Target of iOS 5 or higher, Base SDK of iOS 7 or higher.<br>
• ARC.

Examples
=================
#####Simple example:
```objc
JGActionSheetSection *section1 = [JGActionSheetSection sectionWithTitle:@"Title" message:@"Message" buttonTitles:@[@"Yes", @"No"] buttonStyle:JGActionSheetButtonStyleDefault];
JGActionSheetSection *cancelSection = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"Cancel"] buttonStyle:JGActionSheetButtonStyleCancel];

NSArray *sections = @[section1, cancelSection];

JGActionSheet *sheet = [JGActionSheet actionSheetWithSections:sections];

[sheet setButtonPressedBlock:^(JGActionSheet *sheet, NSIndexPath *indexPath) {
    [sheet dismissAnimated:YES];
}];
    
[sheet showInView:self.view animated:YES];
```

This displays an action sheet with a section with the title "Title", the message "Message", two buttons saying "Yes" and "No", and a second section containing just a cancel button. The action sheet will be dismissed with every tap of a button (The `buttonPressedBlock` block dismisses the action sheet for every pressed button in this case!).
<br>

See the <a href="JGActionSheet%20Tests">JGActionSheet Tests</a> project for more example implementations.

Documentation
================
Detailed documentation can be found on <a href="http://cocoadocs.org/docsets/JGActionSheet">CocoaDocs</a>.<br>
The header file also contains detailed documentation for each method call. See <a href="JGActionSheet/JGActionSheet.h">JGActionSheet.h</a>.

Installation
================
<b>CocoaPods:</b><br>
Add this to your `Podfile`:
```
pod 'JGActionSheet'
```

<b>Add source files:</b><br>
JGActionSheet consist of only the `JGActionSheet.h` and `JGActionSheet.m` files. To use JGActionSheet in your project, simply drag these two files located in the <a href="JGActionSheet">JGActionSheet folder</a> into your project.

After you have included JGActionSheet in your project simply do `#import "JGActionSheet.h"` and you are ready to go!

License
==========
MIT License.<br>
©2014 Jonas Gessner.

Credits
==========
Created by Jonas Gessner © 2014.<br>
