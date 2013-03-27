//
//  LocationAnnotation.m
//  Where2Meet
//
//  Created by Brandon Lehner on 3/13/13.
//  Copyright (c) 2013 University of Minnesota. All rights reserved.
//

#import "LocationAnnotation.h"

@interface LocationAnnotation()

@property (nonatomic, copy) NSString *localTitle;
@property (nonatomic, copy) NSString *localSubtitle;
@property (nonatomic, assign) CLLocationCoordinate2D localCoordinate;

@end

@implementation LocationAnnotation

- (id)initWithTitle:(NSString*)title subtitle:(NSString*)subtitle coordinate:(CLLocationCoordinate2D)coordinate pinColor:(MKPinAnnotationColor)pinColor buttonType:(UIButtonType)buttonType
{
    if (self = [super init]) {
        self.localTitle = title;
        self.localSubtitle = subtitle;
        self.localCoordinate = coordinate;
        self.pinColor = pinColor;
        self.buttonType = buttonType;
    }
    return self;
}

- (NSString *)title
{
    return self.localTitle;
}

- (NSString *)subtitle
{
    return self.localSubtitle;
}

- (CLLocationCoordinate2D)coordinate
{
    return self.localCoordinate;
}

@end
