//
//    CondorSort.m
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

#import "CondorSort.h"
#import "QuickSort.h"
#import "InsertionSort.h"

#pragma BackgroundTasks FALSE
#pragma BoundsChecking FALSE
#pragma StackOverflowchecking FALSE
#pragma NilObjectChecking FALSE

static int size;
Boolean *numbersBool;
signed short *numbers16s;
unsigned short *numbers16;
unsigned int *numbers32;
signed int *numbers32s;
signed long long *numbers64s;
float* numbersFloat;
double* numbersDouble;
NSArray* numbersNSNumbers;
long correction;
long min;

long long correction64;
long long min64;

static int numcpus = 2;
static int numberOfThreads(int ncpu) {
    
    int threads = 2;
    switch (ncpu) {
        case 1:
            threads =  1;
            break;
        case 2:
        case 3:
            threads =  2;
            break;
        case 4:
        case 5:
        case 6:
        case 7:
            threads =  4;
            break;
        case 8:
        case 9:
        case 10:
        case 11:
        case 12:
        case 13:
        case 14:
        case 15:
            threads =  8;
            break;
        case 16:
        case 17:
        case 18:
        case 19:
        case 20:
        case 21:
        case 22:
        case 23:
        case 24:
        case 25:
        case 26:
        case 27:
        case 28:
        case 29:
        case 30:
        case 31:
            threads =  16;
            break;
        case 32:
        case 33:
        case 34:
        case 35:
        case 36:
        case 37:
        case 38:
        case 39:
        case 40:
        case 41:
        case 42:
        case 43:
        case 44:
        case 45:
        case 46:
        case 47:
        case 48:
        case 49:
        case 50:
        case 51:
        case 52:
        case 53:
        case 54:
        case 55:
        case 56:
        case 57:
        case 58:
        case 59:
        case 60:
        case 61:
        case 62:
        case 63:
            threads =  32;
            break;
        case 64:
            threads =  64;
            break;
        default:
            threads = 64;
            break;
    }
    
    return threads;
}

@interface CondorSort()

    @property (strong, nonatomic) QuickSort *quickSort;
    @property (strong, nonatomic) InsertionSort *insertionSort;

@end

@implementation CondorSort

#pragma mark -BOOLEAN
-(void) sortBooleanArray:(Boolean*) array withLength:(int)length
{
    if(array == nil) return;
    if(length < 2) return;
    numbersBool = array;
    int size = length;
    
    int added = 0;
    int i = 0;
    int low = 0;
    
    while (i < size)
    {
        unsigned char value = 0;
        if (numbersBool[i] == true) value = 1;
        
        if (value < 1)
        {
            if (i > low + added)
            {
                int j = low + added;
                [self exchangeBoolean:i with: j];
                added++;
            }
            else
            {
                added++;
                i = low + added;
            }
        }
        else
        {
            i++;
        }
    }
}

-(void) exchangeBoolean:(int) i with:(int) j
{
    Boolean temp = numbersBool[i];
    numbersBool[i] = numbersBool[j];
    numbersBool[j] = temp;
}

#pragma mark - 8BIT UNSIGNED
-(void) sortUnsignedCharArray:(unsigned char *)array withLength:(int) length
{
    if(array == nil) return;
    if(length < 2) return;
    int* count = (int*)calloc(256,sizeof(int));
    int size = length;
    
    //BUILD COUNTING FOR BOUNDARY
    for (int i = 0; i < size; i++)
    {
        int value = (int)array[i];
        count[value]++;
    }
    
    int arrayPosition = 0;
    for (int i = 0; i < 256; i++)
    {
        int j = 0;
        while (j < count[i])
        {
            array[arrayPosition] = (UInt8)(i);
            arrayPosition++;
            j++;
        }
    }
    arrayPosition = 0;
    free(count);
}

#pragma mark - 8BIT SIGNED
-(void) sortSignedCharArray:(signed char *) array withLength:(int) length
{
    if(array == nil) return;
    if(length < 2) return;
    int* count = (int*)calloc(256,sizeof(int));
    int size = length;
    
    //BUILD COUNTING FOR BOUNDARY
    for (int i = 0; i < size; i++)
    {
        int value = (int)array[i]  + 128;
        count[value]++;
    }
    
    int arrayPosition = 0;
    for (int i = 0; i < 256; i++)
    {
        int j = 0;
        while (j < count[i])
        {
            array[arrayPosition] = (signed char)(i - 128);
            arrayPosition++;
            j++;
        }
    }
    arrayPosition = 0;
    free(count);
}


#pragma mark - 16BIT SIGNED
-(void) sortSignedShortArray:(signed short *) array withLength:(int) length
{
    if(array == nil) return;
    if(length < 2) return;
    numbers16s = array;
    size = length;
    
    [self dividInToQuadrants16sFromLow:0 toHigh:size withShift: 0];
}

-(void) dividInToQuadrants16sFromLow:(int) low toHigh:(int) high withShift:(int) shift
{
    int added = 0;
    int i = low;
    
    int* subcount = (int*)calloc(256,sizeof(int));
    int subtotal = 0;
    
    while (i < high)
    {
        UInt16 value16s = (UInt16)(numbers16s[i] + 32768);
        
        if (value16s < 256)
        {
            subcount[value16s]++;
            subtotal++;
            
            if (i > low + added)
            {
                int j = low + added;
                [self exchange16s:i with: j];
                added++;
            }
            else
            {
                added++;
                i = low + added;
            }
        }
        else
        {
            i++;
        }
    }
    
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    dispatch_semaphore_t sema1 = dispatch_semaphore_create(0);

    //SORT LSB
    if (added > 1)
    {
        dispatch_async(dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT_WITH_AUTORELEASE_POOL), ^{
            [self sort16sFromLow:0 toHigh:added withShift:shift andMaybeSubCount:subcount withTotal: subtotal];
            if(subcount !=NULL) free(subcount);
            dispatch_semaphore_signal(sema);
        });
    }
    else
    {
        dispatch_semaphore_signal(sema);
    }

    //SORT MIDDLE ARRAY
    if ((high + 1) - added > 1)
    {
        dispatch_async(dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT_WITH_AUTORELEASE_POOL), ^{
            [self sort16sFromLow:added toHigh: high withShift: 1 andMaybeSubCount:NULL withTotal: 0];
            dispatch_semaphore_signal(sema1);
        });
    }
    else
    {
        dispatch_semaphore_signal(sema1);
    }
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    dispatch_semaphore_wait(sema1, DISPATCH_TIME_FOREVER);
    
}

-(void) exchange16s:(int) i with:(int) j
{
    self.insertionSort = [[InsertionSort alloc] init];
    signed short temp = numbers16s[i];
    numbers16s[i] = numbers16s[j];
    numbers16s[j] = temp;
}

-(void) sort16sFromLow:(int) low toHigh:(int) high withShift:(int) shift andMaybeSubCount:(int*) subcount withTotal:(int) subtotal
{
    if (high - low > 10)
    {
        int* count;
        if (subcount != NULL)
        {
            count = subcount;
        }
        else
        {
            count = (int*)calloc(256,sizeof(int));
        }
        
        UInt16 shiftbits = (UInt16)(shift * 8);
        UInt16 mask = (UInt16)(0x00FF << shiftbits);
        int totalcounted = subtotal;
        
        int* sub2count = NULL;
        int sub2total = 0;
        
        //BUILD COUNTING FOR BOUNDARY
        if (subcount == NULL)
        {
            if (shift == 0)
            {
                for (int i = low; i < high; i++)
                {
                    UInt16 value16s = (UInt16)(numbers16s[i] + 32768);
                    UInt16 countvalue = (UInt16)(value16s & mask);
                    countvalue = (unsigned short)(countvalue >> shiftbits);
                    count[countvalue]++;
                    
                    totalcounted++;
                }
            }
            else
            {
                sub2count = calloc(256,sizeof(int));
                int shiftbits2 = (shift - 1) * 8;
                UInt16 submask = (UInt16)(0xFFFF >> ((2 - shift) * 8));
                for (int i = low; i < high; i++)
                {
                    UInt16 value16s = (UInt16)(numbers16s[i] + 32768);
                    UInt16 countvalue = (UInt16)(value16s & mask);
                    countvalue = (UInt16)(countvalue >> shiftbits);
                    count[countvalue]++;
                    
                    if (countvalue == 0)
                    {
                        UInt16 subcountvalue = (UInt16)(value16s & submask);
                        subcountvalue = (UInt16)(subcountvalue >> shiftbits2);
                        sub2count[subcountvalue]++;
                        sub2total++;
                    }
                    totalcounted++;
                }
            }
        }
        
        if (shift > 0)
        {
            int boundaries[256];// = calloc(256,sizeof(int));
            int* added = calloc(256,sizeof(int));
            
            //BUILD BOUNDARIES
            boundaries[0] = low;
            for (int i = 1; i < 256; i++)
            {
                boundaries[i] = boundaries[i - 1] + count[i - 1];
            }
            
            //int j = low;
            while (low < high)
            {
                UInt16 value16s = (UInt16)(numbers16s[low] + 32768);
                UInt16 value16 = (UInt16)(((value16s & mask) >> shiftbits));
                
                if (low >= boundaries[value16] && low <= boundaries[value16] + count[value16])
                {
                    //STABILITY LEAVE VALUE IN PLACE IF IT BELONGS IN THIS BOUNDARY
                    if (low < boundaries[value16] + added[value16])
                    {
                        low = boundaries[value16] + added[value16];
                    }
                    else
                    {
                        low++;
                        added[value16]++;
                    }
                }
                else
                {
                    //PLACE VALUE IN CORRECT BOUNDARY
                    int k = boundaries[value16] + added[value16];
                    numbers16s[low] = numbers16s[k];
                    numbers16s[k] = (signed short)(value16s - 32768);
                    added[value16]++;
                }
            }
            if (count[0] > 1)
            {
                //SORT EACH BOUNDARY
                [self sort16sFromLow:boundaries[0] toHigh: boundaries[0] + count[0] withShift: shift - 1 andMaybeSubCount:   sub2count withTotal: sub2total];
                free(sub2count);
            }
            
            for (long i = 1; i < 256; i++)
            {
                if (count[i] > 1)
                {
                    //SORT EACH BOUNDARY
                    [self sort16sFromLow:boundaries[i] toHigh: boundaries[i] + count[i] withShift: shift - 1 andMaybeSubCount:  NULL withTotal: 0];
                }
            }
            //free(boundaries);
            free(added);
        }
        else
        {
            if (totalcounted > 1)
            {
                //USE COUNT SORT ON LSD BOUNDARIES
                mask = 0xFF00;
                int arrayPosition = low;
                
                for (int j = 0; j < 256; j++)
                {
                    int k = 0;
                    
                    while (k < count[j])
                    {
                        UInt16 value16s = (UInt16)(numbers16s[arrayPosition] + 32768);
                        UInt16 value = (UInt16)(value16s & mask);
                        numbers16s[arrayPosition] = (signed short)(value + j - 32768);
                        arrayPosition++;
                        k++;
                    }
                }
            }
        }
        if (subcount == NULL) free(count);
    }
    else
    {
        [self.insertionSort sortArraySignedShort:numbers16s withLength:size fromLow:low toHigh:high];
    }
}

#pragma mark- 16BIT UNSIGNED
-(void) sortUnsignedShortArray:(unsigned short *) array withLength:(int) length
{
    if(array == nil) return;
    if(length < 2) return;
    numbers16 = array;
    size = length;
    
    [self dividInToQuadrants16WithLow:0 andHigh: size withShift:0];
}

-(void) dividInToQuadrants16WithLow:(int) low andHigh:(int) high withShift:(int) shift
{
    int added = 0;
    int i = low;
    
    int* subcount = calloc(256,sizeof(int));
    int subtotal = 0;
    
    while (i < high)
    {
        if (numbers16[i] < 256)
        {
            subcount[numbers16[i]]++;
            subtotal++;
            
            if (i > low + added)
            {
                int j = low + added;
                [self exchange16:i with: j];
                added++;
            }
            else
            {
                added++;
                i = low + added;
            }
        }
        else
        {
            i++;
        }
    }

    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    dispatch_semaphore_t sema1 = dispatch_semaphore_create(0);
    
    //SORT LSB
    if (added > 1)
    {
        dispatch_async(dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT_WITH_AUTORELEASE_POOL), ^{
            [self sort16FromLow:0 toHigh: added withShift: shift andMaybeSubCount: subcount withTotal: subtotal];
            if(subcount !=NULL) free(subcount);
            dispatch_semaphore_signal(sema);
        });
    }
    else
    {
        dispatch_semaphore_signal(sema);
    }
    
    //SORT MIDDLE ARRAY
    if ((high + 1) - added > 1)
    {
        dispatch_async(dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT_WITH_AUTORELEASE_POOL), ^{
            [self sort16FromLow:added toHigh: high withShift: 1 andMaybeSubCount:NULL withTotal:0];
            dispatch_semaphore_signal(sema1);
        });
    }
    else
    {
        dispatch_semaphore_signal(sema1);
    }
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    dispatch_semaphore_wait(sema1, DISPATCH_TIME_FOREVER);
}

-(void) exchange16:(int) i with: (int) j
{
    UInt16 temp = numbers16[i];
    numbers16[i] = numbers16[j];
    numbers16[j] = temp;
}

-(void) sort16FromLow:(int) low toHigh:(int) high withShift:(int) shift andMaybeSubCount:(int*) subcount withTotal: (int) subtotal
{
    if (high - low > 10)
    {
        int* count;
        if (subcount != NULL)
        {
            count = subcount;
        }
        else
        {
            count = calloc(256,sizeof(int));
        }
        
        UInt16 shiftbits = (UInt16)(shift * 8);
        UInt16 mask = (UInt16)(0x00FF << shiftbits);
        int totalcounted = subtotal;
        
        int* sub2count = NULL;
        int sub2total = 0;
        
        //BUILD COUNTING FOR BOUNDARY
        if (subcount == NULL)
        {
            if (shift == 0)
            {
                for (int i = low; i < high; i++)
                {
                    UInt16 countvalue = (UInt16)(numbers16[i] & mask);
                    countvalue = (UInt16)(countvalue >> shiftbits);
                    count[countvalue]++;
                    
                    totalcounted++;
                }
            }
            else
            {
                sub2count = calloc(256,sizeof(int));
                int shiftbits2 = (shift - 1) * 8;
                UInt16 submask = (UInt16)(0xFFFF >> ((2 - shift) * 8));
                for (int i = low; i < high; i++)
                {
                    UInt16 countvalue = (UInt16)(numbers16[i] & mask);
                    countvalue = (UInt16)(countvalue >> shiftbits);
                    count[countvalue]++;
                    
                    if (countvalue == 0)
                    {
                        UInt16 subcountvalue = (UInt16)(numbers16[i] & submask);
                        subcountvalue = (UInt16)(subcountvalue >> shiftbits2);
                        sub2count[subcountvalue]++;
                        sub2total++;
                    }
                    totalcounted++;
                }
            }
        }
        
        if (shift > 0)
        {
            int boundaries[256];// = calloc(256,sizeof(int));
            int* added = calloc(256,sizeof(int));
            
            //BUILD BOUNDARIES
            boundaries[0] = low;
            for (int i = 1; i < 256; i++)
            {
                boundaries[i] = boundaries[i - 1] + count[i - 1];
            }
            
            while (low < high)
            {
                UInt16 value = numbers16[low];
                UInt16 value16 = (UInt16)(((value & mask) >> shiftbits));
                
                if (low >= boundaries[value16] && low <= boundaries[value16] + count[value16])
                {
                    //STABILITY LEAVE VALUE IN PLACE IF IT BELONGS IN THIS BOUNDARY
                    if (low < boundaries[value16] + added[value16])
                    {
                        low = boundaries[value16] + added[value16];
                    }
                    else
                    {
                        low++;
                        added[value16]++;
                    }
                }
                else
                {
                    //PLACE VALUE IN CORRECT BOUNDARY
                    int k = boundaries[value16] + added[value16];
                    numbers16[low] = numbers16[k];
                    numbers16[k] = value;
                    added[value16]++;
                }
            }
            if (count[0] > 1)
            {
                //SORT EACH BOUNDARY
                [self sort16FromLow:boundaries[0] toHigh: boundaries[0] + count[0] withShift: shift - 1 andMaybeSubCount: sub2count withTotal: sub2total];
                free(sub2count);
            }
            
            for (long i = 1; i < 256; i++)
            {
                if (count[i] > 1)
                {
                    //SORT EACH BOUNDARY
                    [self sort16FromLow:boundaries[i] toHigh: boundaries[i] + count[i] withShift: shift - 1 andMaybeSubCount: NULL withTotal: 0];
                }
            }
            
            //free(boundaries);
            free(added);
        }
        else
        {
            if (totalcounted > 1)
            {
                //USE COUNT SORT ON LSD BOUNDARIES
                mask = 0xFF00;
                int arrayPosition = low;
                
                for (int j = 0; j < 256; j++)
                {
                    int k = 0;
                    
                    while (k < count[j])
                    {
                        UInt16 value = (UInt16)(numbers16[arrayPosition] & mask);
                        numbers16[arrayPosition] = (UInt16)(value + j);
                        arrayPosition++;
                        k++;
                    }
                }
            }
        }
        if (subcount ==  NULL)free(count);
    }
    else
    {
        [self.insertionSort sortArrayUnsignedShort:numbers16 withLength:size fromLow:low toHigh:high];
    }
}

#pragma mark - 32BIT UNSIGNED
-(void) sortUnsignedIntArray:(unsigned int*) array withLength:(int) length
{
    
   
    

    
    if(array == nil) return;
    if(length < 2) return;
    numbers32 = array;
    min = 2147483647;
    size = length;

    if(size > 1000)
    {
        numcpus = numberOfThreads((int)[[NSProcessInfo processInfo] processorCount]);
        long *minArray = (long *)malloc(numcpus*sizeof(long));
        for(int i = 0; i < numcpus; i++) {
            minArray[i] = min;
        }
    
//        long *minArray = (long *)malloc(4*sizeof(long));
//        minArray[0] = min;
//        minArray[1] = min;
//        minArray[2] = min;
//        minArray[3] = min;
        
        numcpus = 2;
        dispatch_queue_t queue = dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT_WITH_AUTORELEASE_POOL);
        dispatch_apply(numcpus, queue, ^(size_t j){
            long start = (size/numcpus) * j;
            long end = (size/numcpus) * (j+1);
            if(end > size) end = size;
            for (long i = start; i < end; i++)
            {
                if(minArray[j] > array[i]) minArray[j] = array[i];
            }
        });
        
        for(int i = 0; i < numcpus; i++) {
            if(min > minArray[i]) min = minArray[i];
        }
        
//        for (int i = 0; i < 4; i++)
//        {
//            if(min > minArray[i]) min = minArray[i];
//        }
    }
//    else
//    {
//        for (int i = 0; i < size; i++)
//        {
//            //numbers32[i] = array[i];
//            if(min > array[i]) min = array[i];
//        }
//    }
    
    if(min < 0)
    {
        correction = -min;
    }
    else if(min > 0)
    {
        correction = -min;
    }
    
    [self dividInToQuadrantsUnsignedIntWithLow:0 andHigh: size-1 withShift: 0];
}

-(void) dividInToQuadrantsUnsignedIntWithLow:(int) low andHigh:(int) high withShift:(int) shift
{
    int* added = calloc(2,sizeof(int));
    added[0] = 0;
    added[1] = 0;
    int i = low;
    
    int* subcount = calloc(256,sizeof(int));
    int subtotal = 0;

    int* subcount2 = calloc(256,sizeof(int));
    int subtotal2 = 0;
    
    while (i < high)
    {
        UInt32 value32s = (UInt32)numbers32[i];
        
        if (i > high - added[1])
        {
            break;
        }
        
        if (value32s < 65536)
        {
//            subcount[value32s]++;
            subcount[value32s >> 8]++;
            subtotal++;
            
            if (i > low + added[0])
            {
                int j = low + added[0];
                exchange32(i, j);
                added[0]++;
            }
            else
            {
                added[0]++;
                i = low + added[0];
            }
        }
        else if (value32s > 16777215)
        {
            subcount2[value32s >> 24]++;
            subtotal2++;
            
            int j = high - added[1];
            exchange32(i, j);
            added[1]++;
        }
        else
        {
            i++;
        }
    }
    
    if(size > 100)
    {
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        dispatch_semaphore_t sema1 = dispatch_semaphore_create(0);
        dispatch_semaphore_t sema2 = dispatch_semaphore_create(0);
        
        //SORT LSB
        int added0 = added[0];
        int added1 = added[1];
        
        if (added[0] > 1){
            
            dispatch_async(dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT_WITH_AUTORELEASE_POOL), ^{
                //SORT LSB
                 sort32FromLow(0, added0, 1, subcount, subtotal, true);
                 if(subcount !=NULL) free(subcount);
                 dispatch_semaphore_signal(sema);
            });
        }
        else
        {
            dispatch_semaphore_signal(sema);
        }

        //SORT MIDDLE ARRAY
         if ((high - 1 - added1) - added0 > 1){
            dispatch_async(dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT_WITH_AUTORELEASE_POOL), ^{
                sort32FromLow(added0 ,high - added1 + 1 , 2 , NULL , 0, true);
                
                dispatch_semaphore_signal(sema1);
            });
        }
        else
        {
            dispatch_semaphore_signal(sema1);
        }
        
        //SORT MSB
        if (added1 > 1) {
            dispatch_async(dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT_WITH_AUTORELEASE_POOL), ^{
                sort32FromLow((high - added1) + 1 ,high + 1 ,3 ,subcount2 ,subtotal2, true);
                if(subcount2 !=NULL) free(subcount2);
                dispatch_semaphore_signal(sema2);
            });
        }
        else
        {
            dispatch_semaphore_signal(sema2);
        }
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(sema1, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(sema2, DISPATCH_TIME_FOREVER);
    }
    else
    {
        if(subcount !=NULL) free(subcount);
        if(subcount2 !=NULL) free(subcount2);
        insertionSort32WithLow(0 ,size);
    }
}

inline void exchange32(int i, int j)
{
    UInt32 temp = numbers32[i];
    numbers32[i] = numbers32[j];
    numbers32[j] = temp;
}

void sort32FromLow(int low, int high, int shift,int* subcount, int subtotal, bool useGCD)
{
    if (high - low > 20)
    {
        int* count;
        if (subcount != NULL)
        {
            count = subcount;
        }
        else
        {
            count = calloc(256,sizeof(int));
        }
        
        int shiftbits = shift * 8;
        UInt32 mask = (UInt32)(0x000000FF << shiftbits);
        //BUILD COUNTING FOR BOUNDARY
        if (subcount == NULL)
        {
            for (int i = low; i < high; i++)
            {
                UInt32 value32s = (UInt32)(numbers32[i] );
                UInt32 countvalue = (UInt32)(value32s & mask);
                countvalue = countvalue >> shiftbits;
                count[countvalue]++;
            }
        }
        
        int *boundaries = calloc(256,sizeof(int));
        int* added = calloc(256,sizeof(int));
        
        //BUILD BOUNDARIES
        boundaries[0] = low;
        for (int i = 1; i < 256; i++)
        {
            boundaries[i] = boundaries[i - 1] + count[i - 1];
        }
        
        //int j = low;
        while (low < high)
        {
            UInt32 value = (UInt32)(numbers32[low] );
            UInt32 value32 = (UInt32)(((value & mask) >> shiftbits));
            
            if (low >= boundaries[value32] && low <= boundaries[value32] + count[value32])
            {
                //STABILITY LEAVE VALUE IN PLACE IF IT BELONGS IN THIS BOUNDARY
                if (low < boundaries[value32] + added[value32])
                {
                    low = boundaries[value32] + added[value32];
                }
                else
                {
                    low++;
                    added[value32]++;
                }
            }
            else
            {
                //PLACE VALUE IN CORRECT BOUNDARY
                int k = boundaries[value32] + added[value32];
                exchange32(low, k);
                added[value32]++;
            }
        }
        
        if(shift > 0)
        {
            if(useGCD){
            numcpus = numberOfThreads((int)[[NSProcessInfo processInfo] processorCount]);
            dispatch_queue_t queue = dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT_WITH_AUTORELEASE_POOL);
            dispatch_apply(numcpus, queue, ^(size_t i){
                
                long start = (256/numcpus) * i;
                long end = (256/numcpus) * (i+1);
                if(end > 256) end = 256;
                for (long i = start; i < end; i++)
                {
                    if (count[i] > 1)
                    {
                        //SORT EACH BOUNDARY
                        sort32FromLow(boundaries[i], boundaries[i] + count[i], shift - 1, NULL, 0, false);
                    }
                }
            });
            } else {
                for (long i = 0; i < 256; i++)
                {
                    if (count[i] > 1)
                    {
                        //SORT EACH BOUNDARY
                        sort32FromLow(boundaries[i], boundaries[i] + count[i], shift - 1, NULL, 0, false);
                    }
                }
            }
        }
        free(boundaries);
        free(added);
        if (subcount ==  NULL) free(count);
    }
    else
    {
        insertionSort32WithLow(low, high);
    }
}

inline void insertionSort32WithLow(int low,int high)
{
    for (int i = low + 1; i < high; i++)
    {
        unsigned int key = numbers32[i];
        int j = i - 1;
        while (j >= low)
        {
            if(numbers32[j] > key)
            {
                numbers32[j + 1] = numbers32[j];
                j--;
            }
            else
            {
                break;
            }
        }
        numbers32[j + 1] = key;
    }
}



#pragma mark - 32BIT SIGNED
-(void) sortSignedIntArray:(signed int*) array withLength:(int) length
{
    if(array == nil) return;
    if(length < 2) return;
    numbers32s = array;
    
    min = 2147483647;
    size = length;

    if(size > 1000)
    {
        
        numcpus = numberOfThreads((int)[[NSProcessInfo processInfo] processorCount]);
        long *minArray = (long *)malloc(numcpus*sizeof(long));
        for(int i = 0; i < numcpus; i++) {
            minArray[i] = min;
        }
        
//        long *minArray = (long *)malloc(4*sizeof(long));
//        minArray[0] = min;
//        minArray[1] = min;
//        minArray[2] = min;
//        minArray[3] = min;
        
        numcpus = 2;
        dispatch_queue_t queue = dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT_WITH_AUTORELEASE_POOL);
        dispatch_apply(numcpus, queue, ^(size_t j){
            long start = (size/numcpus) * j;
            long end = (size/numcpus) * (j+1);
            if(end > size) end = size;
            for (long i = start; i < end; i++)
            {
                if(minArray[j] > array[i]) minArray[j] = array[i];
            }
        });
        
        for(int i = 0; i < numcpus; i++) {
            if(min > minArray[i]) min = minArray[i];
        }
        
//        for (int i = 0; i < 4; i++)
//        {
//            if(min > minArray[i]) min = minArray[i];
//        }
    }
//    else
//    {
//        for (int i = 0; i < size; i++)
//        {
//            if(min > array[i]) min = array[i];
//        }
//    }

    if(min < 0)
    {
        correction = -min;
    }
    else if(min > 0)
    {
        correction = -min;
    }
    
    [self dividInToQuadrants32sFromLow:0 toHigh:size-1 withShift: 0];
    
//    free(numbers32s)
}

-(void) dividInToQuadrants32sFromLow:(int) low toHigh:(int) high withShift:(int) shift
{
    int* added = calloc(2,sizeof(int));
    added[0] = 0;
    added[1] = 0;
    int i = low;
    
    int* subcount = calloc(256,sizeof(int));
    int subtotal = 0;

    int* subcount2 = calloc(256,sizeof(int));
    int subtotal2 = 0;
    
    while (i < high)
    {
        
        int preValue = numbers32s[i];
        UInt32 value32s = (UInt32)((long)preValue + correction);
        
        if (i > high - added[1])
        {
            break;
        }
        
        if (value32s < 65536)
        {
//            subcount[value32s]++;
            subcount[value32s >> 8]++;
            subtotal++;
            
            if (i > low + added[0])
            {
                int j = low + added[0];
                exchange32s(i, j);
                added[0]++;
            }
            else
            {
                added[0]++;
                i = low + added[0];
            }
        }
        else if (value32s > 16777215)
        {
            subcount2[value32s >> 24]++;
            subtotal2++;
            
            int j = high - added[1];
            exchange32s(i, j);
            added[1]++;
        }
        else
        {
            i++;
        }
    }
    
    if(size > 500)
    {
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        dispatch_semaphore_t sema1 = dispatch_semaphore_create(0);
        dispatch_semaphore_t sema2 = dispatch_semaphore_create(0);
        
        //SORT LSB
        int added0 = added[0];
        int added1 = added[1];
        
        if (added[0] > 1)
        {
            dispatch_async(dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT_WITH_AUTORELEASE_POOL), ^{
                sort32sFromLow(0, added0, 1, subcount, subtotal, true);
                if(subcount !=NULL) free(subcount);
                dispatch_semaphore_signal(sema);
            });
        }
        else
        {
            dispatch_semaphore_signal(sema);
        }
        
        //SORT MIDDLE ARRAY
        if ((high - 1 - added1) - added0 > 1)
        {
            dispatch_async(dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT_WITH_AUTORELEASE_POOL), ^{
                sort32sFromLow(added0, high - added1 + 1, 2, NULL, 0, true);
                dispatch_semaphore_signal(sema1);
            });
        }
        else
        {
            dispatch_semaphore_signal(sema1);
        }
        
        //SORT MSB
        if (added1 > 1)
            dispatch_async(dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT_WITH_AUTORELEASE_POOL), ^{
                sort32sFromLow((high - added1) + 1, high + 1 , 3, subcount2, subtotal2, true);
                if(subcount2 !=NULL) free(subcount2);
                dispatch_semaphore_signal(sema2);
            });
        else
        {
            dispatch_semaphore_signal(sema2);
        }

        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(sema1, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(sema2, DISPATCH_TIME_FOREVER);
    }
    else
    {
        if(subcount !=NULL) free(subcount);
        if(subcount2 !=NULL) free(subcount2);
        if(size > 20)
        {
            quickSort32sWithLow(0, size-1);
        }
        else
        {
            insertionSort32sWithLow(0, size);
        }
        
    }
}

inline void exchange32s(int i, int j)
{
    signed int temp = numbers32s[i];
    numbers32s[i] = numbers32s[j];
    numbers32s[j] = temp;
}

void sort32sFromLow(int low ,int high, int shift, int* subcount, int subtotal, bool useGCD)
{
    if (high - low > 20)
    {
        int* count;
        if (subcount != NULL)
        {
            count = subcount;
        }
        else
        {
            count = calloc(256,sizeof(int));
        }
        
        int shiftbits = shift * 8;
        UInt32 mask = (UInt32)(0x000000FF << shiftbits);
        
        //BUILD COUNTING FOR BOUNDARY
        if (subcount == NULL)
        {
            for (int i = low; i < high; i++)
            {
                signed int preValue = numbers32s[i];
                UInt32 value32s = (UInt32)((long)preValue + correction);
                UInt32 countvalue = (UInt32)(value32s & mask);
                countvalue = countvalue >> shiftbits;
                count[countvalue]++;
            }
        }
        
        int *boundaries = calloc(256,sizeof(int));
        int* added = calloc(256,sizeof(int));
        
        //BUILD BOUNDARIES
        boundaries[0] = low;
        for (int i = 1; i < 256; i++)
        {
            boundaries[i] = boundaries[i - 1] + count[i - 1];
        }
        
        //int j = low;
        while (low < high)
        {
            UInt32 value32s = (UInt32)((long)numbers32s[low] + correction);
            UInt32 value32 = (UInt32)(((value32s & mask) >> shiftbits));
            
            if (low >= boundaries[value32] && low <= boundaries[value32] + count[value32])
            {
                //STABILITY LEAVE VALUE IN PLACE IF IT BELONGS IN THIS BOUNDARY
                if (low < boundaries[value32] + added[value32])
                {
                    low = boundaries[value32] + added[value32];
                }
                else
                {
                    low++;
                    added[value32]++;
                }
            }
            else
            {
                //PLACE VALUE IN CORRECT BOUNDARY
                int k = boundaries[value32] + added[value32];
                exchange32s(low, k);
                added[value32]++;
            }
        }
        
        if(shift > 0)
        {
            if(useGCD) {
            numcpus = numberOfThreads((int)[[NSProcessInfo processInfo] processorCount]);
            dispatch_queue_t queue = dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT_WITH_AUTORELEASE_POOL);
            dispatch_apply(numcpus, queue, ^(size_t i){
                
                long start = (256/numcpus) * i;
                long end = (256/numcpus) * (i+1);
                if(end > 256) end = 256;
                for (long i = start; i < end; i++)
                {
                    if (count[i] > 1)
                    {
                        //SORT EACH BOUNDARY
                        sort32sFromLow(boundaries[i], boundaries[i] + count[i], shift - 1, NULL, 0, false);
                    }
                }
            });
            } else {
                for (long i = 0; i < 256; i++)
                {
                    if (count[i] > 1)
                    {
                        //SORT EACH BOUNDARY
                        sort32sFromLow(boundaries[i], boundaries[i] + count[i], shift - 1, NULL, 0, false);
                    }
                }
            }
        }
        free(boundaries);
        free(added);
        
        if (subcount ==  NULL) free(count);
    }
    else
    {
        insertionSort32sWithLow(low ,high);
    }
}

void quickSort32sWithLow(int low, int high)
{
    if (high - low > 10)
    {
        int i = low;
        int j = high;
        
        signed int pivot = numbers32s[low + (high - low) / 2];
        
        while (i < j)
        {
            while (numbers32s[i] < pivot)
            {
                i++;
            }
            
            while (numbers32s[j] > pivot)
            {
                j--;
            }
            
            if (i <= j)
            {
                exchange32s(i, j);
                i++;
                j--;
            }
        }
        
        if (low < j)
        {
            quickSort32sWithLow(low, j);
        }
        if (i < high)
        {
            quickSort32sWithLow(i, high);
        }
    }
    else
    {
        insertionSort32sWithLow(low, high + 1);
    }
}

void insertionSort32sWithLow(int low, int high)
{
    for (int i = low + 1; i < high; i++)
    {
        signed int key = numbers32s[i];
        int j = i - 1;
        while (j >= low && numbers32s[j] > key )
        {
            numbers32s[j + 1] = numbers32s[j];
            j--;
        }
        numbers32s[j + 1] = key;
    }
}













#pragma mark - 64BIT SIGNED
-(void) sortSignedInt64Array:(long long*) array withLength:(int) length
{
    if(array == nil) return;
    if(length < 2) return;
    numbers64s = array;
    
    size = length;
    min64 = INT64_MAX - 1;
    correction64 = 0;
    
    if(size > 1000)
    {
        
        numcpus = numberOfThreads((int)[[NSProcessInfo processInfo] processorCount]);
        long long *minArray = (long long *)malloc(numcpus*sizeof(long long));
        for(int i = 0; i < numcpus; i++) {
            minArray[i] = min64;
        }
        
//        long long *minArray = (long long *)malloc(4*sizeof(long long));
//        minArray[0] = min64;
//        minArray[1] = min64;
//        minArray[2] = min64;
//        minArray[3] = min64;
        
        numcpus = 2;
        dispatch_queue_t queue = dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT_WITH_AUTORELEASE_POOL);
        dispatch_apply(numcpus, queue, ^(size_t j){
            long start = (size/numcpus) * j;
            long end = (size/numcpus) * (j+1);
            if(end > size) end = size;
            for (long i = start; i < end; i++)
            {
                if(minArray[j] > array[i]) minArray[j] = array[i];
            }
        });
        
        for(int i = 0; i < numcpus; i++) {
           if(min64 > minArray[i]) min64 = minArray[i];
        }
        
//        for (int i = 0; i < 4; i++)
//        {
//            if(min64 > minArray[i]) min64 = minArray[i];
//        }
        
        
    }
    else
    {
        for (int i = 0; i < size; i++)
        {
            if(min64 > array[i]) min64 = array[i];
        }
    }
    
    if(min64 < 0)
    {
        correction64 = -min64;
    } else if(min64 > 0)
    {
        correction64 = -min64;
    }
    
    [self dividInToQuadrants64sFromLow:0 toHigh:size-1 withShift: 0];
//    if(size > 100)
//    {
//        insertionSort64sWithLow(0, 5);
//    }
}

-(void) dividInToQuadrants64sFromLow:(int) low toHigh:(int) high withShift:(int) shift
{
    int* added = calloc(2,sizeof(int));
    added[0] = 0;
    added[1] = 0;
    int i = low;
    
    int* subcount = calloc(256,sizeof(int));
    int subtotal = 0;
    
    int* subcount2 = calloc(256,sizeof(int));
    int subtotal2 = 0;
    
    while (i < high)
    {
        long long preValue = numbers64s[i];
        UInt64 value64s = (UInt64)(preValue + correction64);
        if (i > high - added[1])
        {
            break;
        }
        
        if (value64s < INT16_MAX * 256)
        {
            subcount[value64s >> 16]++;
            subtotal++;
            
            if (i > low + added[0])
            {
                int j = low + added[0];
                exchange64s(i, j);
                added[0]++;
            }
            else
            {
                added[0]++;
                i = low + added[0];
            }
        }
        else if (value64s > (INT64_MAX >> 16))
        {
            subcount2[value64s >> 56]++;
            subtotal2++;
            
            int j = high - added[1];
            exchange64s(i, j);
            added[1]++;
        }
        else
        {
            i++;
        }
    }
    
    if(size > 500)
    {
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        dispatch_semaphore_t sema1 = dispatch_semaphore_create(0);
        dispatch_semaphore_t sema2 = dispatch_semaphore_create(0);
        
        //SORT LSB
        int added0 = added[0];
        int added1 = added[1];
        
        if (added[0] > 1)
        {
            dispatch_async(dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT_WITH_AUTORELEASE_POOL), ^{
                sort64sFromLow(0, added0, 2, subcount, subtotal, true);
                if(subcount !=NULL) free(subcount);
                dispatch_semaphore_signal(sema);
            });
        }
        else
        {
            dispatch_semaphore_signal(sema);
        }
        
        //SORT MIDDLE ARRAY
        if ((high - 1 - added1) - added0 > 1)
        {
            dispatch_async(dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT_WITH_AUTORELEASE_POOL), ^{
                sort64sFromLow(added0, high - added1 + 1, 6, NULL, 0, true);
                dispatch_semaphore_signal(sema1);
            });
        }
        else
        {
            dispatch_semaphore_signal(sema1);
        }
        
        //SORT MSB
        if (added1 > 1)
            dispatch_async(dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT_WITH_AUTORELEASE_POOL), ^{
                sort64sFromLow((high - added1) + 1, high + 1 , 7, subcount2, subtotal2, true);
                if(subcount2 !=NULL) free(subcount2);
                dispatch_semaphore_signal(sema2);
            });
        else
        {
            dispatch_semaphore_signal(sema2);
        }
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(sema1, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(sema2, DISPATCH_TIME_FOREVER);
    }
    else
    {
        if(subcount !=NULL) free(subcount);
        if(subcount2 !=NULL) free(subcount2);
        if(size > 20)
        {
            quickSort64sWithLow(0,size-1);
        }
        else
        {
            insertionSort64sWithLow(0, size);
        }
        
    }
}

inline void exchange64s(int i, int j)
{
    long long temp = numbers64s[i];
    numbers64s[i] = numbers64s[j];
    numbers64s[j] = temp;
}

void sort64sFromLow(int low ,int high, int shift, int* subcount, int subtotal, bool useGCD)
{
    if (high - low > 20)
    {
        int* count;
        if (subcount != NULL)
        {
            count = subcount;
        }
        else
        {
            count = calloc(256,sizeof(int));
        }
        
        int shiftbits = shift * 8;
        UInt64 mask = (UInt64)(255 << shiftbits);
        
        //BUILD COUNTING FOR BOUNDARY
        if (subcount == NULL)
        {
            for (int i = low; i < high; i++)
            {
                long long preValue = numbers64s[i];
                UInt64 value64s = (UInt64)((long long)preValue + correction64);
                UInt64 countvalue = (UInt64)(value64s & mask);
                countvalue = countvalue >> shiftbits;
                count[countvalue]++;
            }
        }
        
        int *boundaries = calloc(256,sizeof(int));
        int* added = calloc(256,sizeof(int));
        
        //BUILD BOUNDARIES
        boundaries[0] = low;
        for (int i = 1; i < 256; i++)
        {
            boundaries[i] = boundaries[i - 1] + count[i - 1];
        }
        
        //int j = low;
        while (low < high)
        {
            UInt64 value32s = (UInt64)((long)numbers64s[low] + correction64);
            UInt64 value32 = (UInt64)(((value32s & mask) >> shiftbits));
            
            if (low >= boundaries[value32] && low <= boundaries[value32] + count[value32])
            {
                //STABILITY LEAVE VALUE IN PLACE IF IT BELONGS IN THIS BOUNDARY
                if (low < boundaries[value32] + added[value32])
                {
                    low = boundaries[value32] + added[value32];
                }
                else
                {
                    low++;
                    added[value32]++;
                }
            }
            else
            {
                //PLACE VALUE IN CORRECT BOUNDARY
                int k = boundaries[value32] + added[value32];
                exchange64s(low, k);
                added[value32]++;
            }
        }
        
        if(shift > 0)
        {
            if(useGCD) {
            numcpus = numberOfThreads((int)[[NSProcessInfo processInfo] processorCount]);
            dispatch_queue_t queue = dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT_WITH_AUTORELEASE_POOL);
            dispatch_apply(numcpus, queue, ^(size_t i){
                
                long start = (256/numcpus) * i;
                long end = (256/numcpus) * (i+1);
                if(end > 256) end = 256;
                for (long i = start; i < end; i++)
                {
                    if (count[i] > 1)
                    {
                        //SORT EACH BOUNDARY
                        sort64sFromLow(boundaries[i], boundaries[i] + count[i], shift - 1, NULL, 0, false);
                    }
                }
            });
            } else {
                for (long i = 0; i < 256; i++)
                {
                    if (count[i] > 1)
                    {
                        //SORT EACH BOUNDARY
                        sort64sFromLow(boundaries[i], boundaries[i] + count[i], shift - 1, NULL, 0, false);
                    }
                }
            }
        }
        free(boundaries);
        free(added);
        
        if (subcount ==  NULL) free(count);
    }
    else
    {
        insertionSort64sWithLow(low ,high);
    }
}

void quickSort64sWithLow(int low, int high)
{
    if (high - low > 10)
    {
        int i = low;
        int j = high;
        
        long long pivot = numbers64s[low + (high - low) / 2];
        
        while (i < j)
        {
            while (numbers64s[i] < pivot)
            {
                i++;
            }
            
            while (numbers64s[j] > pivot)
            {
                j--;
            }
            
            if (i <= j)
            {
                exchange64s(i, j);
                i++;
                j--;
            }
        }
        
        if (low < j)
        {
            quickSort64sWithLow(low, j);
        }
        if (i < high)
        {
            quickSort64sWithLow(i, high);
        }
    }
    else
    {
        insertionSort64sWithLow(low, high + 1);
    }
}

void insertionSort64sWithLow(int low, int high)
{
    for (int i = low + 1; i < high; i++)
    {
        long long key = numbers64s[i];
        int j = i - 1;
        while (j >= low && numbers64s[j] > key )
        {
            numbers64s[j + 1] = numbers64s[j];
            j--;
        }
        numbers64s[j + 1] = key;
    }
}


















#pragma mark - 32BIT FLOAT
-(void) sortFloatArray:(float*) array withLength:(int) length
{
    if(array == nil) return;
    if(length < 2) return;
    numbersFloat = array;
    size = length;
    
    [self dividInToQuadrantsFloatWithLow:0 andHigh: size withShift: 0];
}

-(void) dividInToQuadrantsFloatWithLow:(int) low andHigh:(int) high withShift:(int) shift
{
    int* added = calloc(2,sizeof(int));
    added[0] = 0;
    added[1] = 0;
    int i = low;
    
    while (i < high)
    {
        if (i > high - added[1])
        {
            break;
        }
        
        if (numbersFloat[i] < 0.0f)
        {
            if (i > low + added[0])
            {
                int j = low + added[0];
                exchangeFloat(i, j);
                added[0]++;
            }
            else
            {
                added[0]++;
                i = low + added[0];
            }
        }
        else if (numbersFloat[i] >= 1.0f)
        {
            int j = high - added[1];
            exchangeFloat(i, j);
            added[1]++;
        }
        else
        {
            i++;
        }
    }
    
    if(size > 500)
    {
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        dispatch_semaphore_t sema1 = dispatch_semaphore_create(0);
        dispatch_semaphore_t sema2 = dispatch_semaphore_create(0);
        
        int added0 = added[0];
        int added1 = added[1];
        
        if (added[0] > 1){
            dispatch_async(dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT_WITH_AUTORELEASE_POOL), ^{
                //SORT LSB
                quickSortFloatWithLow(0, added0);
                dispatch_semaphore_signal(sema);
            });
        }
        else
        {
            dispatch_semaphore_signal(sema);
        }
        
        //SORT MIDDLE ARRAY
         if ((high - 1 - added1) - added0 > 1)
         {
            dispatch_async(dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT_WITH_AUTORELEASE_POOL), ^{
                sortFloatv2FromLow(added0, high - added1 + 1, 3, NULL, 0, true);
                
                dispatch_semaphore_signal(sema1);
            });
        }
        else
        {
            dispatch_semaphore_signal(sema1);
        }
        
        //SORT MSB
         if (added1 > 1) {
            dispatch_async(dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT_WITH_AUTORELEASE_POOL), ^{
                sortFloatv2FromLow((high - added1) + 1, high + 1, 3 , NULL, 0 , true);

                dispatch_semaphore_signal(sema2);
            });
        }
        else
        {
            dispatch_semaphore_signal(sema2);
        }
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(sema1, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(sema2, DISPATCH_TIME_FOREVER);
    }
    else
    {
        if(size > 20 )
        {
            quickSortFloatWithLow(0,size);
        }
        else
        {
            insertionSortFloatWithLow(0, size);
        }
    }
}

void sortFloatv2FromLow(int low, int high, int shift, int* subcount, int subtotal, bool useGCD)
{
    if (high - low > 20)
    {
        int* count;
        if (subcount != NULL)
        {
            count = subcount;
        }
        else
        {
            count = calloc(256,sizeof(int));
        }
        
        int shiftbits = shift * 8;
        UInt32 mask = (UInt32)(0x000000FF << shiftbits);
        
        //BUILD COUNTING FOR BOUNDARY
        if (subcount == NULL)
        {
            for (int i = low; i < high; i++)
            {
                UInt32 floatvalue = condorFloatToUInt32(numbersFloat[i]);
                
                UInt32 countvalue = (UInt32)(floatvalue & mask);
                countvalue = countvalue >> shiftbits;
                count[countvalue]++;
            }
        }
        
        int *boundaries = calloc(256,sizeof(int));
        int* added = calloc(256,sizeof(int));
        
        //BUILD BOUNDARIES
        boundaries[0] = low;
        for (int i = 1; i < 256; i++)
        {
            boundaries[i] = boundaries[i - 1] + count[i - 1];
        }
        
        //int j = low;
        while (low < high)
        {
            UInt32 value = condorFloatToUInt32(numbersFloat[low]);
            UInt32 value32 = (UInt32)(((value & mask) >> shiftbits));
            
            if (low >= boundaries[value32] && low <= boundaries[value32] + count[value32])
            {
                //STABILITY LEAVE VALUE IN PLACE IF IT BELONGS IN THIS BOUNDARY
                if (low < boundaries[value32] + added[value32])
                {
                    low = boundaries[value32] + added[value32];
                }
                else
                {
                    low++;
                    added[value32]++;
                }
            }
            else
            {
                //PLACE VALUE IN CORRECT BOUNDARY
                int k = boundaries[value32] + added[value32];
                exchangeFloat(low, k);
                added[value32]++;
            }
        }
        
        if(shift > 0)
        {
            if(useGCD) {
            numcpus = numberOfThreads((int)[[NSProcessInfo processInfo] processorCount]);
            dispatch_queue_t queue = dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT_WITH_AUTORELEASE_POOL);
            dispatch_apply(numcpus, queue, ^(size_t i){
                
                long start = (256/numcpus) * i;
                long end = (256/numcpus) * (i+1);
                if(end > 256) end = 256;
                for (long i = start; i < end; i++)
                {
                    if (count[i] > 1)
                    {
                        //SORT EACH BOUNDARY
                        sortFloatv2FromLow(boundaries[i], boundaries[i] + count[i], shift - 1, NULL, 0, false);
                    }
                }
            });
            } else {
                for (long i = 0; i < 256; i++)
                {
                    if (count[i] > 1)
                    {
                        //SORT EACH BOUNDARY
                        sortFloatv2FromLow(boundaries[i], boundaries[i] + count[i], shift - 1, NULL, 0, false);
                    }
                }
            }
        }
        
        
        free(boundaries);
        free(added);
        
        if (subcount ==  NULL) free(count);
    }
    else
    {
        insertionSortFloatWithLow(low, high);
    }
}

void insertionSortFloatWithLow(int low, int high)
{
    for (int i = low + 1; i < high; i++)
    {
        float key = numbersFloat[i];
        int j = i - 1;
        while (j >= low && numbersFloat[j] > key)
        {
            numbersFloat[j + 1] = numbersFloat[j];
            j--;
        }
        numbersFloat[j + 1] = key;
    }
}

void quickSortFloatWithLow(int low, int high)
{
    if (high - low > 10)
    {
        int i = low;
        int j = high;
        
        float pivot = numbersFloat[low + (high - low) / 2];
        
        while (i < j)
        {
            while (numbersFloat[i] < pivot)
            {
                i++;
            }
            
            while (numbersFloat[j] > pivot)
            {
                j--;
            }
            
            if (i <= j)
            {
                exchangeFloat(i, j);
                i++;
                j--;
            }
        }
        
        if (low < j)
        {
            quickSortFloatWithLow(low, j);
        }
        if (i < high)
        {
            quickSortFloatWithLow(i, high);
        }
    }
    else
    {
        insertionSortFloatWithLow(low, high + 1);
    }
}

inline UInt32 condorFloatToUInt32(float f)
{
    int val = 0;
    memcpy(&val, &f, sizeof f);
    return val & 0x3FFFFFFF;
}

inline void exchangeFloat(int i, int j)
{
    float temp = numbersFloat[i];
    numbersFloat[i] = numbersFloat[j];
    numbersFloat[j] = temp;
}

#pragma mark - 64BIT DOUBLE
-(void) sortDoubleArray:(double*) array withLength:(int) length
{
    if(array == nil) return;
    if(length < 2) return;
    numbersDouble = array;
    size = length;
    
    [self dividInToQuadrantsDoubleWithLow:0 andHigh: size withShift: 0];
    insertionSortDoubleWithLow(0, 5);
}

-(void) dividInToQuadrantsDoubleWithLow:(int) low andHigh:(int) high withShift:(int) shift
{
    int* added = calloc(2,sizeof(int));
    added[0] = 0;
    added[1] = 0;
    int i = low;
    
    while (i < high)
    {
        if (i > high - added[1])
        {
            break;
        }
        
        if (numbersDouble[i] < 0.0)
        {
            if (i > low + added[0])
            {
                int j = low + added[0];
                exchangeDouble(i, j);
                added[0]++;
            }
            else
            {
                added[0]++;
                i = low + added[0];
            }
        }
        else if (numbersDouble[i] >= 1.0)
        {
            int j = high - added[1];
            exchangeDouble(i, j);
            added[1]++;
        }
        else
        {
            i++;
        }
    }
    
    if(size > 500)
    {
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        dispatch_semaphore_t sema1 = dispatch_semaphore_create(0);
        dispatch_semaphore_t sema2 = dispatch_semaphore_create(0);
        
        int added0 = added[0];
        int added1 = added[1];
        
        if (added[0] > 1){
            dispatch_async(dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT_WITH_AUTORELEASE_POOL), ^{
                //SORT LSB
                quickSortDoubleWithLow(0, added0);
                dispatch_semaphore_signal(sema);
            });
        }
        else
        {
            dispatch_semaphore_signal(sema);
        }
        
        //SORT MIDDLE ARRAY
        if ((high - 1 - added1) - added0 > 1)
        {
            dispatch_async(dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT_WITH_AUTORELEASE_POOL), ^{
                sortDoublev2FromLow(added0, high - added1 + 1, 3, NULL, 0, false);
                
                dispatch_semaphore_signal(sema1);
            });
        }
        else
        {
            dispatch_semaphore_signal(sema1);
        }
        
        //SORT MSB
        if (added1 > 1) {
            dispatch_async(dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT_WITH_AUTORELEASE_POOL), ^{
                sortDoublev2FromLow((high - added1) + 1, high + 1, 3 , NULL, 0 , false);
                
                dispatch_semaphore_signal(sema2);
            });
        }
        else
        {
            dispatch_semaphore_signal(sema2);
        }
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(sema1, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(sema2, DISPATCH_TIME_FOREVER);
    }
    else
    {
        if(size > 20)
        {
            quickSortDoubleWithLow(0, size);
        }
        else
        {
            insertionSortDoubleWithLow(0, size);
        }
    }
}

void sortDoublev2FromLow(int low, int high, int shift, int* subcount, int subtotal, bool useGCD)
{
    if (high - low > 20)
    {
        int* count;
        if (subcount != NULL)
        {
            count = subcount;
        }
        else
        {
            count = calloc(256,sizeof(int));
        }
        
        int shiftbits = shift * 8;
        UInt64 mask = (UInt64)(255 << shiftbits);
        
        //BUILD COUNTING FOR BOUNDARY
        if (subcount == NULL)
        {
            for (int i = low; i < high; i++)
            {
                UInt64 floatvalue = condorDoubleToUInt64(numbersDouble[i]);
                
                UInt64 countvalue = (UInt64)(floatvalue & mask);
                countvalue = countvalue >> shiftbits;
                count[countvalue]++;
            }
        }
        
        int *boundaries = calloc(256,sizeof(int));
        int *added = calloc(256,sizeof(int));
        
        //BUILD BOUNDARIES
        boundaries[0] = low;
        for (int i = 1; i < 256; i++)
        {
            boundaries[i] = boundaries[i - 1] + count[i - 1];
        }
        
        //int j = low;
        while (low < high)
        {
            UInt64 value = condorDoubleToUInt64(numbersDouble[low]);
            UInt64 value32 = (UInt64)(((value & mask) >> shiftbits));
            
            if (low >= boundaries[value32] && low <= boundaries[value32] + count[value32])
            {
                //STABILITY LEAVE VALUE IN PLACE IF IT BELONGS IN THIS BOUNDARY
                if (low < boundaries[value32] + added[value32])
                {
                    low = boundaries[value32] + added[value32];
                }
                else
                {
                    low++;
                    added[value32]++;
                }
            }
            else
            {
                //PLACE VALUE IN CORRECT BOUNDARY
                int k = boundaries[value32] + added[value32];
                exchangeDouble(low, k);
                added[value32]++;
            }
        }
        
        if(shift > 0)
        {
            if(useGCD) {
                numcpus = numberOfThreads((int)[[NSProcessInfo processInfo] processorCount]);
                dispatch_queue_t queue = dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT_WITH_AUTORELEASE_POOL);
                dispatch_apply(numcpus, queue, ^(size_t i){
                    
                    long start = (256/numcpus) * i;
                    long end = (256/numcpus) * (i+1);
                    if(end > 256) end = 256;
                    for (long i = start; i < end; i++)
                    {
                        if (count[i] > 1)
                        {
                            //SORT EACH BOUNDARY
                            sortDoublev2FromLow(boundaries[i], boundaries[i] + count[i], shift - 1, NULL, 0, false);
                        }
                    }
                });
             } else {
                 for (long i = 0; i < 256; i++)
                 {
                     if (count[i] > 1)
                     {
                         //SORT EACH BOUNDARY
                         sortDoublev2FromLow(boundaries[i], boundaries[i] + count[i], shift - 1, NULL, 0, false);
                     }
                 }
             }
        }
        
        free(boundaries);
        free(added);
        
        if (subcount ==  NULL) free(count);
    }
    else
    {
        insertionSortDoubleWithLow(low, high);
    }
}

void insertionSortDoubleWithLow(int low, int high)
{
    for (int i = low + 1; i < high; i++)
    {
        double key = numbersDouble[i];
        int j = i - 1;
        while (j >= low && numbersDouble[j] > key)
        {
            numbersDouble[j + 1] = numbersDouble[j];
            j--;
        }
        numbersDouble[j + 1] = key;
    }
}

void quickSortDoubleWithLow(int low, int high)
{
    if (high - low > 10)
    {
        int i = low;
        int j = high;
        
        double pivot = numbersDouble[low + (high - low) / 2];
        
        while (i < j)
        {
            while (numbersDouble[i] < pivot)
            {
                i++;
            }
            
            while (numbersDouble[j] > pivot)
            {
                j--;
            }
            
            if (i <= j)
            {
                exchangeDouble(i, j);
                i++;
                j--;
            }
        }
        
        if (low < j)
        {
            quickSortDoubleWithLow(low, j);
        }
        if (i < high)
        {
            quickSortDoubleWithLow(i, high);
        }
    }
    else
    {
        insertionSortDoubleWithLow(low, high + 1);
    }
}

inline UInt64 condorDoubleToUInt64(double d)
{
    UInt64 val = 0;
    memcpy(&val, &d, sizeof d);
    return val;
}

inline void exchangeDouble(int i, int j)
{
    double temp = numbersDouble[i];
    numbersDouble[i] = numbersDouble[j];
    numbersDouble[j] = temp;
}





































#pragma mark - REVERSE ORDER METHODS
-(void) reverseOrderOfBooleanArray:(Boolean*) array withLow:( int) low andHigh:(int) high
{
    if(array == nil) return;
    if(high - low < 2) return;
    int i = low;
    int j = high;
    
    while (i < j)
    {
        Boolean temp = array[i];
        array[i] = array[j];
        array[j] = temp;
        i++;
        j--;
    }
}

-(void) reverseOrderOfSignedCharArray:(signed char*) array withLow:( int) low andHigh:(int) high
{
    if(array == nil) return;
    if(high - low < 2) return;
    int i = low;
    int j = high;
    
    while (i < j)
    {
        signed char temp = array[i];
        array[i] = array[j];
        array[j] = temp;
        i++;
        j--;
    }
}

-(void) reverseOrderOfUnsignedCharArray:(unsigned char*) array withLow:( int) low andHigh:(int) high
{
    if(array == nil) return;
    if(high - low < 2) return;
    int i = low;
    int j = high;
    
    while (i < j)
    {
        unsigned char temp = array[i];
        array[i] = array[j];
        array[j] = temp;
        i++;
        j--;
    }
}

-(void) reverseOrderOfSignedShortArray:(signed short*) array withLow:( int) low andHigh:(int) high
{
    if(array == nil) return;
    if(high - low < 2) return;
    int i = low;
    int j = high;
    
    while (i < j)
    {
        signed short temp = array[i];
        array[i] = array[j];
        array[j] = temp;
        i++;
        j--;
    }
}

-(void) reverseOrderOfUnsignedShortArray:(unsigned short*) array withLow:( int) low andHigh:(int) high
{
    if(array == nil) return;
    if(high - low < 2) return;
    int i = low;
    int j = high;
    
    while (i < j)
    {
        UInt16 temp = array[i];
        array[i] = array[j];
        array[j] = temp;
        i++;
        j--;
    }
}

-(void) reverseOrderOfSignedIntArray:(signed int*) array withLow:( int) low andHigh:(int) high
{
    if(array == nil) return;
    if(high - low < 2) return;
    int i = low;
    int j = high;
    
    while (i < j)
    {
        signed int temp = array[i];
        array[i] = array[j];
        array[j] = temp;
        i++;
        j--;
    }
}

-(void) reverseOrderOfUnsignedIntArray:(unsigned int*) array withLow:( int) low andHigh:(int) high
{
    if(array == nil) return;
    if(high - low < 2) return;
    int i = low;
    int j = high;
    
    while (i < j)
    {
        unsigned int temp = array[i];
        array[i] = array[j];
        array[j] = temp;
        i++;
        j--;
    }
}

-(void) reverseOrderOfSignedLongArray:(signed long*) array withLow:( int) low andHigh:(int) high
{
    if(array == nil) return;
    if(high - low < 2) return;
    int i = low;
    int j = high;
    
    while (i < j)
    {
        signed long temp = array[i];
        array[i] = array[j];
        array[j] = temp;
        i++;
        j--;
    }
}

-(void) reverseOrderOfUnsignedLongArray:(unsigned long*) array withLow:( int) low andHigh:(int) high
{
    if(array == nil) return;
    if(high - low < 2) return;
    int i = low;
    int j = high;
    
    while (i < j)
    {
        unsigned long temp = array[i];
        array[i] = array[j];
        array[j] = temp;
        i++;
        j--;
    }
}

-(void) reverseOrderOfFloatArray:(float*) array withLow:( int) low andHigh:(int) high
{
    if(array == nil) return;
    if(high - low < 2) return;
    int i = low;
    int j = high;
    
    while (i < j)
    {
        float temp = array[i];
        array[i] = array[j];
        array[j] = temp;
        i++;
        j--;
    }
}

-(void) reverseOrderOfDoubleArray:(double*) array withLow:( int) low andHigh:(int) high
{
    if(array == nil) return;
    if(high - low < 2) return;
    int i = low;
    int j = high;
    
    while (i < j)
    {
        double temp = array[i];
        array[i] = array[j];
        array[j] = temp;
        i++;
        j--;
    }
}

-(void) reverseOrderOfLongDoubleArray:(long double*) array withLow:( int) low andHigh:(int) high
{
    if(array == nil) return;
    if(high - low < 2) return;
    int i = low;
    int j = high;
    
    while (i < j)
    {
        long double temp = array[i];
        array[i] = array[j];
        array[j] = temp;
        i++;
        j--;
    }
}

@end
