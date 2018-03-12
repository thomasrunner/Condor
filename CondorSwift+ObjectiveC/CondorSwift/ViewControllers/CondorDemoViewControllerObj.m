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
{
    unsigned int arraySize;
}

    @property (strong, nonatomic) CondorObjectSortInt *condorObjectSort;
    @property (strong, nonatomic) CondorObjectSortFloat *condorObjectSortFloat;
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
@synthesize condorObjectSortFloat;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Create an Object of CondorObjectSort
    condorObjectSort = [[CondorObjectSortInt alloc] init];
    condorSort = [[CondorSort alloc] init];
    condorObjectSortFloat = [[CondorObjectSortFloat alloc] init];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonDown:(id)sender {
    [activityIndicator startAnimating];
}

-(void) buildTestArray:(NSMutableArray*)array
{
    //Get Array Size no Validation in Demo
    arraySize = [arraySizeTextField.text intValue];
    int skipper = 0;
    for (int i = 0; i < arraySize; i++)
    {
        MyDataModel *number = [[MyDataModel alloc] init];
        switch (skipper)
        {
            case 0:
                number.anyPropertyInt = (int)arc4random_uniform(7276800);
                number.anyPropertyFloat =  (float)(i/1000.0f);
                break;
            case 1:
                number.anyPropertyInt = -(int)arc4random_uniform(7276800);
                number.anyPropertyFloat =  (float)((float)arc4random_uniform(3276800 * 2) * M_PI_2);
                break;
                
            case 2:
                number.anyPropertyInt = (int)arc4random_uniform(256);
                number.anyPropertyFloat =  -(float)((float)arc4random_uniform(3276800 * 2) * M_PI_2);
                break;
        }
        skipper++;
        if (skipper == 3) skipper = 0;
        
        //ONLY ONE Thank you Oleg :)
        [array addObject:number];
    }
}

- (IBAction)condorSortFloatButton:(id)sender {

    //Generate an Array of MyDataModel Objects with Random Property values.
    NSMutableArray *nsmarray = [[NSMutableArray alloc] init];
    [self buildTestArray:nsmarray];
    
    //Simple Timing
    NSDate *date = [NSDate date];
    
    NSString *selectorString = @"anyPropertyFloat";
    
    //FLOAT OBJECT SORTING
    NSArray *nsarray = [self.condorObjectSortFloat  sortFloatObjectArray:nsmarray orderDesc:false selectorNameAsString:selectorString];
    arraySizeLabel.text =@"OBJECT FLOAT ARRAY SIZE";
    
    //Get Timing Result
    double timePassed_ms = [date timeIntervalSinceNow] * -1000.0;
    condorPerformanceLabel.text = [NSString stringWithFormat:@"%.2f ms", timePassed_ms];
    
//    //Outputs small sets
//    if(arraySize <200)
//    {
//        for(MyDataModel *myd in nsarray)
//        {
//            NSLog(@"Sorted: %f", myd.anyPropertyFloat);
//        }
//    }
    
    //Validate sorting order if not output error
    Boolean passed = true;
    for(int i = 1; i < arraySize-1; i++)
    {
        if([nsarray[i] anyPropertyFloat] < [nsarray[i-1] anyPropertyFloat])
        {
            NSLog(@"Not Sort %f and %i", [nsarray[i] anyPropertyFloat], i);
            passed = false;
        }
    }
    
    [activityIndicator stopAnimating];
}

- (IBAction)condorSortButton:(id)sender {
    
    //Generate an Array of MyDataModel Objects with Random Property values.
    NSMutableArray *nsmarray = [[NSMutableArray alloc] init];
    [self buildTestArray:nsmarray];
    
    //Simple Timing
    NSDate *date = [NSDate date];
    
    NSString *selectorString = @"anyPropertyInt";

    //INT OBJECT SORTING
    NSArray *nsarray = [self.condorObjectSort sortSignedIntObjectArray:nsmarray orderDesc:false selectorNameAsString:selectorString];
    arraySizeLabel.text = @"OBJECT INT32 ARRAY SIZE";
    
    //Get Timing Result
    double timePassed_ms = [date timeIntervalSinceNow] * -1000.0;
    condorPerformanceLabel.text = [NSString stringWithFormat:@"%.2f ms", timePassed_ms];
    
//    //Outputs small sets
//    if(arraySize <200)
//    {
//        for(MyDataModel *myd in nsarray)
//        {
//            NSLog(@"Sorted: %d", myd.anyPropertyInt);
//        }
//    }
    
    //Validate sorting order if not output error
    Boolean passed = true;
    for(int i = 1; i < arraySize-1; i++)
    {
        if([nsarray[i] anyPropertyInt] < [nsarray[i-1] anyPropertyInt])
        {
            NSLog(@"Not Sort %d and %i", [nsarray[i] anyPropertyInt], i);
            passed = false;
        }
    }
    
    [activityIndicator stopAnimating];
}

- (IBAction)condorInt32SortButton:(id)sender {
    
    arraySize = [arraySizeTextField.text intValue];
    
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
    
//    if(arraySize > 100)
//    {
//        for(int i = 0; i < 100; i++)
//        {
//            NSLog(@"Presorted Value:%i", array[i]);
//        }
//    }
    
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
    
    arraySize = [arraySizeTextField.text intValue];
    
    // UNSIGNED INT32
    unsigned int* array = (unsigned int*)calloc(arraySize, 4);
    
    for(int i = 0; i < arraySize; i++)
    {
        unsigned int value = ((unsigned int)arc4random_uniform(21474836 * 2) );
        array[i] = (unsigned int)(value);
    }
    
//    if(arraySize > 100)
//    {
//        for(int i = 0; i < 100; i++)
//        {
//            NSLog(@"Presorted Value:%i", array[i]);
//        }
//    }
    
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
    
    arraySize = [arraySizeTextField.text intValue];
    
    //FLOAT
    float* array = (float*)calloc(arraySize, 4);

    for(int i = 0; i < arraySize; i++)
    {
        float value = (float)((arc4random_uniform(21836 * 2) / 100.0f)  - 21836.0f);
        array[i] = (float)(value);
    }
    
//    if(arraySize > 100)
//    {
//        for(int i = 0; i < 100; i++)
//        {
//            NSLog(@"Presorted Value:%f", array[i]);
//        }
//    }
    
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

- (IBAction)appleSortObjectFloatButton:(id)sender {
    
    //Generate an Array of MyDataModel Objects with Random Property values.
    NSMutableArray *nsmarray = [[NSMutableArray alloc] init];
    [self buildTestArray:nsmarray];
    
    arraySizeLabel.text = @"OBJECT FLOAT ARRAY SIZE";

    NSSortDescriptor *condorDescriptor = [[NSSortDescriptor alloc] initWithKey:@"anyPropertyFloat" ascending:YES];
    NSArray *sortDescriptors = @[condorDescriptor];
    
    //Simple Timing
    NSDate *date = [NSDate date];
    
    //Apple Sorting Algorithm
    __unused NSArray *nsarray = [nsmarray sortedArrayUsingDescriptors:sortDescriptors];
    
    //Get Timing Result
    double timePassed_ms = [date timeIntervalSinceNow] * -1000.0;
    applePerformanceLabel.text = [NSString stringWithFormat:@"%.2f ms", timePassed_ms];
    
    [activityIndicator stopAnimating];
}

- (IBAction)appleObjectIntSortButton:(id)sender {
    
    //Generate an Array of MyDataModel Objects with Random Property values.
    NSMutableArray *nsmarray = [[NSMutableArray alloc] init];
    [self buildTestArray:nsmarray];
    
    arraySizeLabel.text = @"OBJECT INT32 ARRAY SIZE";
    
    NSSortDescriptor *condorDescriptor = [[NSSortDescriptor alloc] initWithKey:@"anyPropertyInt" ascending:YES];
    NSArray *sortDescriptors = @[condorDescriptor];
    
    //Simple Timing
    NSDate *date = [NSDate date];
    
    //Apple Sorting Algorithm
    __unused NSArray *nsarray = [nsmarray sortedArrayUsingDescriptors:sortDescriptors];
    
    //Get Timing Result
    double timePassed_ms = [date timeIntervalSinceNow] * -1000.0;
    applePerformanceLabel.text = [NSString stringWithFormat:@"%.2f ms", timePassed_ms];

    [activityIndicator stopAnimating];
}

- (IBAction)appleInt32SortButton:(id)sender {
    
    arraySize = [arraySizeTextField.text intValue];
    
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
    
    //Simple Timing
    NSDate *date = [NSDate date];
    
    quicksort(array, 0, arraySize);
    
    double timePassed_ms = [date timeIntervalSinceNow] * -1000.0;
    applePerformanceLabel.text = [NSString stringWithFormat:@"%.2f ms", timePassed_ms];
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



- (IBAction)keyboardRelease:(id)sender {
    [arraySizeTextField resignFirstResponder];
}

#pragma mark - Text Field Delegate
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - QuickSort for non-Object in Apple
void swap(int *x,int *y)
{
    int temp;
    temp = *x;
    *x = *y;
    *y = temp;
}

int choose_pivot(int i,int j )
{
    return((i+j) /2);
}

void quicksort(int list[],int m,int n)
{
    int key,i,j,k;
    if( m < n)
    {
        k = choose_pivot(m,n);
        swap(&list[m],&list[k]);
        key = list[m];
        i = m+1;
        j = n;
        while(i <= j)
        {
            while((i <= n) && (list[i] <= key))
                i++;
            while((j >= m) && (list[j] > key))
                j--;
            if( i < j)
                swap(&list[i],&list[j]);
        }
        /* swap two elements */
        swap(&list[m],&list[j]);
        
        /* recursively sort the lesser list */
        quicksort(list,m,j-1);
        quicksort(list,j+1,n);
    }
}
@end
