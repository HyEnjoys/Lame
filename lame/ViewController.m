//
//  ViewController.m
//  lame
//
//  Created by MAC on 2019/6/27.
//  Copyright © 2019 MAC. All rights reserved.
//

#import "ViewController.h"
#import "lame.h"
#import "AudioPlay.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)segmentChange:(UISegmentedControl *)sender {
    AudioPlay *player = [[AudioPlay alloc] init];
    switch (sender.selectedSegmentIndex) {
        case 0: {
            [player playSourceFile];
        }
            break;
        case 1: {
            [player playSourceBuffer];
        }
            break;
        case 2: {
            [player playSourceBufferLoop];
        }
            break;
        case 3: {
            [player playStringBuffer];
        }
            break;
        default:
            [player playStringBufferLoop];
            break;
    }
}

@end
