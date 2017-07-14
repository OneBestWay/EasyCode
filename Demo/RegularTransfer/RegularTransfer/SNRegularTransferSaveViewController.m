//
//  SNRegularTransferSaveViewController.m
//  SNYifubao
//
//  Created by GK on 2017/6/26.
//  Copyright © 2017年 Suning. All rights reserved.
//

#import "SNRegularTransferSaveViewController.h"

@interface SNRegularTransferSaveViewController ()<UITextViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *amountBottomLine;
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *amountBottomLineConstraint;

@property (weak, nonatomic) IBOutlet UITextField *payeeName; //收款人姓名
@property (weak, nonatomic) IBOutlet UILabel *payeeBottomLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payeeBottomLineConstraint;

@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *accountBottomLineConstraint;
@property (weak, nonatomic) IBOutlet UILabel *accountBottomLine;

@property (weak, nonatomic) IBOutlet UITextField *dayTextField;
@property (weak, nonatomic) IBOutlet UILabel *dayBottomLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dayBottomLineConstraint;

@property (weak, nonatomic) IBOutlet UILabel *payOrderLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payOrderBottomLineHeightConstraint;

@property (weak, nonatomic) IBOutlet UILabel *remarkBottomLineLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *remarkBottomLineHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *remarkTextViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *remarkTextViewBottomConstraint;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *remarkHeightConstraint;

@property (weak, nonatomic) IBOutlet UILabel *notificationBottomLineLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *notificationBottomLineHeightConstraint;

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UILabel *phoneBottomLineLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneBottomLineHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leaveMessageHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (nonatomic,strong) UIView *currentView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewTopHeightConstraint;
@property (weak, nonatomic) IBOutlet UITextView *remarkTextView;
@property (nonatomic) CGPoint keyboardOffset;
@property (weak, nonatomic) IBOutlet UITextView *placeHolderTextView;
@property (weak, nonatomic) IBOutlet UITextView *leaveMessageTextView;
@property (weak, nonatomic) IBOutlet UITextView *leaveMessagePlaceHolderView;

@end

@implementation SNRegularTransferSaveViewController

- (instancetype)init {
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"TransferStoryboard" bundle:[NSBundle bundleForClass:[self class]]];
    
    self = [storyBoard instantiateViewControllerWithIdentifier:@"RegularTransferSaveViewController"];
    if (self) {
        return  self;
    }
    return nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self UIConfig];
    self.navigationController.navigationBar.translucent = NO;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self registerKeyboard];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self removeRegister];
}
// 到帐后是否通知父母
- (IBAction)switchButtonClicked:(UISwitch *)sender {
    
}

- (IBAction)mobileButtonClicked:(UIButton *)sender {
    
    switch (sender.tag) {
        case 1001: { //跳转到通讯录
            
            break;
        }
        case 1002: { //跳转到银行卡列表
            break;
        }
        case 1003: { //选择还款日 1-28
            break;
        }
        case 1004: { //选择还款顺序
            break;
        }
    }
}

// 弹出密码输入框 -  发送数据给服务端 - 高级实名 - 验证码输入
- (IBAction)nextButtonClicked:(UIButton *)sender {
    
}

-(void)UIConfig {
    self.amountBottomLineConstraint.constant = 0.5;
    self.payeeBottomLineConstraint.constant = 0.5;
    self.accountBottomLineConstraint.constant = 0.5;
    self.dayBottomLineConstraint.constant = 0.5;
    self.payOrderBottomLineHeightConstraint.constant = 0.5;
    self.remarkBottomLineHeightConstraint.constant = 0.5;
    self.notificationBottomLineHeightConstraint.constant = 0.5;
    self.phoneBottomLineHeightConstraint.constant = 0.5;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.scrollView addGestureRecognizer:tap];
}


// textfield delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    self.keyboardOffset = self.scrollView.contentOffset;
    self.currentView = textField;
    return  true;
}
// text view delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    self.currentView = textView;
    self.keyboardOffset = self.scrollView.contentOffset;
    return  true;
}

- (void)textViewDidChange:(UITextView *)textView {
    if ([textView isKindOfClass: [self.remarkTextView class]]) {
        NSString *inputtext= textView.text;
        if (inputtext.length > 0) {
            self.placeHolderTextView.hidden = YES;
        }else {
            self.placeHolderTextView.hidden = NO;
        }
    }
    
    if ([textView isKindOfClass:[self.leaveMessageTextView class]]) {
        NSString *inputtext= textView.text;
        if (inputtext.length > 0) {
            self.leaveMessagePlaceHolderView.hidden = YES;
        }else {
            self.leaveMessagePlaceHolderView.hidden = NO;
        }
    }
}
//property
- (void)setLeaveMessagePlaceHolderView:(UITextView *)leaveMessagePlaceHolderView {
    _leaveMessagePlaceHolderView = leaveMessagePlaceHolderView;
    _leaveMessagePlaceHolderView.textColor = [UIColor groupTableViewBackgroundColor];
    _leaveMessagePlaceHolderView.text = @"不说点什么吗？";
    _leaveMessagePlaceHolderView.font = [UIFont systemFontOfSize:15];
}
- (void)setPlaceHolderTextView:(UITextView *)placeHolderTextView {
    _placeHolderTextView = placeHolderTextView;
    
    _placeHolderTextView.textColor = [UIColor groupTableViewBackgroundColor];
    _placeHolderTextView.text = @"想要说点什么吗？";
    _placeHolderTextView.font = [UIFont systemFontOfSize:15];
}
//keyboard
- (void)registerKeyboard {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)removeRegister {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

- (void)keyboardShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    CGRect aRect = self.view.frame;
    
    CGRect rectSize = [self.view convertRect:self.currentView.frame fromView:self.currentView.superview];
    
    CGFloat maxHeight = rectSize.origin.y + rectSize.size.height;
    CGFloat offset = maxHeight + kbSize.height - aRect.size.height;
    
    if (offset > 0) {
        CGPoint innerOffset = self.scrollView.contentOffset;
        innerOffset.y += offset + 20;
        [self.scrollView setContentOffset:innerOffset animated:YES];
    }
}
- (void)keyboardHide:(NSNotification *)notification {

    CGFloat yOffset = self.scrollView.contentOffset.y - self.keyboardOffset.y;
    if ( yOffset > 0) {
        CGPoint innerOffset = self.scrollView.contentOffset;
        innerOffset.y -= yOffset;
        [self.scrollView setContentOffset:innerOffset animated:YES];
    }
}

// dismiss keyboard
- (void)dismissKeyboard {
    [self.scrollView endEditing:YES];
}
@end
