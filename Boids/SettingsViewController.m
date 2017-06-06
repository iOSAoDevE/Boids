//
//  SettingsViewController.m
//  Boids
//
//  Created by Goozix Developer on 5/20/17.
//  Copyright © 2017 Goozix Developer. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self setSliders];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButton:(id)sender{
    [self saveSliders];
    [self dismissViewControllerAnimated:YES completion:Nil];
}

- (void) setSliders
{
    self.minBoidVelocity.value = self.manager.minBoidVelocity;
    self.momentumFactor.value = self.manager.momentumFactor;
    self.copyingRadius.value = self.manager.copyingRadius;
    self.centroidRadius.value = self.manager.centroidRadius;
    self.avoidanceRadius.value = self.manager.avoidanceRadius;
    self.attractorRadius.value = self.manager.attractorRadius;
    self.viewingAngle.value = self.manager.viewingAngle;
    self.copyingWeight.value = self.manager.copyingWeight;
    self.centroidWeight.value = self.manager.centroidWeight;
    self.avoidanceWeight.value = self.manager.avoidanceWeight;
    self.attractorWeight.value = self.manager.attractorWeight;
    self.noiseWeight.value = self.manager.noiseWeight;
}

- (void) saveSliders
{
    self.manager.minBoidVelocity = self.minBoidVelocity.value;
    self.manager.momentumFactor = self.momentumFactor.value;
    self.manager.copyingRadius = self.copyingRadius.value;
    self.manager.centroidRadius = self.centroidRadius.value;
    self.manager.avoidanceRadius = self.avoidanceRadius.value;
    self.manager.attractorRadius = self.attractorRadius.value;
    self.manager.viewingAngle = self.viewingAngle.value;
    self.manager.copyingWeight = self.copyingWeight.value;
    self.manager.centroidWeight = self.centroidWeight.value;
    self.manager.avoidanceWeight = self.avoidanceWeight.value;
    self.manager.attractorWeight = self.attractorWeight.value;
    self.manager.noiseWeight = self.noiseWeight.value;
}

@end
