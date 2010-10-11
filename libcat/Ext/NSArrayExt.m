//
//  NSArrayExt.m
//  Bloque
//
//  Created by Woo-Kyoung Noh on 12/03/10.
//  Copyright 2010 factorcat. All rights reserved.
//

#import "NSArrayExt.h"
#import "NSStringExt.h"
#import "NSMutableArrayExt.h"
#import "Logger.h"

NSArray* PAIR(id uno, id dos) {
	NSMutableArray* ary = [NSMutableArray array];
	[ary addObject:(nil == uno) ? EMPTY_STRING : uno];
	[ary addObject:(nil == dos) ? EMPTY_STRING : dos];
	return ary;
}

NSArray* TRIO(id uno, id dos, id tres) {
	NSMutableArray* ary = [NSMutableArray array];
	[ary addObject:(nil == uno) ? EMPTY_STRING : uno];
	[ary addObject:(nil == dos) ? EMPTY_STRING : dos];
	[ary addObject:(nil == tres) ? EMPTY_STRING : tres];
	return ary;	
}


@implementation NSArray (Ext)

-(NSArray*) sortedArrayUsingFunction:(NSInteger (*)(id, id, void *))comparator {
	return [self sortedArrayUsingFunction:comparator context:nil];
}

-(BOOL) isEmpty {
	return 0 == self.count;
}

-(NSArray*) slice:(int)loc :(int)length_ {
	NSRange range;
	if (self.count > loc + length_) {
		range = NSMakeRange(loc, length_);
	} else {
		range = NSMakeRange(loc, self.count - loc);
	}
	return [self subarrayWithRange:range];
}

-(NSArray*) slice:(int)loc backward:(int)backward {
	return [self slice:loc :self.count + backward + 1];
}

-(BOOL) hasObject:(id)obj {
	return [self containsObject:obj];
}

-(NSArray*) append:(NSArray*)ary {
	return [self arrayByAddingObjectsFromArray:ary];
}

-(NSString*) join:(NSString*)separator {
	return [self componentsJoinedByString:separator];
}

-(NSString*) join {
	return [self componentsJoinedByString:EMPTY_STRING];
}

-(NSArray*) rshift:(int)cnt {
	int rot = self.count - cnt;
	NSRange left  = NSMakeRange(cnt, rot);
	NSRange right = NSMakeRange(0, cnt);
	return [[self subarrayWithRange:left] arrayByAddingObjectsFromArray:[self subarrayWithRange:right]];
}

-(id) objectAtFirst {
	if ([self count] > 0) {
		return [self objectAtIndex:0];		
	} else {
		return nil;
	}
}

-(id) objectAtSecond {
	if ([self count] > 1) {
		return [self objectAtIndex:1];		
	} else {
		return nil;
	}
}

-(id) objectAtThird {
	if ([self count] > 2) {
		return [self objectAtIndex:2];		
	} else {
		return nil;
	}
}

-(id) objectAtLast {
	if ([self count] > 0) {
		return [self lastObject];		
	} else {
		return nil;
	}
}

-(id) at:(int)idx {
	return [self objectAtIndex:idx];
}

-(id) last {
	return [self lastObject];
}

-(NSArray*) reverse {
	return [[self reverseObjectEnumerator] allObjects];
}

-(NSArray*) transpose {
	NSMutableArray* transposedArray = [NSMutableArray array];		
	if (self.count > 0) {
		NSArray* firstArray = [self objectAtFirst];
		for (int idx = 0; idx < firstArray.count; idx++) {
			[transposedArray addObject:[NSMutableArray array]];
		}
		for (NSArray* subarray in self) {
			for (int idx = 0; idx < subarray.count; idx++) {
				NSMutableArray* ary = [transposedArray objectAtIndex:idx];
				[ary addObject:[subarray objectAtIndex:idx]];
			}
		}
	}
	return transposedArray;
}

-(NSArray*) sort {
	return [self sortedArrayUsingSelector:@selector(compare:)];
}
	 
@end