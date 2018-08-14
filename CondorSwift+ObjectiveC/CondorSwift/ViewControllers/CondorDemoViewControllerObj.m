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

typedef NS_ENUM(int)
{
    ObjectDouble,
    ObjectInt32,
    ObjectInt64,
    Int32,
    Int64,
    Float,
    Double
} SortType;

//Basic Condor Framework Demo
@interface CondorDemoViewControllerObj()
{
    //Condor Sort Type Selected
    SortType sortType;
    
    //Object Sorting Variable
    NSMutableArray *nsmarray;
    NSArray *nsarray;
    
    //System Type Array Variables
    unsigned int arraySize;
    signed int* arrayInt;
    long long* arrayLongLong;
    float* arrayFloat;
    double* arrayDouble;
    
    //Apple Sort Descriptor
    NSSortDescriptor *condorDescriptor;
}

    //Condor Sorting Objects
    @property (strong, nonatomic) CondorObjectSortInt *condorObjectSort;
    @property (strong, nonatomic) CondorObjectSortInt64 *condorObjectInt64Sort;
    @property (strong, nonatomic) CondorObjectSortFloat *condorObjectSortFloat;
    @property (strong, nonatomic) CondorObjectSortDouble *condorObjectSortDouble;
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
@synthesize condorObjectInt64Sort;
@synthesize condorObjectSortDouble;

#pragma mark - ViewController Lifecycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Create an Instance of Object Sort
    condorObjectSort = [[CondorObjectSortInt alloc] init];
    condorSort = [[CondorSort alloc] init];
    condorObjectSortFloat = [[CondorObjectSortFloat alloc] init];
    condorObjectSortDouble = [[CondorObjectSortDouble alloc] init];
    condorObjectInt64Sort = [[CondorObjectSortInt64 alloc] init];
    
    NSLog(@"%d",(int)[[NSProcessInfo processInfo] processorCount]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Text Field
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)keyboardRelease:(id)sender {
    [arraySizeTextField resignFirstResponder];
}

#pragma mark - Condor Sort Methods
- (IBAction)buttonDown:(id)sender {
    [activityIndicator startAnimating];
}

- (IBAction)condorSortDoubleButton:(id)sender {
    sortType = ObjectDouble;
    [self condorSortUsingType:sortType];
}

- (IBAction)condorInt32Button:(id)sender {
    sortType = ObjectInt32;
    [self condorSortUsingType:sortType];
}

- (IBAction)condorInt64Button:(id)sender {
    sortType = ObjectInt64;
    [self condorSortUsingType:sortType];
}

- (IBAction)condorInt32SortButton:(id)sender {
    sortType = Int32;
    [self condorSortUsingType:sortType];
}

- (IBAction)condorInt64SortButton:(id)sender {
    sortType = Int64;
    [self condorSortUsingType:sortType];
}

- (IBAction)condorFloatButton:(id)sender {
    sortType = Float;
    [self condorSortUsingType:sortType];
}

- (IBAction)condorDoubleButton:(id)sender {
    sortType = Double;
    [self condorSortUsingType:sortType];
}

#pragma mark - Build Test Object Array
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
                number.anyPropertyInt64 = (long)(arc4random_uniform(7276800)) * (long)(arc4random_uniform(7276800));
                number.anyPropertyInt = (int)arc4random_uniform(7276800);
                number.anyPropertyFloat =  (float)(i/1000.0f);
                number.anyPropertyDouble =  (double)(i/1000.0f);
                break;
            case 1:
                number.anyPropertyInt64 = -(long)(arc4random_uniform(7276800)) * (long)(-arc4random_uniform(7276800));
                number.anyPropertyInt = -(int)arc4random_uniform(7276800);
                number.anyPropertyFloat =  (float)((float)arc4random_uniform(3276800 * 2) * M_PI_2);
                number.anyPropertyDouble =  (double)((float)arc4random_uniform(3276800 * 2) * M_PI_2);
                break;
                
            case 2:
                number.anyPropertyInt64 = (int)arc4random_uniform(256 * 256 * 256);
                number.anyPropertyInt = (int)arc4random_uniform(256);
                number.anyPropertyFloat =  -(float)((float)arc4random_uniform(3276800 * 2) * M_PI_2);
                number.anyPropertyDouble =  -(double)((double)arc4random_uniform(3276800 * 2) * M_PI_2);
                
                break;
        }
        skipper++;
        if (skipper == 3) skipper = 0;
        
        [array addObject:number];
    }
}

#pragma mark - Condor Sort Using Type
- (void)condorSortUsingType:(SortType)sort {
    
    NSString *selectorString = @"anyPropertyDouble";
    arraySize = [arraySizeTextField.text intValue];
    
    //Simple Timing
    NSDate *date = [NSDate date];
    
    switch (sort) {
        case ObjectDouble:
            
            [self objectArrayInitialization];
            
            selectorString = @"anyPropertyDouble";
            
            //Simple Timing
            date = [NSDate date];
            
            //DOUBLE OBJECT SORTING
            nsarray = [self.condorObjectSortDouble  sortDoubleObjectArray:nsmarray orderDesc:false selectorNameAsString:selectorString];
            
            break;
        case ObjectInt64:
            
            [self objectArrayInitialization];
            
            selectorString = @"anyPropertyInt64";
            
            //Simple Timing
            date = [NSDate date];
            
            nsarray = [self.condorObjectInt64Sort sortSignedInt64ObjectArray:nsmarray orderDesc:false selectorNameAsString:selectorString];
            
            break;
            
        case ObjectInt32:
            
            [self objectArrayInitialization];
            
            selectorString = @"anyPropertyInt";
            
            //Simple Timing
            date = [NSDate date];
            
            //INT OBJECT SORTING
            nsarray = [self.condorObjectSort sortSignedIntObjectArray:nsmarray orderDesc:false selectorNameAsString:selectorString];
            
            break;
            
        case Int32:
            
            arrayInt = (signed int*)calloc(arraySize, 4);
            
            for(int i = 0; i < arraySize/2; i++)
            {
                signed int value = ((signed int)arc4random_uniform(21474836));
                arrayInt[i] = (signed int)(value);
            }
            for(int i = arraySize/2; i < arraySize; i++)
            {
                signed int value = -((signed int)arc4random_uniform(21474836));
                arrayInt[i] = (signed int)(value);
            }
            
            //Simple Timing
            date = [NSDate date];
            
            [self.condorSort sortSignedIntArray:arrayInt withLength:arraySize];
            break;
            
        case Int64:
            
            arrayLongLong = (long long*)calloc(arraySize, 8);
            
            for(int i = 0; i < arraySize/2; i++)
            {
                long long value = ((long long)arc4random_uniform(2147483600));
                arrayLongLong[i] = value;
            }
            for(int i = arraySize/2; i < arraySize; i++)
            {
                long long value = -((long long)arc4random_uniform(2147483600));
                arrayLongLong[i] = value;
            }
            
            //Simple Timing
            date = [NSDate date];
            
            [self.condorSort sortSignedInt64Array:arrayLongLong withLength:arraySize];
            
            break;
            
        case Float:
            
            arrayFloat = (float*)calloc(arraySize, 4);
            
            for(int i = 0; i < arraySize; i++)
            {
                float value = (float)((arc4random_uniform(21836 * 2) / 100.0f)  - 21836.0f);
                arrayFloat[i] = (float)(value);
            }
            
            //Simple Timing
            date = [NSDate date];
            
            [self.condorSort sortFloatArray:arrayFloat withLength:arraySize];
            
            break;
            
        case Double:
            
            arrayDouble = (double*)calloc(arraySize, sizeof(double));
            
            for(int i = 0; i < arraySize; i++)
            {
                double value = (double)((arc4random_uniform(21836000 * 2) / 100.0)  - 21836000.0) * M_PI_4 ;
                arrayDouble[i] = (double)(value);
            }
            
            //Simple Timing
            date = [NSDate date];
            
            [self.condorSort sortDoubleArray:arrayDouble withLength:arraySize];
            
            break;
            
        default:
            break;
    }
    
    //Get Timing Result
    double timePassed_ms = [date timeIntervalSinceNow] * -1000.0;
    condorPerformanceLabel.text = [NSString stringWithFormat:@"%.2f ms", timePassed_ms];
    
    [self validateCondorSortResults:sort];
    NSLog(@"Performance: %f", timePassed_ms);
    [activityIndicator stopAnimating];
}

#pragma mark - Condor Results Validation Method
- (void)validateCondorSortResults:(SortType)sort {
    Boolean passed = true;
    
    switch (sort) {
        case ObjectDouble:
            
            arraySizeLabel.text =@"OBJECT DOUBLE ARRAY SIZE";
            
            //Validate sorting order if not output error
            for(int i = 1; i < arraySize-1; i++)
            {
                if([nsarray[i] anyPropertyDouble] < [nsarray[i-1] anyPropertyDouble])
                {
                    NSLog(@"Not Sort %f and %i", [nsarray[i] anyPropertyDouble], i);
                    passed = false;
                }
            }
            
            break;
        case ObjectInt64:
            
            arraySizeLabel.text = @"OBJECT INT64 ARRAY SIZE";
            
            //Validate sorting order if not output error
            Boolean passed = true;
            for(int i = 1; i < arraySize-1; i++)
            {
                if([nsarray[i] anyPropertyInt64] < [nsarray[i-1] anyPropertyInt64])
                {
                    NSLog(@"Not Sort %lld and %i", [nsarray[i] anyPropertyInt64], i);
                    passed = false;
                }
            }
            
            break;
            
        case ObjectInt32:
            
            arraySizeLabel.text = @"OBJECT INT32 ARRAY SIZE";
            
            //Validate sorting order if not output error
            for(int i = 1; i < arraySize-1; i++)
            {
                if([nsarray[i] anyPropertyInt] < [nsarray[i-1] anyPropertyInt])
                {
                    NSLog(@"Not Sort %d and %i", [nsarray[i] anyPropertyInt], i);
                    passed = false;
                }
            }
            
            break;
            
        case Int32:
            
            arraySizeLabel.text = @"INT32 ARRAY SIZE";
            
            passed = true;
            for(int i = 1; i < arraySize; i++)
            {
                if(arrayInt[i] < arrayInt[i-1])
                {
                    NSLog(@"Not Sort %i", i);
                    passed = false;
                    break;
                }
            }
            
            free(arrayInt);
            break;
            
        case Int64:
            
            arraySizeLabel.text = @"INT64 ARRAY SIZE";
            
            passed = true;
            for(int i = 1; i < arraySize; i++)
            {
                if(arrayLongLong[i] < arrayLongLong[i-1])
                {
                    NSLog(@"Not Sort %i", i);
                    passed = false;
                    break;
                }
            }
            
            free(arrayLongLong);
            break;
            
        case Float:
            
            arraySizeLabel.text = @"FLOAT ARRAY SIZE";
            
            passed = true;
            for(int i = 1; i < arraySize; i++)
            {
                if(arrayFloat[i] < arrayFloat[i-1])
                {
                    NSLog(@"Not Sort %f", arrayFloat[i]);
                    passed = false;
                    //break;
                }
            }
            
            free(arrayFloat);
            break;
            
        case Double:
            
            arraySizeLabel.text = @"DOUBLE ARRAY SIZE";
            
            passed = true;
            for(int i = 1; i < arraySize; i++)
            {
                if(arrayDouble[i] < arrayDouble[i-1])
                {
                    NSLog(@"Not Sort %f", arrayDouble[i]);
                    passed = false;
                    //break;
                }
            }
            
            free(arrayDouble);
            break;
            
        default:
            break;
    }
    
    if(passed == true) NSLog(@"In Order");
}

#pragma mark - Apple Sort Methods
- (IBAction)appleSortObjectDoubleButton:(id)sender {
    
    [self objectArrayInitialization];
    
    arraySizeLabel.text = @"OBJECT DOUBLE ARRAY SIZE";

    condorDescriptor = [[NSSortDescriptor alloc] initWithKey:@"anyPropertyDouble" ascending:YES];
    NSArray *sortDescriptors = @[condorDescriptor];
    
    [self appleSort:sortDescriptors];
}

- (IBAction)appleObjectIntSortButton:(id)sender {
    
    [self objectArrayInitialization];
    
    arraySizeLabel.text = @"OBJECT INT32 ARRAY SIZE";
    
    NSSortDescriptor *condorDescriptor = [[NSSortDescriptor alloc] initWithKey:@"anyPropertyInt" ascending:YES];
    NSArray *sortDescriptors = @[condorDescriptor];
    
    [self appleSort:sortDescriptors];
}

- (IBAction)appleObjectInt64SortButton:(id)sender {
    
    [self objectArrayInitialization];
    
    arraySizeLabel.text = @"OBJECT INT64 ARRAY SIZE";
    
    NSSortDescriptor *condorDescriptor = [[NSSortDescriptor alloc] initWithKey:@"anyPropertyInt64" ascending:YES];
    NSArray *sortDescriptors = @[condorDescriptor];
    
    [self appleSort:sortDescriptors];
}

#pragma mark - Apple Sort Using Descriptor
- (void)appleSort:(NSArray *)sortDescriptors {
    
    //Simple Timing
    NSDate *date = [NSDate date];
    
    //Apple Sorting Algorithm
    __unused NSArray *nsarray = [nsmarray sortedArrayUsingDescriptors:sortDescriptors];
    
    //Get Timing Result
    double timePassed_ms = [date timeIntervalSinceNow] * -1000.0;
    applePerformanceLabel.text = [NSString stringWithFormat:@"%.2f ms", timePassed_ms];
    
    [activityIndicator stopAnimating];
}

#pragma mark - Apple Sort Array Initialization Method
- (void)objectArrayInitialization {
    //Generate an Array of MyDataModel Objects with Random Property values.
    nsmarray = [[NSMutableArray alloc] init];
    [self buildTestArray:nsmarray];
}

#pragma mark - RADIX and QuickSort C Methods
- (IBAction)appleInt32SortButton:(id)sender {
    
    arraySize = [arraySizeTextField.text intValue];
    
    signed int* array = (signed int*)calloc(arraySize, 4);
    
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
    
    quickSort(array, 0, arraySize-1);
    
    double timePassed_ms = [date timeIntervalSinceNow] * -1000.0;
    applePerformanceLabel.text = [NSString stringWithFormat:@"%.2f ms", timePassed_ms];
    arraySizeLabel.text = @"QUICKSORT INT32 ARRAY SIZE";
    
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

- (IBAction)appleInt32RADIXSortButton:(id)sender {
    
    arraySize = [arraySizeTextField.text intValue];
    signed int* array = (signed int*)calloc(arraySize, 4);
    
    for(int i = 0; i < arraySize; i++)
    {
        signed int value = ((signed int)arc4random_uniform(21474836));
        array[i] = (signed int)(value);
    }
    
    //Simple Timing
    NSDate *date = [NSDate date];
    
    radixSort(array,arraySize);
    
    double timePassed_ms = [date timeIntervalSinceNow] * -1000.0;
    applePerformanceLabel.text = [NSString stringWithFormat:@"%.2f ms", timePassed_ms];
    arraySizeLabel.text = @"RADIX INT32 ARRAY SIZE";
    
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

#pragma mark - QuickSort function
void swap(int *x,int *y)
{
    int temp;
    temp = *x;
    *x = *y;
    *y = temp;
}

int choosePivot(int i,int j )
{
    return((i+j) /2);
}

void quickSort(int list[],int m,int n)
{
    int key,i,j,k;
    if( m < n)
    {
        k = choosePivot(m,n);
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
        quickSort(list,m,j-1);
        quickSort(list,j+1,n);
    }
}

#pragma mark - RADIX Sort function
#define max 10
void radixSort(int *array, int n) {
    int i, exp = 1, m = 0;
    int *bucket = (int *) malloc(n * sizeof(int));
    int *temp = (int *) malloc(n * sizeof(int));
    
    for(i = 0; i < n; i++) {
        if(array[i] > m) {
            m = array[i];
        }
    }
    
    while((m/exp) > 0) {
        for (i = 0; i < n; i++) {
            bucket[i] = 0;
        }
        for(i = 0; i < n; i++) {
            bucket[(array[i] / exp) % 10]++;
        }
        for(i = 1; i < n; i++) {
            bucket[i] += bucket[i-1];
        }
        for(i = (n - 1); i >= 0; i--) {
            temp[--bucket[(array[i] / exp) % 10]] = array[i];
        }
        for(i = 0; i < n; i++) {
            array[i] = temp[i];
        }
        exp *= 10;
    }
    
    free(bucket);
    free(temp);
}

@end
