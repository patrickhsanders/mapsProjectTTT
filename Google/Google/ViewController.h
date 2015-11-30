//
//  ViewController.h
//  Google
//
//  Created by Patrick Sanders on 23.11.15.
//  Copyright © 2015 turntotech. All rights reserved.
//

#import <UIKit/UIKit.h>
@import GoogleMaps;
@import WebKit;
#import "MapAnnotation.h"

@interface ViewController : UIViewController <GMSMapViewDelegate, UISearchBarDelegate, NSURLSessionDelegate, NSURLSessionDataDelegate>


@end

