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

//Basic Condor Framework Demo
@interface CondorDemoViewControllerObj()

    @property (strong, nonatomic) CondorObjectSort *condorObjectSort;
    @property (strong, nonatomic) CondorSort *condorSort;

@end

@implementation CondorDemoViewControllerObj
@synthesize arraySizeTextField;
@synthesize condorPerformanceLabel;
@synthesize activityIndicator;
@synthesize applePerformanceLabel;
@synthesize condorObjectSort;
@synthesize arraySizeLabel;
@synthesize condorSort;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Create an Object of CondorObjectSort
    condorObjectSort = [[CondorObjectSort alloc] init];
    condorSort = [[CondorSort alloc] init];
    
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
    NSArray *nsarray = [self.condorObjectSort  sortFloatObjectArray:nsmarray orderDesc:false];
    arraySizeLabel.text =@"OBJECT FLOAT ARRAY SIZE";
    
//    //INT OBJECT SORTING
//    NSArray *nsarray = [self.condorObjectSort sortSignedIntObjectArray:nsmarray orderDesc:false];
//    arraySizeLabel.text = @"OBJECT INT32 ARRAY SIZE";
    
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
            NSLog(@"Sorted: %f", myd.condorIdf);
        }
    }
    
    //Validate sorting order if not output error
    Boolean passed = true;
    for(int i = 1; i < arraySize-1; i++)
    {
        if([nsarray[i] condorIdf] < [nsarray[i-1] condorIdf])
        {
            NSLog(@"Not Sort %f and %i", [nsarray[i] condorIdf], i);
            passed = false;
        }
    }
    
    [activityIndicator stopAnimating];
}

- (IBAction)condorInt32SortButton:(id)sender {
    
    unsigned int arraySize = [arraySizeTextField.text intValue];
    
    signed int* array = (signed int*)calloc(arraySize, 4);
    
    NSLog(@"Array Size 100");
    for(int i = 0; i < arraySize/2; i++)
    {
        signed int value = ((signed int)arc4random_uniform(21474836));
        array[i] = (signed int)(value);
    }
    for(int i = arraySize/2; i < arraySize; i++)
    {
        signed int value = -((signed int)arc4random_uniform(21474836));
        array[i] = (signed int)(value);
    }
    
    if(arraySize > 100)
    {
        for(int i = 0; i < 100; i++)
        {
            NSLog(@"Presorted Value:%i", array[i]);
        }
    }
    
    NSDate *date = [NSDate date];
    [self.condorSort sortSignedIntArray:array withLength:arraySize];
    
    double timePassed_ms = [date timeIntervalSinceNow] * -1000.0;
    condorPerformanceLabel.text = [NSString stringWithFormat:@"%.2f ms", timePassed_ms];
    arraySizeLabel.text = @"INT32 ARRAY SIZE";
    
    Boolean passed = true;
    for(int i = 1; i < arraySize; i++)
    {
        if(array[i] < array[i-1])
        {
            NSLog(@"Not Sort %i", i);
            passed = false;
            break;
        }
    }
    
    if(passed == true) NSLog(@"In Order");
    NSLog(@"Performance: %f", timePassed_ms);
    free(array);
    
    [activityIndicator stopAnimating];
}

- (IBAction)condorUInt32Button:(id)sender {
    
    unsigned int arraySize = [arraySizeTextField.text intValue];
    
    // UNSIGNED INT32
    unsigned int* array = (unsigned int*)calloc(arraySize, 4);
    
    for(int i = 0; i < arraySize; i++)
    {
        unsigned int value = ((unsigned int)arc4random_uniform(21474836 * 2) );
        array[i] = (unsigned int)(value);
    }
    
    if(arraySize > 100)
    {
        for(int i = 0; i < 100; i++)
        {
            NSLog(@"Presorted Value:%i", array[i]);
        }
    }
    
    NSDate *date = [NSDate date];
    [self.condorSort sortUnsignedIntArray:array withLength:arraySize];
    
    double timePassed_ms = [date timeIntervalSinceNow] * -1000.0;
    condorPerformanceLabel.text = [NSString stringWithFormat:@"%.2f ms", timePassed_ms];
    arraySizeLabel.text = @"UINT32 ARRAY SIZE";
    
    Boolean passed = true;
    for(int i = 1; i < arraySize; i++)
    {
        if(array[i] < array[i-1])
        {
            NSLog(@"Not Sort %i", i);
            passed = false;
        }
    }
    
    if(passed == true) NSLog(@"In Order");
    NSLog(@"Performance: %f", timePassed_ms);
    free(array);
    
    [activityIndicator stopAnimating];
}

- (IBAction)condorFloatButton:(id)sender {
    
    unsigned int arraySize = [arraySizeTextField.text intValue];
    
    //FLOAT
    float* array = (float*)calloc(arraySize, 4);

    for(int i = 0; i < arraySize; i++)
    {
        float value = (float)((arc4random_uniform(21836 * 2) / 100.0f)  - 21836.0f);
        array[i] = (float)(value);
    }
    
    if(arraySize > 100)
    {
        for(int i = 0; i < 100; i++)
        {
            NSLog(@"Presorted Value:%f", array[i]);
        }
    }
    
    NSDate *date = [NSDate date];
    [self.condorSort sortFloatArray:array withLength:arraySize];
    double timePassed_ms = [date timeIntervalSinceNow] * -1000.0;
    condorPerformanceLabel.text = [NSString stringWithFormat:@"%.2f ms", timePassed_ms];
    arraySizeLabel.text = @"FLOAT ARRAY SIZE";
    
    Boolean passed = true;
    for(int i = 1; i < arraySize; i++)
    {
        if(array[i] < array[i-1])
        {
            NSLog(@"Not Sort %f", array[i]);
            passed = false;
            //break;
        }
    }
    
    if(passed == true) NSLog(@"In Order");
    NSLog(@"Performance: %f", timePassed_ms);
    free(array);
    
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
    
    arraySizeLabel.text = @"OBJECT INT32 ARRAY SIZE";
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
