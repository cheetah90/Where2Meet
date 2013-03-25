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
#import "SCLocationDetailsViewController.h"

@interface SCLocationsViewController ()

@property (nonatomic) BOOL initialPositon;

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
    
    // Only zoom the the user's current location when we load the first time.
    // Don't keep zooming in and out as we go to the location details view.
    if (!self.initialPositon)
    {
        self.initialPositon = YES;
        [self showMapAtLocation:self.mapView.userLocation.coordinate];
    }
    
    // Show the location of each person that has been invited.
    for (Invitee *invitee in self.meetingModel.inviteeDetails)
    {
        if (invitee.latitude && invitee.longitude)
        {
            CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(invitee.latitude.doubleValue, invitee.longitude.doubleValue);
            
            LocationAnnotation *annotation = [[LocationAnnotation alloc] initWithTitle:invitee.facebookUserId subtitle:@"" coordinate:coord pinColor:MKPinAnnotationColorGreen buttonType:UIButtonTypeCustom];
            
            [self.mapView addAnnotation:annotation];
        }
    }
    
    // Show the location of POIs near center points
    NSDictionary<FBGraphPlace>* eachPlace;
    
    for (eachPlace in self.listofPOIs) {
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(eachPlace.location.latitude.doubleValue, eachPlace.location.longitude.doubleValue);
        
        LocationAnnotation *annotation = [[LocationAnnotation alloc] initWithTitle:eachPlace.name subtitle:@"" coordinate:coord pinColor:MKPinAnnotationColorRed buttonType:UIButtonTypeDetailDisclosure];
        
        annotation.facebookId = eachPlace.id;
        [self.mapView addAnnotation:annotation];
    }
}

// Moves the map to the given coordinates
- (void) showMapAtLocation:(CLLocationCoordinate2D)coordinates
{
    const float scale = 5.0;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coordinates, scale*METERS_PER_MILE, scale*METERS_PER_MILE);
    
    [self.mapView setRegion:viewRegion animated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        //Don't trample the user location annotation (pulsing blue dot).
        return nil;
    }
    
    LocationAnnotation *locationAnnotation = (LocationAnnotation *)annotation;
    
    MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"pinView"];
    if (!pinView) {
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pinView"];
        pinView.pinColor = locationAnnotation.pinColor;
        pinView.animatesDrop = YES;
        pinView.canShowCallout = YES;
        
        pinView.rightCalloutAccessoryView = [UIButton buttonWithType:locationAnnotation.buttonType];
        pinView.annotation = annotation;
    } else {
        pinView.annotation = annotation;
    }
    return pinView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier: @"LocationsToLocationDetails" sender:view];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"LocationsToLocationDetails"])
    {
        LocationAnnotation *annotation = ((MKAnnotationView *)sender).annotation;
        SCLocationDetailsViewController *controller = (SCLocationDetailsViewController *) segue.destinationViewController;
        
        controller.meetingId = self.meetingModel.meetingId;
        controller.facebookLocationId = annotation.facebookId;
    }
}

@end
