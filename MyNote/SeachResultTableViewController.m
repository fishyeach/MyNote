//
//  SeachResultTableViewController.m
//  MyNote
//
//  Created by xd_ on 15/5/13.
//  Copyright (c) 2015年 ly. All rights reserved.
//

#import "SeachResultTableViewController.h"
#import "DataInfo.h"
#import "SeachResultCell.h"
#import "OneDayDataHeader.h"
#import "Tools.h"

#define fromTime 1
#define fromCate 2
#define spendingTag -1
#define incomeTag 1

@interface SeachResultTableViewController (){
    UISegmentedControl *segment;
    double spedingTotal,incomeTotal;
}

@end

@implementation SeachResultTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)initTitle{
    if (_fromTag == fromCate) {
        segment = [[UISegmentedControl alloc] initWithItems:nil];
        [segment insertSegmentWithTitle:@"支出" atIndex:0 animated:YES];
        [segment insertSegmentWithTitle:@"收入" atIndex:1 animated:YES];
        [segment setWidth:(Screen_width - 150) / 2 forSegmentAtIndex:0];
        [segment setWidth:(Screen_width - 150) / 2 forSegmentAtIndex:1];
        if (_spendingOrIncome == spendingTag) {
            segment.selectedSegmentIndex = 0;
        }else
            segment.selectedSegmentIndex = 1;
        self.navigationItem.titleView = segment;
    }else{
        self.navigationItem.title = _titleStr;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    if (_fromTag == fromCate) {
        return 1;
    }else
        return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (_fromTag == fromCate) {
        switch (_spendingOrIncome) {
            case spendingTag:
                return [_spendingList count];
                break;
            default:
                return [_incomeList count];
                break;
        }
    }else{
        switch (section) {
            case 0:
                 return [_spendingList count];
                break;
            default:
                return [_incomeList count];
                break;
        }
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifiter = @"SeachResultCell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    SeachResultCell *cell = [tableView dequeueReusableCellWithIdentifier:identifiter];
    if (cell == nil) {
        UINib *nib = [UINib nibWithNibName:@"SeachResultCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:identifiter];
        cell = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    }
     
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 56;
}

#pragma mark - Table view delegate

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"OneDayDataHeader" owner:nil options:nil];
    OneDayDataHeader *header = [views objectAtIndex:0];
    header.frame = CGRectMake(0, 0, Screen_width, 56);
    header.titleCategory.text = _categoryStr;
    if (_fromTag == fromCate) {
        header.title.text = @"";
        
        if (_spendingOrIncome == spendingTag) {
            for (DataInfo *info in _spendingList) {
                spedingTotal += [[info money] doubleValue];
            }
            header.titleMoney.text = [Tools stringDisposeWithFloat:spedingTotal];
        }else{
            for (DataInfo *info in _spendingList) {
                incomeTotal += [[info money] doubleValue];
            }
             header.titleMoney.text = [Tools stringDisposeWithFloat:incomeTotal];
        }
        
    }
    [header.selectCategoryBtn setTag:section];
    [header.selectCategoryBtn addTarget:self action:@selector(headerBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    return header;
}

-(void)headerBtnAction:(UIButton *)btn{

}
/*
 
// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
