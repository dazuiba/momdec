//
//  NSPropertyDescription+xmlElement.m
//  momdec
//
//  Created by Tom Harrington on 4/6/13.
//  Copyright (c) 2013 Tom Harrington. All rights reserved.
//

#import "NSPropertyDescription+xmlElement.h"

@implementation NSPropertyDescription (xmlElement)

- (NSXMLElement *)xmlElement
{
    if ([self isMemberOfClass:[NSPropertyDescription class]]) {
        NSException *exception = [NSException exceptionWithName:NSGenericException reason:@"NSPropertyDescription has no XML element" userInfo:nil];
        [exception raise];
        return nil;
    }
    NSXMLElement *element = [NSXMLElement elementWithName:@"attribute"];
    [element addAttribute:[NSXMLNode attributeWithName:@"name" stringValue:[self name]]];
    if ([self isOptional]) {
        [element addAttribute:[NSXMLNode attributeWithName:@"optional" stringValue:@"YES"]];
    }
    if ([self isTransient]) {
        [element addAttribute:[NSXMLNode attributeWithName:@"transient" stringValue:@"YES"]];
    }
    if ([self isIndexed]) {
        [element addAttribute:[NSXMLNode attributeWithName:@"indexed" stringValue:@"YES"]];
    }
    
    NSDictionary *userInfo = [self userInfo];
    NSString *syncable = userInfo[@"com.apple.syncservices.Syncable"];
    if ((syncable == nil) || ((syncable != nil) && (![syncable isEqualToString:@"NO"]))) {
        [element addAttribute:[NSXMLNode attributeWithName:@"syncable" stringValue:@"YES"]];
    }
    
    if ([userInfo count] > 0) {
        NSXMLElement *userInfoElement = [[NSXMLElement alloc] initWithName:@"userInfo"];
        for (NSString *userInfoKey in userInfo) {
            NSString *userInfoValue = userInfo[userInfoKey];
            if ([userInfoKey isEqualToString:@"com.apple.syncservices.Syncable"]) {
                // This key should never appear in uncompiled models.
            } else {
                NSXMLElement *userInfoEntry = [[NSXMLElement alloc] initWithName:@"entry"];
                NSDictionary *userInfoAttributes = @{@"key" : userInfoKey, @"value" : userInfoValue};
                [userInfoEntry setAttributesWithDictionary:userInfoAttributes];
                [userInfoElement addChild:userInfoEntry];
            }
        }
        [element addChild:userInfoElement];
    }
    
    if ([self versionHashModifier] != nil) {
        [element addAttribute:[NSXMLNode attributeWithName:@"versionHashModifier" stringValue:[self versionHashModifier]]];
    }
    if ([self renamingIdentifier] != nil) {
        [element addAttribute:[NSXMLNode attributeWithName:@"elementID" stringValue:[self renamingIdentifier]]];
    }
    return element;
}

@end
