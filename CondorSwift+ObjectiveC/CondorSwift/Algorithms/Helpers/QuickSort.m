//
//    QuickSort.m
//    Condor
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

#import "QuickSort.h"
#import "InsertionSort.h"

#pragma BackgroundTasks FALSE
#pragma BoundsChecking FALSE
#pragma StackOverflowchecking FALSE
#pragma NilObjectChecking FALSE

@interface QuickSort()
{
    float *numbersFloatQuick;
    unsigned int*numbers32Quick;
    unsigned char *numbersQuick;
    int sizeQuick;
}

@property (strong, nonatomic) InsertionSort *insertionSort;

@end

@implementation QuickSort
@synthesize insertionSort;

#pragma mark - UInt32
-(void) sortArray32:(unsigned int *) array withLength:(int)length
{
    insertionSort = [[InsertionSort alloc] init];
    numbers32Quick = array;
    sizeQuick = length;
    
    [self quickSort32WithLow: 0 andHigh: sizeQuick - 1];
}

-(void) sortArray32:(unsigned int *)array ofLength:(int) length withLow:(int) low andHigh:(int) high
{
    insertionSort = [[InsertionSort alloc] init];
    numbers32Quick = array;
    sizeQuick = length;
    
    [self quickSort32WithLow:low andHigh: high - 1];
}

-(void) quickSort32WithLow:(int) low andHigh:(int) high
{
    if (high - low > 10)
    {
        int i = low;
        int j = high;
        
        UInt32 pivot = numbers32Quick[low + (high - low) / 2];
        
        while (i <= j)
        {
            while (numbers32Quick[i] < pivot)
            {
                i++;
            }
            
            while (numbers32Quick[j] > pivot)
            {
                j--;
            }
            
            if (i <= j)
            {
                [self exchange32:i with: j];
                i++;
                j--;
            }
        }
        
        if (low < j)
        {
            [self quickSort32WithLow:low andHigh: j];
        }
        if (i < high)
        {
            [self quickSort32WithLow: i andHigh: high];
        }
    }
    else
    {
        [insertionSort sortArray32:numbers32Quick withLength:sizeQuick fromLow:low toHigh:high];
    }
}

-(void) exchange32:(int) i with:(int) j
{
    UInt32 temp = numbers32Quick[i];
    numbers32Quick[i] = numbers32Quick[j];
    numbers32Quick[j] = temp;
}

#pragma mark - FLOAT
-(void) sortArray:(float*) array ofLength:(int)length withLow: (int) low andHigh:(int) high
{
    insertionSort = [[InsertionSort alloc] init];
    numbersFloatQuick = array;
    sizeQuick = length;
    
    [self quickSortFloatWithLow:low andHigh: high];
}

-(void) quickSortFloatWithLow:(int) low andHigh:(int) high
{
    if (high - low > 10)
    {
        int i = low;
        int j = high;
        
        float pivot = numbersFloatQuick[low + (high - low) / 2];
        
        while (i <= j)
        {
            while (numbersFloatQuick[i] < pivot)
            {
                i++;
            }
            
            while (numbersFloatQuick[j] > pivot)
            {
                j--;
            }
            
            if (i <= j)
            {
                [self exchangeFloat:i with: j];
                i++;
                j--;
            }
        }
        
        if (low < j)
        {
            [self quickSortFloatWithLow:low andHigh:j];
        }
        if (i < high)
        {
            [self quickSortFloatWithLow:i andHigh: high];
        }
    }
    else
    {
        [insertionSort sortArrayFloat:numbersFloatQuick withLength:sizeQuick fromLow:low toHigh:high];
    }
}

-(void) exchangeFloat:(int) i with: (int) j
{
    float temp = numbersFloatQuick[i];
    numbersFloatQuick[i] = numbersFloatQuick[j];
    numbersFloatQuick[j] = temp;
}
@end
