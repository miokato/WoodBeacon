//
//  SelectViewController.m
//  WoodBeacon
//
//  Created by 加藤 未央 on 2/19/14.
//  Copyright (c) 2014 加藤 未央. All rights reserved.
//

#import "SelectViewController.h"
#import "NewsViewController.h"

@interface SelectViewController () {
//    NSMutableArray *_beacons;
}

@property (nonatomic) NSArray *beacons;
@property (nonatomic) UIBarButtonItem *addButton;

@end

@implementation SelectViewController

#pragma mark action

// +ボタンを押すと新しいオブジェクトを追加
//- (void)addItem:sender{
//    if (!_beacons) {
//        _beacons = [[NSMutableArray alloc] init];
//    }
//    [_beacons insertObject:@"noName" atIndex:0];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//}

- (IBAction)firstViewReturnActionForSegue:(UIStoryboardSegue *)segue
{
}

#pragma mark view

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.beacons = @[@"Black Beacon",@"White Beacon",@"Red Beacon"];
    
    // 遷移先から戻ってきたときに、選択を解除する
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];
    
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // タイトルをつける
    self.title = @"Select Beacon";
    
    // Uncomment the following line to preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = NO;
    
    // ナビゲーションバーボタン
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
//    self.addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
//                                                                                target:self
//                                                                                action:@selector(addItem:)];
//    self.navigationItem.rightBarButtonItem = self.addButton;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

// セクション数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// セルの数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.beacons count];
}

// セルがない場合作成
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = (self.beacons)[indexPath.row];
    
    return cell;
}

// セルをタップしたとき、何をするか
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"news" sender:nil];
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


 //テーブルビューの編集画面をよびだす
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


// 編集画面でセルを動かすことができる。
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}

// edit画面で表示されるinsertとdeleteを非表示に変更
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"news"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString *object = self.beacons[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}




@end
