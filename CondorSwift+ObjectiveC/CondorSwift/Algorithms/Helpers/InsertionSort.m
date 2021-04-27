//
//    InsertionSort.m
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

#import "InsertionSort.h"

#pragma BackgroundTasks FALSE
#pragma BoundsChecking FALSE
#pragma StackOverflowchecking FALSE
#pragma NilObjectChecking FALSE

@interface InsertionSort()
{
    short *numbers16sInsertion;
    unsigned short*numbers16Insertion;
    unsigned int*numbers32Insertion;
    signed int *numbers32sInsertion;
    float* numbersFloatInsertion;
    unsigned char* numbersInsertion;
    int sizeInsertion;
}

@end

@implementation InsertionSort

-(void) sortArray:(unsigned char*) array withLength:(int)length
{
    numbersInsertion = array;
    sizeInsertion = length;
    
    [self insertion];
}

-(void) insertion
{
    for (int i = 1; i < sizeInsertion; i++)
    {
        unsigned char key = numbersInsertion[i];
        int j = i - 1;
        while (j >= 0)
        {
            if (key < numbersInsertion[j])
            {
                numbersInsertion[j + 1] = numbersInsertion[j];
                j--;
            }
            else
            {
                break;
            }
        }
        numbersInsertion[j + 1] = key;
    }
}

#pragma mark - UInt32
-(void) sortArray32:(unsigned int*) array withLength:(int)length
{
    numbers32Insertion = array;
    sizeInsertion = length;
    
    [self insertionSort32];
}

-(void) insertionSort32
{
    for (int i = 1; i < sizeInsertion; i++)
    {
        unsigned int key = numbers32Insertion[i];
        int j = i - 1;
        while (j >= 0)
        {
            if (key < numbers32Insertion[j])
            {
                numbers32Insertion[j + 1] = numbers32Insertion[j];
                j--;
            }
            else
            {
                break;
            }
        }
        numbers32Insertion[j + 1] = key;
    }
}

-(void) sortArray32:(unsigned int*) array withLength:(int)length fromLow:(int)low toHigh:(int) high
{
    numbers32Insertion = array;
    sizeInsertion = length;

    [self insertionSort32WithLow:low andHigh: high];

    //numbers32Insertion = NULL;
}

-(void) insertionSort32WithLow:(int) low andHigh:(int) high
{
    for (int i = low + 1; i < high; i++)
    {
        unsigned int key = numbers32Insertion[i];
        int j = i - 1;
        while (j >= 0)
        {
            if (key < numbers32Insertion[j])
            {
                numbers32Insertion[j + 1] = numbers32Insertion[j];
                j--;
            }
            else
            {
                break;
            }
        }
        numbers32Insertion[j + 1] = key;
    }
}

#pragma mark - UInt16
-(void) sortArrayUnsignedShort:(unsigned short *) array withLength:(int)length fromLow:(int) low toHigh:(int) high
{
    numbers16Insertion = array;
    sizeInsertion = length;
    
    [self insertionSort16WithLow:low andHigh:high];
}

-(void) insertionSort16WithLow:(int) low andHigh:(int) high
{
    for (int i = low + 1; i < high; i++)
    {
        unsigned short key = numbers16Insertion[i];
        int j = i - 1;
        while (j >= 0)
        {
            if (key < numbers16Insertion[j])
            {
                numbers16Insertion[j + 1] = numbers16Insertion[j];
                j--;
            }
            else
            {
                break;
            }
        }
        numbers16Insertion[j + 1] = key;
    }
}

#pragma mark - Int16
-(void) sortArraySignedShort:(signed short*) array withLength:(int)length fromLow:(int) low toHigh:(int) high
{
    numbers16sInsertion = array;
    sizeInsertion = length;
    
    [self insertionSort16sWithLow:low andHigh: high];
}

-(void) insertionSort16sWithLow:(int) low andHigh:(int) high
{
    for (int i = low + 1; i < high; i++)
    {
        signed short key = numbers16sInsertion[i];
        int j = i - 1;
        while (j >= 0)
        {
            if (key < numbers16sInsertion[j])
            {
                numbers16sInsertion[j + 1] = numbers16sInsertion[j];
                j--;
            }
            else
            {
                break;
            }
        }
        numbers16sInsertion[j + 1] = key;
    }
}

#pragma mark - 32BIT SIGNED
-(void) sortArraySignedInt:(signed int*) array withLength:(int)length fromLow:(int) low toHigh:(int) high
{
    numbers32sInsertion = array;
    sizeInsertion = length;
    
    [self insertionSort32sWithLow:low andHigh: high];
    //numbers32sInsertion = NULL;
}

-(void) insertionSort32sWithLow:(int) low andHigh:(int) high
{
    for (int i = low + 1; i < high; i++)
    {
        signed int key = numbers32sInsertion[i];
        int j = i - 1;
        while (j >= 0)
        {
            if (key < numbers32sInsertion[j])
            {
                numbers32sInsertion[j + 1] = numbers32sInsertion[j];
                j--;
            }
            else
            {
                break;
            }
        }
        numbers32sInsertion[j + 1] = key;
    }
}

#pragma mark - FLOAT
-(void) sortArrayFloat:(float*) array withLength:(int)length fromLow:(int) low toHigh:(int) high
{
    numbersFloatInsertion = array;
    sizeInsertion = length;
    
    [self insertionSortFloatWithLow:low andHigh: high];
}

-(void) insertionSortFloatWithLow:(int) low andHigh:(int) high
{
    for (int i = low + 1; i < high; i++)
    {
        float key = numbersFloatInsertion[i];
        int j = i - 1;
        while (j >= 0)
        {
            if (key < numbersFloatInsertion[j])
            {
                numbersFloatInsertion[j + 1] = numbersFloatInsertion[j];
                j--;
            }
            else
            {
                break;
            }
        }
        numbersFloatInsertion[j + 1] = key;
    }
}

@end
