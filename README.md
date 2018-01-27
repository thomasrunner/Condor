# Condor
Apple's built-in sorting algorithm implementation is far too slow. Condor is a new Sorting Framework available for both Objective C and Swift in a super easy to use ULTRA LIGHT Framework.

Condor supports System Types as well NSNumber types in an NSArray.

**YOU CAN FIND THE FRAMEWORK LOCATED IN THE PROJECT**

UPDATED v1.0.1
- New Object Sort using CondorObject protocol

UPDATE v1.2.1
- Fixed decending bug for Object Sort
- New float Object Sort using CondorObject protocol condorIdf
- More than 10% performance increase for Int Object Sort

UPDATE v1.2.2
- Fixed not sorting last value of Int Object Sort
- Updated System Type algorithms with additional tweaks already in Object Sort

UPDATE v1.2.4
- Fixed over optimization bugs on Object Sort

UPDATE v1.2.5
- Merged all project into a single Project which has Swift and Objective C ViewControllers and Tests
- Fixed UInt32*, UInt*, and float* array bugs

It comes with 3 specific classes:
     - CondorSort.h for system types (Boolean, unsigned char, signed char, unsigned short, signed short, unsigned int, signed int and float)
     - CondorNSSort.h for NSArray's with NSNumbers of types listed in CondorSort.
     - CondorObjectSort.h for sorting ANY Object so long as it implements one of the CondorObject optional Protocols.
     
     EXAMPLE #1 (CondorNSSort)
     
     //PROPERTY
     CondorNSSort *condorNSSort = [[CCondorNSSort alloc] init];
     
     //TEST METHOD
     NSMutableArray *nsmarray = [[NSMutableArray alloc] init];
     for (int i = 0; i < 10000000; i++)
     {
        unsigned short value = (unsigned short)arc4random_uniform(USHRT_MAX + 1);
        NSNumber *number = [NSNumber numberWithUnsignedShort:value];
        [nsmarray addObject:number];
     }
     //FEEL FREE TO RUN QUICK BENCHMARK AGAINST "sortedArrayUsingSelector"
     //NSDate *date = [NSDate date];
     
     //CONDOR SORT METHOD
     NSArray *nsarray = [self.condorNSSort sortUnsignedShortNSArray:nsmarray orderDesc:true];
     
     //APPLE SORT METHOD
     //NSArray *nsarray = [nsmarray sortedArrayUsingSelector: @selector(compare:)];
     
     //PERFORMANCE RESULTS
     //double timePassed_ms = [date timeIntervalSinceNow] * -1000.0;
     //NSLog(@"Performance: %f", timePassed_ms);

     [nsmarray removeAllObjects];
     nsmarray = nil;
     
     
     
     EXAMPLE #2 (CondorSort)
     
     //PROPERTY
     CondorSort *condorSort = [[CCondorSort alloc] init];
     
     //TEST METHOD
     signed int* array = (signed int*)calloc(10000000, 2);
     
     NSLog(@"Array Size 10000000");
     for(int i = 0; i < 10000000; i++)
     {
        signed int value = ((signed int)arc4random_uniform(21474836 * 2) - 21474836 );
        array[i] = (signed int)(value);
     }
     
     //FEEL FREE TO RUN QUICK BENCHMARK AGAINST "sortedArrayUsingSelector"
     
     //BUILD NSARRAY FOR APPLE METHOD
     //NSMutableArray *nsmarray = [[NSMutableArray alloc] init];
     //for (int i = 0; i < 10000000; i++) {
     //   NSNumber *number = [NSNumber numberWithInteger:array[i]];
     //   [nsmarray addObject:number];
     //}
     //NSArray *nsarray = nsmarray;
     
     //START TIME CHECK
     //NSDate *date = [NSDate date];
     
     //APPLE SORT METHOD
     //nsarray = [nsarray sortedArrayUsingSelector: @selector(compare:)];
     
     //CONDOR SORT METHOD
     [self.condorSort sortSignedIntArray:array withLength:10000000];
     
     //WRITE PERFORMANCE RESULT
     //double timePassed_ms = [date timeIntervalSinceNow] * -1000.0;
     //NSLog(@"Performance: %f", timePassed_ms);
     
     free(array);
     
     EXAMPLE #3 (CondorObjectSort and <CondorObject>)
     - This example is available as part of the GitHub App
     
