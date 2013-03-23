//
//  LocationAnnotation.h
//  Where2Meet
//
//  Created by Brandon Lehner on 3/13/13.
//  Copyright (c) 2013 University of Minnesota. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface LocationAnnotation : NSObject <MKAnnotation>

- (id)initWithTitle:(NSString*)title subtitle:(NSString*)subtitle coordinate:(CLLocationCoordinate2D)coordinate;

@end
