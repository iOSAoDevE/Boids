//
//  Boid.m
//  Boids
//
//  Created by Goozix Developer on 5/20/17.
//  Copyright © 2017 Goozix Developer. All rights reserved.
//

#import "Boid.h"

@implementation Boid

-(id)init
{
    if (self = [super initWithImageNamed:@"Boid"])
    {
        self.size = CGSizeMake(10.0, 15.0);
    }
    return self;
}

@end
