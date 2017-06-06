//
//  MyScene.h
//  Boids
//
//  Created by Goozix Developer on 5/20/17.
//  Copyright © 2017 Goozix Developer. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "BoidManager.h"

@interface MyScene : SKScene

@property (strong, atomic) BoidManager *boidManager;

@end
