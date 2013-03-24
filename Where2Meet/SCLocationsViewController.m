//
//  SCLocationsViewController.m
//  Where2Meet
//
//  Created by Brandon Lehner on 3/13/13.
//  Copyright (c) 2013 University of Minnesota. All rights reserved.
//

#import "SCLocationsViewController.h"
#import "LocationAnnotation.h"
#import "Invitee.h"
#import <FacebookSDK/FacebookSDK.h>

@interface SCLocationsViewController ()

@end

@implementation SCLocationsViewController
@synthesize listofPOIs=_listofPOIs;


#define METERS_PER_MILE 1609.344

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.mapView.userTrackingMode = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self showMapAtLocation:self.mapView.userLocation.coordinate];
    
    // Show the location of each person that has been invited.
    for (Invitee *invitee in self.meetingModel.inviteeDetails)
    {
        if (invitee.latitude && invitee.longitude)
        {
            CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(invitee.latitude.doubleValue, invitee.longitude.doubleValue);
        
            [self showMarkerWithTitle:invitee.facebookUserId withSubtitle:@"subtitle" AtLocation:coord];
        }
    }
    
    // Show the location of POIs near center points
    NSDictionary<FBGraphPlace>* eachPlace;
    
    for (eachPlace in self.listofPOIs) {
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(eachPlace.location.latitude.doubleValue, eachPlace.location.longitude.doubleValue);
        [self showMarkerWithTitle:eachPlace.id withSubtitle:eachPlace.name AtLocation:coord];
    }

}

// Moves the map to the given coordinates
- (void) showMapAtLocation:(CLLocationCoordinate2D)coordinates
{
    const float scale = 5.0;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coordinates, scale*METERS_PER_MILE, scale*METERS_PER_MILE);
    
    [self.mapView setRegion:viewRegion animated:YES];
}

- (void) showMarkerWithTitle:(NSString *)title withSubtitle:(NSString *)subtitle AtLocation:(CLLocationCoordinate2D)coordinate
{
    LocationAnnotation *annotation = [[LocationAnnotation alloc] initWithTitle:title subtitle:subtitle coordinate:coordinate];
    
    [self.mapView addAnnotation:annotation];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        //Don't trample the user location annotation (pulsing blue dot).
        return nil;
    }
    
    MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"pinView"];
    if (!pinView) {
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pinView"];
        pinView.pinColor = MKPinAnnotationColorRed;
        pinView.animatesDrop = YES;
        pinView.canShowCallout = YES;
        
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        pinView.rightCalloutAccessoryView = rightButton;
        pinView.annotation = annotation;
    } else {
        pinView.annotation = annotation;
    }
    return pinView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    // TODO: Segue
}

@end
