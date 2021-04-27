//
//  CondorObjectSortInt.m
//  Condor
//
//  Created by Thomas on 2018-02-26.
//  Copyright © 2018 Thomas Lock. All rights reserved.
//

#import "CondorObjectSortInt.h"
#import <objc/message.h>
#import <objc/runtime.h>

#pragma BackgroundTasks FALSE
#pragma BoundsChecking FALSE
#pragma StackOverflowchecking FALSE
#pragma NilObjectChecking FALSE

static int numcpus = 2;
int (* const volatile objc_msgSendTyped)(id self, SEL _cmd) = (void*)objc_msgSend;
static int size = 0;
static void **numbersObject;
static ptrdiff_t offset;

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

@interface CondorObjectSortInt()
{
    

    int sizeInsertion;
    long correction;
    long min;

    long long correction64;
    long long min64;
    SEL selector;
    Class sortClass;
    Ivar ivar;
    
}

@property (nonatomic, strong) NSString *sortIntProperty;

@end

@implementation CondorObjectSortInt
@synthesize sortIntProperty;



#pragma mark - OBJECT PROTOCOL 32BIT SIGNED
-(NSArray*) sortSignedIntObjectArray:(NSArray *) array orderDesc: (BOOL) descending selectorNameAsString : (NSString *) sortProperty
{
    if(array == nil) return array;
    if((int)[array count] < 2) return array;
    min = 2147483647;
    correction = 0;
    
    sortIntProperty = sortProperty;
    selector = NSSelectorFromString(sortIntProperty);
    
    sortClass = [array[0] class];
    NSString *propertyString = [NSString stringWithFormat:@"_%@",sortProperty];
    const char *propertyUTF8String = [propertyString UTF8String];
    ivar = class_getInstanceVariable(sortClass, propertyUTF8String);
    offset = ivar_getOffset(ivar);
    
    SEL selectorObjectAtIndex = @selector(objectAtIndex:);
    id (*impObjectAtIndex)(id,SEL,NSUInteger) = (id(*)(id,SEL, NSUInteger))[array methodForSelector:selectorObjectAtIndex];
    
    //CONVERT TO ARRAY OF POINTERS
    size = (int)[array count] ;
    
    numbersObject = (void *)malloc(size * sizeof(void *));
    
    for (NSUInteger i = 0; i < size; i++)
    {
        //        if(impObjectAtIndex != nil) {
        numbersObject[i] = (__bridge void *)(impObjectAtIndex(array, selectorObjectAtIndex, i));
        //        } else {
        //            numbersObject[i] = (__bridge void *)(((id (*)(id, SEL, NSUInteger))objc_msgSend)(array, @selector(objectAtIndex:), i));
        //        }

        //IVAR SEND METHOD
        unsigned char *stuffBytes = (unsigned char *)numbersObject[i];
        int condorIdValue = * ((int *)(stuffBytes + offset));
        
        if(min > condorIdValue) min = condorIdValue;
    }
    
    if(min < 0)
    {
        correction = -min;
    }
    else if(min > 0)
    {
        correction = -min;
    }
    
    [self dividInToQuadrants32sObjectFromLow:0 toHigh:size withShift: 0];
    
    //[self insertionSort32sObjectWithLow:0 andHigh:size];
    NSMutableArray *output = [[NSMutableArray alloc] init];
    
    SEL selectorAddObject = @selector(addObject:);
    id (*impAddObject)(id,SEL,id) = (id(*)(id,SEL,id))[output methodForSelector:selectorAddObject];
    
    if(!descending)
    {
        for (int k = 0; k < size; k++)
        {
            id obj = (__bridge id)(numbersObject[k]);
//            [output addObject:obj];
//            if(obj!=nil) (objc_msgSend(output, @selector(addObject:), obj));
//            if(obj!=nil) ((void (*)(id, SEL, id))objc_msgSend)(output, @selector(addObject:), obj);
            if(obj!=nil) {
                //                if(impAddObject != nil) {
                (*impAddObject)(output, selectorAddObject, obj);
                //                } else {
                //                    ((void (*)(id, SEL, id))objc_msgSend)(output, @selector(addObject:), obj);
                //                }
            }
        }
    }
    else
    {
        for (int k = size-1; k >= 0; k--)
        {
            id obj = (__bridge id)(numbersObject[k]);
//            [output addObject:obj];
            if(obj!=nil) {
                //                if(impAddObject != nil) {
                (*impAddObject)(output, selectorAddObject, obj);
                //                } else {
                //                    ((void (*)(id, SEL, id))objc_msgSend)(output, @selector(addObject:), obj);
                //                }
            }
        }
    }
    
    free(numbersObject);
    return output;
}

-(void) dividInToQuadrants32sObjectFromLow:(int) low toHigh:(int) high withShift:(int) shift
{
    int *added = calloc(2,sizeof(int));
    added[0] = 0;
    added[1] = 0;
    int i = low;
    
    int* subcount = calloc(256,sizeof(int));
//    int subtotal = 0;
    
    int* subcount2 = calloc(256,sizeof(int));
//    int subtotal2 = 0;
    
    while (i < high)
    {
        //        int preValue = (int)[(__bridge id)numbersObject[i] valueForKey:@"condorId"];
//        int preValue = ((int (*)(id, SEL))objc_msgSend)((__bridge id)numbersObject[i],selector);
//        int preValue = objc_msgSendTyped((__bridge id)numbersObject[i],selector);
        unsigned char *stuffBytes = (unsigned char *)numbersObject[i];
        int preValue = * ((int *)(stuffBytes + offset));

        UInt32 value32s = (UInt32)((long)preValue + correction);
        if (i > high - added[1])
        {
            break;
        }
        
        if (value32s < 65536)
        {
            subcount[value32s >> 8]++;
            if (i > low + added[0])
            {
                int j = low + added[0];
//                [self exchangeObject:i with: j];
                
                void *temp = numbersObject[i];
                numbersObject[i] = numbersObject[j];
                numbersObject[j] = temp;
                
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
            
            int j = high - added[1];
//            [self exchangeObject:i with: j];
            
            void *temp = numbersObject[i];
            numbersObject[i] = numbersObject[j];
            numbersObject[j] = temp;
            
            added[1]++;
        }
        else
        {
            i++;
        }
    }
    //GOODD !!!!
    if(size > 100)
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
                [self sort32sObjectFromLow:0 toHigh: added0 withShift: 1 andMaybeSubCount:subcount useGCD:true];
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
                [self sort32sObjectFromLow:added0  toHigh: high - added1 withShift: 2 andMaybeSubCount: NULL useGCD:true];
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
                [self sort32sObjectFromLow:(high - added1) + 1 toHigh: high + 1 withShift: 3 andMaybeSubCount: subcount2 useGCD:true];
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
        [self insertionSort32sObjectWithLow:0 andHigh:size];
    }
}

-(void) sort32sObjectFromLow:(int) low toHigh:(int) high withShift:(int) shift andMaybeSubCount:(int*) subcount useGCD:(BOOL) useGCD
{
    if (high - low > 20 )
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
//                int preValue = ((int (*)(id, SEL))objc_msgSend)((__bridge id)numbersObject[i],selector);
//                int preValue = objc_msgSendTyped((__bridge id)numbersObject[i],selector);
                unsigned char *stuffBytes = (unsigned char *)numbersObject[i];
                int preValue = * ((int *)(stuffBytes + offset));
                
                UInt32 value32s = (UInt32)((long)preValue + correction);
                UInt32 countvalue = (UInt32)(value32s & mask);
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
        
        while (low < high)
        {
//            int preValue = ((int (*)(id, SEL))objc_msgSend)((__bridge id)numbersObject[low],selector);
//            int preValue = objc_msgSendTyped((__bridge id)numbersObject[low],selector);
            unsigned char *stuffBytes = (unsigned char *)numbersObject[low];
            int preValue = * ((int *)(stuffBytes + offset));
            
            UInt32 value32s = (UInt32)((long)preValue + correction);
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
//                [self exchangeObject:low with:k];
                void *temp = numbersObject[low];
                numbersObject[low] = numbersObject[k];
                numbersObject[k] = temp;
                added[value32]++;
            }
        }
        
        if(shift > 0)
        {
            if(useGCD) {
                numcpus = numberOfThreads((int)[[NSProcessInfo processInfo] processorCount]);
//                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
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
                            [self sort32sObjectFromLow:boundaries[i] toHigh: boundaries[i] + count[i] withShift: shift - 1 andMaybeSubCount: NULL useGCD:false];
                        }
                    }
                });
            } else {
                for (long i = 0; i < 256; i++)
                {
                    if (count[i] > 1)
                    {
                        //SORT EACH BOUNDARY
                        [self sort32sObjectFromLow:boundaries[i] toHigh: boundaries[i] + count[i] withShift: shift - 1 andMaybeSubCount: NULL useGCD:false];
                    }
                }
            }
        }
        //CLEAN UP
        free(boundaries);
        free(added);
        if (subcount ==  NULL) free(count);
    }
    else
    {
        [self insertionSort32sObjectWithLow: low andHigh: high];
    }
}
                           
-(void) insertionSort32sObjectWithLow:(int) low andHigh:(int) high
{
    for (int i = low + 1; i < high; i++)
    {
//        int key = ((int (*)(id, SEL))objc_msgSend)((__bridge id)numbersObject[i],selector);
//        int key = objc_msgSendTyped((__bridge id)numbersObject[i],selector);
        unsigned char *stuffBytes = (unsigned char *)numbersObject[i];
        int key = * ((int *)(stuffBytes + offset));
        
        void *keyPointer = numbersObject[i];
        int j = i - 1;
//        while (j >= low  && objc_msgSendTyped((__bridge id)numbersObject[j],selector) > key)
        while (j >= low  && (* ((int *)((unsigned char *)numbersObject[j] + offset))) > key)
        {
            numbersObject[j + 1] = numbersObject[j];
            j--;
        }
        
        //Need exchangemethod here
        numbersObject[j + 1] = keyPointer;
    }
}

#pragma mark - Exchange
-(void) exchangeObject:(int) i with:(int) j
{
    void *temp = numbersObject[i];
    numbersObject[i] = numbersObject[j];
    numbersObject[j] = temp;
}

@end


