//
//  ViewController.m
//  markDown
//
//  Created by rogerjiang on 4/6/16.
//  Copyright © 2016 tencent. All rights reserved.
//

#import "ViewController.h"
#import "purpleShowView.h"
#import "purpleMarkDown.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    [super loadView];
    
    NSString * articleContent = @"####你讲话时，可真像一把刀子啊\n> 一盏灯，一片黄昏；看得清远方，却发现那是最远的地方。没有休闲的神韵，却又那想不到的坚持，获得了又怎样，没有获得又能怎样，不过是每一天不停地探索，不停的生活\n[百度](http://baidu.com)\n-成本的可控性能\n-成本的基本要素\n-成本可以适配的地方\n![text](http://qq.com)";
    NSError *error = nil;
    
    purpleMarkDown *purleMarkDownParse = [[purpleMarkDown alloc] init];
    purpleDocument *document = [purleMarkDownParse parseMarkdown:articleContent error:&error];
    
    purpleShowView *showView = [[purpleShowView alloc] initWithDocument:document style:purpleTextLayout_BlackRose];
    [showView setFrame:CGRectMake(20, 20, self.view.frame.size.width-40, self.view.frame.size.height-20)];
    [self.view addSubview:showView];
    
}

@end
