//
//  ViewController.m
//  markDown
//
//  Created by rogerjiang on 4/6/16.
//  Copyright © 2016 tencent. All rights reserved.
//

#import "ViewController.h"
#import "MMMarkdown.h"
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
    
    NSString * articleContent = @"####姑娘,愿你不单纯也光芒万丈\n  > 一盏灯，一片黄昏；看得清远方，却发现那是最远的地方。没有休闲的神韵，却又那想不到的坚持，获得了又怎样，没有获得又能怎样，不过是每一天不停地探索，不停的生活\n平庸并不是生活的意义，偏偏有些人硬是要把生活活生生地演成了平庸的样子。至今难忘大学时候的辅导员曾给我们说的一番话，“事实上，人的平庸和失败是有梯度的”\n[百度](http://baidu.com)\n-成本的可控性能\n-成本的基本要素\n-成本可以适配的地方\n他们太急着成功,总是幻想着走一步就能加一分，死挺着走到了100步，就以为自己能100%地有所收获。偏偏有时候他们所选择的这个“游戏”，其设置为要达到100000分才算过关。走过的路始终能让他们有所收益，但他们依然平庸，因为半途而废，功亏一篑。 \n 做得到努力，做不到拼尽全力，破斧沉舟。他们背负在人生的路上前行，不曾回头，始终坚定。他们依然平庸。因为尚离成功太远。他们总是优哉游哉，舒适地努力着，所以成功都被那些努力的可刻骨铭心给抢走了。\n人生应该要像系鞋带，人唯有勒得越紧，才越不容易松绑，才不需要时刻停下来系绑，才不致于因此落后于众人。 \n![text](http://qq.com)";
    NSError *error = nil;
    
    purpleMarkDown *purleMarkDownParse = [[purpleMarkDown alloc] init];
    purpleDocument *document = [purleMarkDownParse parseMarkdown:articleContent error:&error];
    
    purpleShowView *showView = [[purpleShowView alloc] initWithDocument:document style:purpleTextLayout_BlackRose];
    [showView setFrame:CGRectMake(20, 20, self.view.frame.size.width-40, self.view.frame.size.height-20)];
    [self.view addSubview:showView];
    
}

@end
