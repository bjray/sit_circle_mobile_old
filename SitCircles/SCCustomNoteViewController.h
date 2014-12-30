//
//  SCCustomNoteViewController.h
//  SitCircles
//
//  Created by B.J. Ray on 10/16/14.
//  Copyright (c) 2014 109Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCCustomNoteViewController : UIViewController
@property (nonatomic, weak) IBOutlet UIButton *cancelButton;
@property (nonatomic, weak) IBOutlet UIButton *submitButton;
@property (nonatomic, weak) IBOutlet UITextView *textView;

@property (nonatomic, copy) void (^saveCallback)(NSString *);
@property (nonatomic, copy) dispatch_block_t cancelCallback;

- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;
@end
