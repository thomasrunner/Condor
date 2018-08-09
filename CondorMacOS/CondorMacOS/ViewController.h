//
//  ViewController.h
//  CondorMacOS
//
//  Created by Thomas on 2018-01-27.
//  Copyright © 2018 Thomas Lock. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController
@property (strong) IBOutlet NSTextField *arraySizeTextField;

@property (strong) IBOutlet NSTextField *condorPerformanceLabel;
@property (strong) IBOutlet NSTextField *applePerformanceLabel;
@property (strong) IBOutlet NSTextField *arraySizeLabel;

- (IBAction)appleSortButton:(id)sender;

@end

