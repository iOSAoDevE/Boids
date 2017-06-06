//
//  BoidManager.m
//  Boids
//
//  Created by Goozix Developer on 5/20/17.
//  Copyright © 2017 Goozix Developer. All rights reserved.
//

#import "BoidManager.h"


// Destructively normalise a vector
void norm(CGFloat *x, CGFloat *y)
{
    CGFloat dsquared = *x * *x + *y * *y;
    if (dsquared < 1 || dsquared == 0) return;
    
    // Divide by magnitude to normalise
    CGFloat d = sqrt(dsquared);
    *x /= d;
    *y /= d;
}

@implementation BoidManager

NSMutableArray *boids;
NSSet *attractors;

-(BoidManager *) initWithCapacity:(NSUInteger)n
{
    if((self = [super init]))
    {
        // Set up array for boids
        boids = [[NSMutableArray alloc] initWithCapacity:n];
        
        // And create a root spritekit node for them
        _rootBoidNode = [[SKNode alloc] init];
        
        for (uint i=0; i<n; i++) {
            Boid *b = [[Boid alloc] init];
            
            // Start position
            CGFloat x = 200 + (float)arc4random_uniform(30000) / 100.0;
            CGFloat y = 200 + (float)arc4random_uniform(60000) / 100.0;
            b.position = CGPointMake(x, y);
            
            // Velocity vector
            b.dx = 50.0 - (float)arc4random_uniform(30000) / 150.0;
            b.dy = 50.0 - (float)arc4random_uniform(30000) / 150.0;
            
            [boids addObject:b];
            [_rootBoidNode addChild:b];
        }
        
        
        self.minBoidVelocity = 40.0;
        self.momentumFactor = 0.25;
        self.viewingAngle = 270.0/360.0 * 2 * M_PI;
        
        self.copyingRadius = 80.0;
        self.centroidRadius = 30.0;
        self.avoidanceRadius = 20.0;
        self.attractorRadius = 300.0;
        
        self.copyingWeight = 0.5;
        self.centroidWeight = 0.5;
        self.avoidanceWeight = 1.0;
        self.attractorWeight = 1.0;
        
        self.width = 768;
        self.height = 1024;
    }
    
    return self;
}

-(void) oldnextTimeStep:(NSTimeInterval)deltat
{
    for (Boid *b in boids) {
        CGFloat newX = b.position.x + b.dx * deltat;
        CGFloat newY = b.position.y + b.dy * deltat;
        b.position = CGPointMake(newX, newY);
        
        CGFloat theta = (float)arc4random_uniform(20)/100.0 - 0.10;
        CGFloat newdX = b.dx * cosf(theta) - b.dy * sinf(theta);
        CGFloat newdY = b.dx * sinf(theta) + b.dy * cosf(theta);
        b.dx = newdX;
        b.dy = newdY;
    }
}

-(CGPoint) getBoidLocationForPosition:(NSUInteger) n
{
    Boid *b = [boids objectAtIndex:n];
    //NSLog(@"Boid %d Position %f,%f", n, b.p.x, b.p.y);
    return b.position;
}

-(CGFloat) getBoidOrientationForPosition:(NSUInteger) n
{
    Boid *b = [boids objectAtIndex:n];
    return atan2f(b.dy, b.dx);
}

-(void) nextTimeStep:(NSTimeInterval)deltat withAttractors:(NSSet *)attractorPoints
{
    attractors = attractorPoints;
    // Update velocity for all boids
    for (Boid *b in boids) {
        [self updateBoidVelocity:b];
    }
    
    // Update position for all boids
    for (Boid *b in boids) {
        // Compute new position
        CGFloat newX = b.position.x + b.dx * deltat;
        CGFloat newY = b.position.y + b.dy * deltat;
        
        // Set new positions
        b.position = CGPointMake(newX, newY);
        b.zRotation = atan2f(b.dy, b.dx);

        // Update deltas
        b.dx = b.new_dx;
        b.dy = b.new_dy;
    }
}

-(void) updateBoidVelocity: (Boid *) mainBoid
{
    
    // Position of main boid
    CGFloat x = mainBoid.position.x;
    CGFloat y = mainBoid.position.y;
    
    // Radius thresholds for excluding boids that are too far away
    CGFloat rMax = _copyingRadius > _centroidRadius ? _copyingRadius : _centroidRadius;
    rMax = rMax > _avoidanceRadius ? rMax : _avoidanceRadius;
    CGFloat rMaxSquared = rMax * rMax;
    
    // half cosine for viewing angle
    CGFloat cosTheta = cos(_viewingAngle) / 2.0;
    
    // magnitude of main boid velocity vector
    CGFloat mainBoidVelocityMagnitude = sqrt(mainBoid.dx * mainBoid.dx + mainBoid.dy * mainBoid.dy);
    
    // Set up accumulator variables for loop
    CGFloat x_copy = 0;
    CGFloat y_copy = 0;
    CGFloat x_centroid = 0;
    CGFloat y_centroid = 0;
    CGFloat n_centroid = 0;
    CGFloat x_avoid = 0;
    CGFloat y_avoid = 0;
    CGFloat x_attractor = 0;
    CGFloat y_attractor = 0;
    
    // Loop over all the boids
    for (Boid *b in boids) {
        // Skip self
        if (b == mainBoid){
            continue;
        }
        
        // Compute vector between mainBoid and b
        CGFloat xDist = b.position.x - x;
        CGFloat yDist = b.position.y - y;
        
        // Get distance squared for cheap thresholding
        CGFloat distanceSquared = xDist * xDist + yDist * yDist;
        
        // Skip any too far away to have any influence
        if (distanceSquared > rMaxSquared){continue;}
        
        CGFloat distance = sqrt(distanceSquared);
        
        // Calculate cosine of angle between mainBoid velocity vector and vector between mainBoid and b
        CGFloat cosB = (mainBoid.dx * xDist + mainBoid.dy * yDist) / (mainBoidVelocityMagnitude * distance);
        
        // Skip if outside of viewing angle
        if (cosB < cosTheta){continue;}
        
        // Centre on boid
        if(distance <= _centroidRadius && distance > _avoidanceRadius) {
            x_centroid += x - b.position.x;
            y_centroid += y - b.position.y;
            n_centroid++;
        }
        
        // Copy boid's heading
        if(distance <= _copyingRadius && distance > _avoidanceRadius) {
            x_copy += b.dx;
            y_copy += b.dy;
        }
        
        // Avoid collision
        if(distance <= _avoidanceRadius) {
            // Avoidance vector
            CGFloat xtemp = x - b.position.x;
            CGFloat ytemp = y - b.position.y;
            
            // Scale by distance
            CGFloat d = 1 / sqrt(xtemp * xtemp + ytemp * ytemp);
            xtemp *= d;
            ytemp *= d;
            x_avoid += xtemp;
            y_avoid += ytemp;
        }
    }
    
    // Avoid edges
    if (x < _avoidanceRadius){
        x_avoid += _avoidanceRadius - x;
    }
    if (x > _width - _avoidanceRadius) x_avoid += (_width - _avoidanceRadius) - x;
    if (y < _avoidanceRadius){
        y_avoid += _avoidanceRadius - y;
    }
    if (y > _height - _avoidanceRadius) y_avoid += (_height - _avoidanceRadius) - y;
    
    
    // Skip centering if there's just one bird, to avoid needy weirdness
    if(n_centroid < 2){
        x_centroid = 0;
        y_centroid = 0;
    }
    
    // Loop over attractors
    CGFloat attractorRadiusSquared = _attractorRadius * _attractorRadius;
    for (NSValue *v in attractors) {
        CGPoint a = [v CGPointValue];
        CGFloat distanceX = a.x - x;
        CGFloat distanceY = a.y - y;
        CGFloat distanceSquared = distanceX * distanceX + distanceY * distanceY;
        if (distanceSquared > attractorRadiusSquared) continue;
        CGFloat distance = sqrt(distanceSquared);
        distanceX *= 1 / distance;
        distanceY *= 1 / distance;
        x_attractor += distanceX;
        y_attractor += distanceY;
    }
    
    // Normalise everything
    norm(&x_centroid, &y_centroid);
    norm(&x_copy, &y_copy);
    norm(&x_avoid, &y_avoid);
    norm(&x_attractor, &y_attractor);
    
    // Combine all into a vector
    CGFloat xt = _centroidWeight * x_centroid + _copyingWeight * x_copy + _avoidanceWeight * x_avoid + _attractorWeight * x_attractor;
    CGFloat yt = _centroidWeight * y_centroid + _copyingWeight * y_copy + _avoidanceWeight * y_avoid + _attractorWeight * y_attractor;
    
    // Add some noise, perhaps
    if(_noiseWeight > 0) {
        xt += (1 - (float)arc4random_uniform(200)/100.0) * _noiseWeight;
        yt += (1 - (float)arc4random_uniform(200)/100.0) * _noiseWeight;
    }
    
    
    // Update velocity with momentum
    CGFloat new_dx = mainBoid.dx * _momentumFactor + xt * (1 - _momentumFactor);
    CGFloat new_dy = mainBoid.dy * _momentumFactor + yt * (1 - _momentumFactor);
    
    // Renormalise if boid is getting too slow
    CGFloat velocity = sqrt(new_dx * new_dx + new_dy * new_dy);
    if(velocity < _minBoidVelocity) {
        new_dx *= _minBoidVelocity / velocity;
        new_dy *= _minBoidVelocity / velocity;
    }
    
    mainBoid.new_dx = new_dx;
    mainBoid.new_dy = new_dy;
}

@end

