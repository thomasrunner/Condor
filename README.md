# Condor
Condor is a Sorting Framework available for both Objective C and Swift

Condor supports system and NSNumber type in an NSArray.

It comes with 2 specific classes:
     -CondorSort.h for system types (Boolean, unsigned char, signed char, unsigned short, signed short, unsigned int, signed int and float)
     -CondorNSSort.h for NSArray with NSNumbers of the types listed in CondorSort.
     
     EXAMPLE #1 (CondoCondorNSSort)
     
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
     //FEEL FREE TO BENCHMARK AGAINST "sortedArrayUsingSelector"
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
     signed int* array = (signed int*)calloc(10000000, 4);
     
     NSLog(@"Array Size 10000000");
     for(int i = 0; i < 10000000; i++)
     {
        signed int value = ((signed int)arc4random_uniform(21474836 * 2) - 21474836 );
        array[i] = (signed int)(value);
     }
     
     //FEEL FREE TO BENCHMARK AGAINST "sortedArrayUsingSelector"
     
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
     
     
