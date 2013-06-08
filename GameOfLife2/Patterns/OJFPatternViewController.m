//
//  OJFPatternViewController.m
//  GameOfLife2
//
//  Created by Oliver Foggin on 22/09/2012.
//  Copyright (c) 2012 Oliver Foggin. All rights reserved.
//

#import "OJFPatternViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface OJFPatternViewController () <UIGestureRecognizerDelegate>

@property IBOutlet UIImageView *patternView;
@property IBOutlet UIView *gridView;
@property (strong, nonatomic) IBOutlet UIButton *tickButton;

@end

@implementation OJFPatternViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)displayView
{
    [self renderImage];
    
    [self layoutViews];
}

- (void)setPatternString:(NSString *)patternString
{
    _patternString = patternString;
    
    NSArray *strings = [patternString componentsSeparatedByString:@":"];
    
    self.points = nil;
    self.points = [NSMutableSet setWithCapacity:[strings count]];
    
    for (NSString *string in strings) {
        NSArray *coords = [string componentsSeparatedByString:@","];
        CGPoint point = CGPointMake([[coords objectAtIndex:0] floatValue], [[coords objectAtIndex:1] floatValue]);
        [self.points addObject:[NSValue valueWithCGPoint:point]];
    }
    
    [self calculateSize];
}

- (void)setPosition:(CGPoint)position
{
    self.view.center = position;
}

- (CGPoint)position
{
    return CGPointMake(self.view.frame.origin.x, self.view.frame.origin.y);
}

- (void)calculateSize
{
    float minx, maxx, miny, maxy;
    
    minx = miny = 9999999;
    maxx = maxy = 0;
    
    for (NSValue *value in self.points) {
        CGPoint point = [value CGPointValue];
        
        if (point.x > maxx) {
            maxx = point.x;
        }
        if (point.y > maxy) {
            maxy = point.y;
        }
        if (point.x < minx) {
            minx = point.x;
        }
        if (point.y < miny) {
            miny = point.y;
        }
    }
    
    self.size = CGSizeMake(maxx, maxy);
}

- (void)renderImage
{
    GLubyte *imageBuffer = (GLubyte *) malloc(self.size.width * self.size.height * 4);
    
    //set the whole image transparent
    for (int i=0; i<self.size.width * self.size.height; i++) {
        imageBuffer[i * 4] = 255;
        imageBuffer[i * 4 + 1] = 255;
        imageBuffer[i * 4 + 2] = 255;
        imageBuffer[i * 4 + 3] = 0;
    }
    
    //set required pixels black
    for (NSValue *value in self.points) {
        CGPoint point = [value CGPointValue];
        
        int pixelRef = (point.y - 1) * self.size.width + (point.x - 1);
        
        imageBuffer[pixelRef * 4] = 0;
        imageBuffer[pixelRef * 4 + 1] = 0;
        imageBuffer[pixelRef * 4 + 2] = 0;
        imageBuffer[pixelRef * 4 + 3] = 255;
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, imageBuffer, (self.size.width * self.size.height), NULL);
    
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaLast;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    //create image
    CGImageRef imageRef = CGImageCreate(self.size.width, self.size.height, 8, 32, 4 * self.size.width, colorSpace, bitmapInfo, provider, NULL, NO, kCGRenderingIntentDefault);
    
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    self.patternView.layer.magnificationFilter = kCAFilterNearest;
    
    self.patternView.image = image;
    
    imageBuffer = nil;
}

- (void)layoutViews
{
    self.view.frame = CGRectMake(0, 0, (self.size.width + 2) * self.cellSize + 40, (self.size.height + 2) * self.cellSize + 40);
    self.gridView.frame = CGRectMake(20, 20, self.view.frame.size.width - 40, self.view.frame.size.height - 40);
    self.patternView.frame = CGRectMake(20 + self.cellSize, 20 + self.cellSize, self.cellSize * self.size.width, self.cellSize * self.size.height);
    self.tickButton.frame = CGRectMake(self.view.frame.size.width - 40, 0, 40, 40);
}

- (void)tickButtonPressed:(id)sender
{
    [self.delegate patternDidConfirmPosition];
}

#pragma mark - gesture recogniser

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (IBAction)gestureRecognizerDidAction:(id)sender {
    UIPanGestureRecognizer *recogniser = (UIPanGestureRecognizer*)sender;
    
    CGPoint translation = [recogniser translationInView:self.view];
    
    float x = self.view.center.x + translation.x;
    float y = self.view.center.y + translation.y;
    
    self.view.center = CGPointMake(x, y);
    
    [recogniser setTranslation:CGPointZero inView:self.view];
}

@end
