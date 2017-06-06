//
//  SettingsViewController.h
//  Boids
//
//  Created by Goozix Developer on 5/20/17.
//  Copyright © 2017 Goozix Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoidManager.h"

@interface SettingsViewController : UIViewController

- (IBAction)backButton:(id)sender;

@property (weak) BoidManager *manager;
@property (strong, nonatomic) IBOutlet UISlider *minBoidVelocity;
@property (strong, nonatomic) IBOutlet UISlider *momentumFactor;
@property (strong, nonatomic) IBOutlet UISlider *copyingRadius;
@property (strong, nonatomic) IBOutlet UISlider *centroidRadius;
@property (strong, nonatomic) IBOutlet UISlider *avoidanceRadius;
@property (strong, nonatomic) IBOutlet UISlider *attractorRadius;
@property (strong, nonatomic) IBOutlet UISlider *viewingAngle;
@property (strong, nonatomic) IBOutlet UISlider *copyingWeight;
@property (strong, nonatomic) IBOutlet UISlider *centroidWeight;
@property (strong, nonatomic) IBOutlet UISlider *avoidanceWeight;
@property (strong, nonatomic) IBOutlet UISlider *attractorWeight;
@property (strong, nonatomic) IBOutlet UISlider *noiseWeight;

@end
