//
//  ViewController.m
//  Boids
//
//  Created by Goozix Developer on 5/20/17.
//  Copyright © 2017 Goozix Developer. All rights reserved.
//

#import "ViewController.h"
#import "MyScene.h"
#import "SettingsViewController.h"

@implementation ViewController

MyScene * scene;

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    scene = [MyScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (IBAction)settings:(id)sender
{
    NSLog(@"Button Pushed");
    // Create the modal view controller
    SettingsViewController *viewController = [[SettingsViewController alloc]
                                           initWithNibName:@"SettingsViewController"
                                           bundle:nil];
    
    viewController.manager = scene.boidManager;
    viewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    // show the navigation controller modally
    [self presentViewController:viewController animated:YES completion:Nil];
}





@end
