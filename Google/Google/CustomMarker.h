//
//  CustomMarker.h
//  Google
//
//  Created by Aditya Narayan on 11/25/15.
//  Copyright © 2015 turntotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomMarker : UIView <UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *locationImage;
@property (strong, nonatomic) IBOutlet UILabel *locationName;
@property (strong, nonatomic) IBOutlet UILabel *locationAddress;
@property (strong, nonatomic) IBOutlet UIButton *locationImageButton;

@end
