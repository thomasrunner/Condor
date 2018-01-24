//
//    CondorDemoViewController.m
//    CondorObjectSortDemo
//
//    Created by Thomas on 2018-01-13.
//    Copyright © 2018 Thomas Lock. <thomas.lock.personal@gmail.com>
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in
//    all copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//    THE SOFTWARE.

//    Copying and distribution of this file, with or without modification,
//    are permitted in any medium without royalty provided the copyright
//    notice and this notice are preserved.
//

#import "CondorDemoViewControllerObj.h"

#import "MyDataModel.h"
#import <Condor/Condor.h>

//#import "CondorObjectSort.h"

//Super Basic Condor Demo
@interface CondorDemoViewControllerObj()

    @property (strong, nonatomic) CondorObjectSort *condorObjectSort;

@end

@implementation CondorDemoViewControllerObj
@synthesize arraySizeTextField;
@synthesize condorPerformanceLabel;
@synthesize activityIndicator;
@synthesize applePerformanceLabel;
@synthesize condorObjectSort;
@synthesize arraySizeLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Create an Object of CondorObjectSort
    condorObjectSort = [[CondorObjectSort alloc] init];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonDown:(id)sender {
    [activityIndicator startAnimating];
}


- (IBAction)condorSortButton:(id)sender {
    
    //Get Array Size no Validation in Demo
    unsigned int arraySize = [arraySizeTextField.text intValue];

    //Generate an Array of MyDataModel Objects with Random condorId and condorIdf value.
    int skipper = 0;
    NSMutableArray *nsmarray = [[NSMutableArray alloc] init];
    for (int i = 0; i < arraySize; i++)
    {
        MyDataModel *number = [[MyDataModel alloc] init];
        
        switch (skipper)
        {
            case 0:
                number.condorId = (int)arc4random_uniform(7276800);
                number.condorIdf =  (float)(i/1000.0f);
                break;
            case 1:
                number.condorId = -(int)arc4random_uniform(7276800);
                number.condorIdf =  (float)((float)arc4random_uniform(3276800 * 2) * M_PI_2);
                break;
                
            case 2:
                number.condorId = (int)arc4random_uniform(256);
                number.condorIdf =  -(float)((float)arc4random_uniform(3276800 * 2) * M_PI_2);
                break;
        }
        skipper++;
        if (skipper == 3) skipper = 0;

        //ONLY ONE Thank you Oleg :)
        [nsmarray addObject:number];
    }
    
    //Simple Timing
    NSDate *date = [NSDate date];
    
    //FLOAT OBJECT SORTING
//    NSArray *nsarray = [self.condorObjectSort  sortFloatObjectArray:nsmarray orderDesc:false];
//    arraySizeLabel.text =@"FLOAT ARRAY SIZE";
    
    //INT OBJECT SORTING
    NSArray *nsarray = [self.condorObjectSort sortSignedIntObjectArray:nsmarray orderDesc:false];
    arraySizeLabel.text = @"INT ARRAY SIZE";
    
    //REVERSE ORDER OR ANY ARRAY
//  [self reverseOrderOfObjectArray: array withLow:0 andHigh:(int)[nsmarray count]-1];

    //Get Timing Result
    double timePassed_ms = [date timeIntervalSinceNow] * -1000.0;
    condorPerformanceLabel.text = [NSString stringWithFormat:@"%.2f ms", timePassed_ms];
    
    //Outputs small sets
    if(arraySize <200)
    {
        for(MyDataModel *myd in nsarray)
        {
            //Change "condorIdf" to "condorId" to test Int
            NSLog(@"Sorted: %i", myd.condorId);
        }
    }
    
    //Validate sorting order if not output error
    Boolean passed = true;
    for(int i = 1; i < arraySize-1; i++)
    {
        if([nsarray[i] condorId] < [nsarray[i-1] condorId])
        {
            NSLog(@"Not Sort %f and %i", [nsarray[i-1] condorIdf], i-1);
            NSLog(@"Not Sort %f and %i", [nsarray[i] condorIdf], i);
            NSLog(@"Not Sort %f and %i", [nsarray[i+1] condorIdf], i+1);
            passed = false;
            //break;
        }
    }
    
    [activityIndicator stopAnimating];
}

- (IBAction)appleSortButton:(id)sender {
    
    //Get Array Size no Validation in Demo
    unsigned int arraySize = [arraySizeTextField.text intValue];
    
    //Generate an Array of MyDataModel Objects with Random condorId value.
    int skipper = 0;
    NSMutableArray *nsmarray = [[NSMutableArray alloc] init];
    for (int i = 0; i < arraySize; i++)
    {
        MyDataModel *number = [[MyDataModel alloc] init];
        
        switch (skipper)
        {
            case 0:
                number.condorId = (int)arc4random_uniform(7276800);
                number.condorIdf =  (float)(i/1000.0f);
                break;
            case 1:
                number.condorId = -(int)arc4random_uniform(7276800);
                number.condorIdf =  (float)((float)arc4random_uniform(3276800 * 2) * M_PI_2);
                break;
                
            case 2:
                number.condorId = (int)arc4random_uniform(256);
                number.condorIdf =  -(float)((float)arc4random_uniform(3276800 * 2) * M_PI_2);
                break;
        }
        skipper++;
        if (skipper == 3) skipper = 0;
        
        //ONLY ONE Thank you Oleg :)
        [nsmarray addObject:number];
    }
    
    //Change "condorIdf" to "condorId" to test Int
    NSSortDescriptor *condorDescriptor = [[NSSortDescriptor alloc] initWithKey:@"condorId" ascending:YES];
    NSArray *sortDescriptors = @[condorDescriptor];
    
    //Simple Timing
    NSDate *date = [NSDate date];
    
    //Apple Sorting Algorithm
    NSArray *nsarray = [nsmarray sortedArrayUsingDescriptors:sortDescriptors];
    
    //Get Timing Result
    double timePassed_ms = [date timeIntervalSinceNow] * -1000.0;
    applePerformanceLabel.text = [NSString stringWithFormat:@"%.2f ms", timePassed_ms];
    
    //Outputs results on small tests
    if(arraySize <200)
    {
        for(MyDataModel *myd in nsarray)
        {
            //Change "condorIdf" to "condorId" to test Int
            NSLog(@"Sorted: %i", myd.condorId);
        }
    }
    
    [activityIndicator stopAnimating];
}

- (IBAction)keyboardRelease:(id)sender {
    [arraySizeTextField resignFirstResponder];
}

#pragma mark - Text Field Delegate
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
