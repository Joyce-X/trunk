//
//  XMEditProfileController.m
//  kuruibao
//
//  Created by x on 17/8/4.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMEditProfileController.h"
#import "UIImageView+WebCache.h"
#import "XMTakePhotoView.h"
#import "XMPresent.h"
#import "XMChooseSexView.h"
#import "ChinaPlckerView.h"
#import "XMInputView.h"
#import "XMUser.h"
#import "NSDictionary+convert.h"
#import "XMChoosePlaceView.h"
#import "MJExtension.h"
#import "XMPlaceModel.h"
#import "XMContentView.h"
#import "XMDateManager.h"
@interface XMEditProfileController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,XMInputViewDelegate,XMChoosePlaceViewDelegate>

//!< 显示用户具体信息
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *signNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;

@property (strong, nonatomic) UIImagePickerController *picker;


@property (strong, nonatomic) UIImage *headerImage;


//!< 记录需要上传的用户信息
@property (copy, nonatomic) NSString *imageUrl;
@property (copy, nonatomic) NSString *userName;
@property (copy, nonatomic) NSString *signName;
@property (copy, nonatomic) NSString *sex;
@property (copy, nonatomic) NSString *birthday;
@property (copy, nonatomic) NSString *place;

//!< 底部弹框
@property (strong, nonatomic) XMInputView *inputView;

//!< tem
@property (copy, nonatomic) NSString *temStr;//!< 临时记录时间

@property (weak, nonatomic) XMContentView *contentView;//!< inoputView 的容器


@property (strong, nonatomic) NSArray *sortArr;//!< 字典keys进行排序

@property (strong, nonatomic) NSDictionary *placeDic;//!< 区域数据源

@end

@implementation XMEditProfileController

- (void)viewDidLoad {
    
    [super viewDidLoad];
 
    [self setupInit];
 
}

- (void)setupInit
{
    self.showBackArrow = YES;
    
    self.showBackgroundImage = YES;
    
    self.showTitle = YES;
    
    self.Title = JJLocalizedString(@"编辑资料", nil);
    
    //!< 设置imageView圆角
    self.headerImageView.layer.masksToBounds = YES;
    
    self.headerImageView.layer.cornerRadius = 9;
    
    self.headerImageView.layer.borderColor = XMWhiteColor.CGColor;
    
    self.headerImageView.layer.borderWidth = 1;
    
    
    
    //!< 容器
    
    XMContentView *contentView = [XMContentView new];
    
    contentView.frame = CGRectMake(0, mainSize.height, mainSize.width, mainSize.height);
    
    [self.view addSubview:contentView];
    
    self.contentView = contentView;
    
    
    self.inputView = [[NSBundle mainBundle] loadNibNamed:@"XMInputView" owner:nil options:nil].firstObject;
    
    self.inputView.frame = CGRectMake(0, mainSize.height - 100, mainSize.width, 100);
    
    self.inputView.delegate = self;
    
    [self.contentView addSubview:self.inputView];
    
    [self getuserInfoData];
    
     UILabel *label_profile = [self.view viewWithTag:51];
     UILabel *label_userName = [self.view viewWithTag:52];
     UILabel *label_Mood = [self.view viewWithTag:53];
     UILabel *label_sex = [self.view viewWithTag:54];
     UILabel *label_birthday = [self.view viewWithTag:55];
     UILabel *label_place = [self.view viewWithTag:56];
    
    label_profile.text = JJLocalizedString(@"头像", nil);
    label_userName.text = JJLocalizedString(@"昵称", nil);
    label_Mood.text = JJLocalizedString(@"签名", nil);
    label_sex.text = JJLocalizedString(@"性别", nil);
    label_birthday.text = JJLocalizedString(@"生日", nil);
    label_place.text = JJLocalizedString(@"地区", nil);
    
    
}

- (void)setUserInfo:(NSDictionary *)userInfo
{
    
    if ([userInfo[@"data"] isKindOfClass:[NSString class]])
    {
        return;
    }
    
    NSArray *arr = userInfo[@"data"];
    
    NSDictionary *dic = arr.firstObject;
    
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"userimage"]] placeholderImage:[UIImage imageNamed:@"us_defaultIcon"]];
    
    self.userNameLabel.text = dic[@"nickname"];
    
    self.signNameLabel.text = dic[@"signname"];
    
    self.birthdayLabel.text = dic[@"birthday"];
    
    self.placeLabel.text = dic[@"userarea"];
    
    //!< 对性别进行处理  男：0  女：1
    if ([dic[@"sex"] intValue] == 0)
    {
          self.sexLabel.text = JJLocalizedString(@"男", nil);
        
    }else if ([dic[@"sex"] intValue] == 1)
    {
        
        self.sexLabel.text = JJLocalizedString(@"女", nil);
        
    }else{
        
        self.sexLabel.text = JJLocalizedString(@"其他", nil);
        
    }
    

}

#pragma mark ------- lazy
-(UIImagePickerController *)picker
{
    if (!_picker)
    {
        _picker = [[UIImagePickerController alloc]init];
        
        _picker.delegate = self;
    }

    return _picker;
}

/**
 *  获取用户信息数据
 */
- (void)getuserInfoData
{
    //!< 2 获取用户和信息数据，设置昵称和头像
    
    XMUser *user = [XMUser user];
    
    NSString *urlStr = [mainAddress stringByAppendingFormat:@"getuserinfo&Mobil=%@",user.mobil];
    
    if (!connecting)
    {
        //!< 没有网的时候
        NSCachedURLResponse *res = [[NSURLCache sharedURLCache] cachedResponseForRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
        
        if (res)
        {
            XMLOG(@"---------缓存存在-，不用加载备用数据--------");
            
            [XMMike addLogs:@"---------缓存存在-，不用加载备用数据--------"];

        }else
        {
            
            XMLOG(@"---------缓存不存在，准备加载备用数据---------");
            
            [XMMike addLogs:@"---------缓存不存在，准备加载备用数据---------"];

            if (self.manager.flag == NO)
            {
                XMLOG(@"---------本地没有存储数据，无法加载---------");
                
                [XMMike addLogs:@"---------本地没有存储数据，无法加载---------"];

            }else
            {
                
                XMLOG(@"---------本地有备用用户数据---------");
                
                [XMMike addLogs:@"---------本地有备用用户数据---------"];

                 //!< 设置数据
             
                [_headerImageView setImage:[UIImage imageWithData:_manager.profileData]];
                
                self.userNameLabel.text = _manager.nickName;
                
                self.signNameLabel.text = _manager.mood;
                
                self.birthdayLabel.text = _manager.birthday;
                
                self.placeLabel.text = _manager.region;
                
                //!< 对性别进行处理  男：0  女：1
                if ([_manager.sex intValue] == 0)
                {
                    self.sexLabel.text = JJLocalizedString(@"男", nil);
                    
                }else if ([_manager.sex intValue] == 1)
                {
                    
                    self.sexLabel.text = JJLocalizedString(@"女", nil);
                    
                }else{
                    
                    self.sexLabel.text = JJLocalizedString(@"其他", nil);
                    
                }
                
                
            }
            
            return;
            
        }
        
    }

    
    [self.session GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //!< 请求用户信息成功
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        dic = [NSDictionary nullDic:dic];//!< 出去NSNUll
        
        //!< 设置数据
        [self setUserInfo:dic];
        
        XMLOG(@"---------获取用户信息成功---------");
        
        [XMMike addLogs:[NSString stringWithFormat:@"---------获取用户信息成功---------"]];

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //!< 请求用户信息失败
        XMLOG(@"---------请求用户信息失败---------");
        
        [XMMike addLogs:[NSString stringWithFormat:@"---------请求用户信息失败---------"]];

        
    }];
    
     
}

#pragma mark ------- click event

//!< 点击头像一栏
- (IBAction)clickProfile:(id)sender {
    //!< 跳出选择
    __weak typeof(self) wself = self;
    
    XMTakePhotoView *chooseView = [[NSBundle mainBundle] loadNibNamed:@"XMTakePhotoView" owner:nil options:nil].firstObject;
    
    chooseView.callBack = ^(int index){
    
        [wself didChoosePhotoStyle:index];
    
    };
    
    [XMPresent presentView:chooseView];

}

//!< 点击用户名一栏
- (IBAction)clickUsername:(id)sender {
    
    self.inputView.tag = 12;//!< 标识userName
    
    self.inputView.limitLength = 24;
    
    self.inputView.content = self.userNameLabel.text;
    
//    [self.inputView becomeFirstResponder];
    [self.contentView showFirstLevel];
    
    
    
}
//!< 点击心情一栏
- (IBAction)clickMood:(id)sender {
    
    self.inputView.tag = 13;//!< 标识心情
    
    self.inputView.limitLength = 47;
    
    self.inputView.content = self.signNameLabel.text;
    
//    [self.inputView becomeFirstResponder];
     [self.contentView showFirstLevel];
 
}
//!< 点击性别一栏
- (IBAction)clickSex:(id)sender {
    
    //!< 跳出选择性别
    __weak typeof(self) wself = self;
    
    XMChooseSexView *chooseView = [[NSBundle mainBundle] loadNibNamed:@"XMChooseSexView" owner:nil options:nil].firstObject;
    
    chooseView.callBack = ^(int index){
        
        [wself didChooseSex:index];
        
    };
    
    [XMPresent presentView:chooseView];

}
//!< 点击生日一栏
- (IBAction)clickBirthday:(id)sender {
    
    
    UIView *backView = [UIView new];

    backView.backgroundColor = XMColorFromRGB(0x444348);
    
    UIDatePicker *picker = [[UIDatePicker alloc]init];
    
    [picker setValue:[UIColor whiteColor] forKey:@"textColor"];
    
    picker.backgroundColor = XMClearColor;
    
    picker.datePickerMode = UIDatePickerModeDate;
    
    [picker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    
    [backView addSubview:picker];
    
    [picker mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.top.equalTo(backView);
        
        make.height.equalTo(170);
        
    }];
    
    //!< add 取消按钮
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [cancelBtn setTitleColor:XMGrayColor forState:UIControlStateNormal];
    
    [cancelBtn setTitle:JJLocalizedString(@"取消", nil) forState:UIControlStateNormal];
    
    [cancelBtn addTarget:self action:@selector(dateCancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    
    [backView addSubview:cancelBtn];
    
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.bottom.equalTo(backView);
        
        make.width.equalTo(backView).multipliedBy(0.5);
        
        make.height.equalTo(40);
        
    }];
    
    //!< 添加完成按钮
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [okBtn setTitle:JJLocalizedString(@"完成", nil) forState:UIControlStateNormal];

    
    [okBtn setTitleColor:XMWhiteColor forState:UIControlStateNormal];
    
    [okBtn addTarget:self action:@selector(dateOKBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    okBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    
    [backView addSubview:okBtn];
    
    [okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.bottom.equalTo(backView);
        
        make.width.equalTo(backView).multipliedBy(0.5);
        
        make.height.equalTo(40);
        
    }];
    
    [XMPresent presentView:backView withSize:CGSizeMake(280, 210)];
    
    
}
//!< 点击位置一栏
- (IBAction)clickPlace:(id)sender {
    
    
    //!< 点击选择地区，开始解析数据
    if (self.dataSource.count == 0)
    {
        [self parserData];
    }
    
    //!< 选择地区
//      [ChinaPlckerView customChinaPicker:self superView:self.view];
    XMChoosePlaceView *view = [[NSBundle mainBundle] loadNibNamed:@"XMChoosePlaceView" owner:nil options:nil].firstObject;
    
    view.delegate = self;
    
    [view showInView:self.view];
    
    
}

- (void)parserData
{
    
   
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"uscitys.txt" ofType:nil];
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    self.sortArr =  [dic.allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    self.placeDic = dic;
    
//    [XMPlaceModel mj_setupObjectClassInArray:^NSDictionary *{
//        
//        return @{@"city":@"XMUSCityModel"};
//    }];
    

    
//    self.dataSource = [XMPlaceModel mj_objectArrayWithKeyValuesArray:arr];
    
    XMLOG(@"---------22---------");
    
    
}



/**
 选择日期的时候点击取消按钮
 */
- (void)dateCancelBtnClick
{
    [XMPresent dismiss];
    
}

/**
 选择日期的时候点击完成按钮
 */
- (void)dateOKBtnClick
{
    
    [XMPresent dismiss];
    
    //!< 保存数据
//    self.birthday = self.temStr;
    
    //!< 判断网络
    if (!connecting)
    {
        [MBProgressHUD showError:JJLocalizedString(@"网络未连接", nil)];
        
        return;
    }
    
    if (self.temStr.length == 0)
    {
        //!< 对时间做非空处理
        NSDateFormatter *format = [[NSDateFormatter alloc]init];
        
        format.dateFormat = @"yyyy-MM-dd";
        
        self.temStr = [format stringFromDate:[NSDate date]];
        
    }
    
    //!< 在这里修改时间
    self.birthdayLabel.text = [XMDateManager convertTimeToEnglishMonth:self.temStr];
    
    //!< 保存数据
    [self saveUserInfoWithContent:self.birthdayLabel.text type:4];
    
}

/**
  *  日期发生变化
 */
- (void)dateChange:(UIDatePicker *)picker
{
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    
    format.dateFormat = @"yyyy-MM-dd";
    
    NSString *dateStr = [format stringFromDate:picker.date];
    
    self.temStr = dateStr;
    
//    XMLOG(@"---------%@---------",dateStr);
    
}

#pragma mark ---  XMChoosePlaceViewDelegate

- (NSInteger)numberOfRowsInComponent:(NSInteger)component inPicker:(UIPickerView *)picker
{
    if (component == 0)
    {
//        return self.dataSource.count;//!< 返回州的数量
        return self.sortArr.count;//!< 返回州的数量
        
    }else
    {
//        //!< 返回每个州市的数量
//        NSInteger index = [picker selectedRowInComponent:0];
//        
//        XMPlaceModel *model = self.dataSource[index];
//        
//        return model.city.count;
        
        //!< 返回每个州市的数量
        NSInteger index = [picker selectedRowInComponent:0];
        
//        XMPlaceModel *model = self.dataSource[index];
        NSArray *arr = [self.placeDic objectForKey:self.sortArr[index]];
        
//        return model.city.count;
        return arr.count;
    
    
    }


}
 
- (NSString *)titleForRow:(NSInteger)row forComponent:(NSInteger)component inPicker:(UIPickerView *)picker
{

    if (component == 0)
    {
        //!< 返回州的名称
//        XMPlaceModel *model = self.dataSource[row];
//        
//        return model.name;
        return self.sortArr[row];
//        
    }else
    {
        
        NSInteger index = [picker selectedRowInComponent:0];
//        
//        XMPlaceModel *model = self.dataSource[index];
        NSString *key = self.sortArr[index];
        
        NSArray *arr = self.placeDic[key];

        if (arr.count > row)
        {
//            XMUSCityModel *cityModel = model.city[row];
            
            return arr[row];
            
        }else
        {
            
            
            return @" ";
            
        }
//        if (model.city.count > row)
//        {
//            XMUSCityModel *cityModel = model.city[row];
//            
//            return cityModel.city;
//            
//        }else
//        {
//        
//        
//            return @" ";
//    
//        }
    }


}

- (void)didSelectRow:(NSInteger)row inComponent:(NSInteger)component inPicker:(UIPickerView *)picker
{
    if (component == 0)
    {
        
        //!< 更新第二行的数据
         
        [picker reloadComponent:1];//!< 重载市
        
        [picker selectRow:0 inComponent:1 animated:YES];
        
        NSInteger index = [picker selectedRowInComponent:1];
        
//        XMPlaceModel *model = self.dataSource[row]; //!< 州模型
//        
//        XMUSCityModel *cityModel = model.city[index];//!< 市模型
//        
//        self.place = [NSString stringWithFormat:@"%@  %@",cityModel.city,model.name];
        self.place = [NSString stringWithFormat:@"%@, %@",self.placeDic[self.sortArr[row]][index],self.sortArr[row]];
        
    }else
    {
        //!< 如果更新的是第二行，就保存当前的数据
        
//        NSInteger index = [picker selectedRowInComponent:0];
//        
//        XMPlaceModel *model = self.dataSource[index]; //!< 州模型
//        
//        
//        if (model.city.count > row)
//        {
//            XMUSCityModel *cityModel = model.city[row];//!< 市模型
//            
//            self.place = [NSString stringWithFormat:@"%@  %@",cityModel.city,model.name];
//        }else
//        {
//            XMLOG(@"---------越界了8989---------");
//        
//        }
        NSInteger index = [picker selectedRowInComponent:0];
        
        NSString *province = self.sortArr[index];
        
        NSArray *arr = self.placeDic[province];
        
        if (arr.count > row)
        {
            NSString *city = arr[row];
            
            self.place = [NSString stringWithFormat:@"%@, %@",city,province];
        }else
        {
            XMLOG(@"---------越界了8989---------");
            
        }
        
        
        
    }


}

- (void)pickerViewClickOK:(XMChoosePlaceView *)picker result:(NSString *)result
{
    
    //!< 判断网络
    if (!connecting)
    {
        [MBProgressHUD showError:JJLocalizedString(@"网络未连接", nil)];
        
        return;
    }
    
    if (self.place.length > 0)
    {
        //!< 保存数据
        [self saveUserInfoWithContent:self.place type:5];
        
        self.placeLabel.text = self.place;
    }

}

#pragma mark ------- method

- (void)didChoosePhotoStyle:(int)index
{
    [XMPresent dismiss];
    
    if (index == 3) {
        return;
    }
    
    if (index == 1)
    {
        //!< 打开相册
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
        {
            self.picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            
            [self presentViewController:_picker animated:YES completion:nil];
            
        }else
        {
            [MBProgressHUD showError:@"Not Support"];
        }
        
        
    }else 
    {
        //!< 打开相机
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:_picker animated:YES completion:nil];
            
        }else
        {
            [MBProgressHUD showError:@"Not Support"];
        }
    
    }
    
    
    
}

- (void)didChooseSex:(int)index{

    [XMPresent dismiss];
    
    //!< 判断网络
    if (!connecting)
    {
        [MBProgressHUD showError:JJLocalizedString(@"网络未连接", nil)];
        
        return;
    }
    
    switch (index) {
        case 1:
            
            //!< 0 代表男，1 代表女
            self.sexLabel.text = JJLocalizedString(@"男", nil);
            
            [self saveUserInfoWithContent:@"0" type:3];
            
            break;
            
        case 2:
            
             self.sexLabel.text = JJLocalizedString(@"女", nil);
             [self saveUserInfoWithContent:@"1" type:3];
            
            break;
            
        case 3:
            
             self.sexLabel.text = JJLocalizedString(@"其他", nil);
            
            //!< 取消
             [self saveUserInfoWithContent:@"3" type:3];
            
            break;
            
        default:
            break;
    }
    
    self.sex = self.sexLabel.text;

}

#pragma mark ------- UIImagePickerViewControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
 
    image =  [self compressImage:image toTargetWidth:200];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    //!< 开始上传
    [MBProgressHUD showMessage:JJLocalizedString(@"正在上传", nil)];
    
    NSString *urlStr = [mainAddress stringByAppendingString:@"uploaduserimage"];
    
    [self.session POST:urlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSData *imageData = UIImagePNGRepresentation(image);
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        formatter.dateFormat =@"yyyyMMddHHmmss";
        
        NSString *str = [formatter stringFromDate:[NSDate date]];
        
        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        
        //上传的参数(上传图片，以文件流的格式)
        [formData appendPartWithFileData:imageData
                                    name:@"file"
                                fileName:fileName
                                mimeType:@"image/png"];
        
        
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUD];
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        int statusCode = [dic[@"code"] intValue];
        
        if (statusCode == 1)
        {
            
            //!< 修改当前界面和上一界面的头像
             self.headerImageView.image = image;
            
             self.headerImage = image;
            
//             self.imageUrl = dic[@"data"];//!< 记录图片地址
            
            //!< 保存用户信息
            [self saveUserInfoWithContent:dic[@"data"] type:0];
            
            XMLOG(@"%@",self.imageUrl);
            
        }else
        {
            
            
             [MBProgressHUD showError:JJLocalizedString(@"上传失败", nil)];
            
        }
        
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUD];
        
        [MBProgressHUD showError:JJLocalizedString(@"上传失败", nil)];
        
        
    }];
    
    
 
}
//->>压缩图片
- (UIImage *)compressImage:(UIImage *)sourceImage toTargetWidth:(CGFloat)targetWidth {
    
    CGSize imageSize = sourceImage.size;
    
    CGFloat width = imageSize.width;
    
    CGFloat height = imageSize.height;
    
    CGFloat targetHeight = (targetWidth / width) * height;
    
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    
    [sourceImage drawInRect:CGRectMake(0, 0, targetWidth, targetHeight)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}



- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{

    [picker dismissViewControllerAnimated:YES completion:nil];

}


#pragma mark ------- XMInputViewDelegate

- (void)inputViewOKClick:(XMInputView*)view
{

    if (!connecting)
    {
        //!< 提示没有网络
        [MBProgressHUD showError:JJLocalizedString(@"请检查网络连接", nil)];
        
        return;
    }
    
    if(view.tag == 12)
    {
        //!< 用户名
        self.userNameLabel.text = view.result;
        
        [self saveUserInfoWithContent:view.result type:1];
    
    }else
    {
        //!< 心情
        self.signName = view.result;
        
        self.signNameLabel.text = view.result;
        
        [self saveUserInfoWithContent:view.result type:2];
    }
    

}


- (void)saveUserInfoWithContent:(NSString *)content type:(int)type
{
    
    NSString *urlStr = @"";
    
    XMUser *user = [XMUser user];
    
    switch (type)
    {
        case 0:
            //!< 保存头像
            
            urlStr = [mainAddress stringByAppendingFormat:@"setuserinfo&userid=%ld&userimage=%@",user.userid,content];
            
            break;
        case 1:
            //!< 保存用户名
            
            urlStr = [mainAddress stringByAppendingFormat:@"setuserinfo&userid=%ld&nickname=%@",user.userid,content];
            
            break;
        case 2:
            
            //!< 保存签名
            urlStr = [mainAddress stringByAppendingFormat:@"setuserinfo&userid=%ld&signname=%@",user.userid,content];
            
            break;
        case 3:
            
            //!< 保存性别
            urlStr = [mainAddress stringByAppendingFormat:@"setuserinfo&userid=%ld&sex=%@",user.userid,content];
            
            break;
        case 4:
            
            //!< 保存生日
            urlStr = [mainAddress stringByAppendingFormat:@"setuserinfo&userid=%ld&birthday=%@",user.userid,content];
            
            break;
            
        case 5:
            
            //!< 保存地区
            urlStr = [mainAddress stringByAppendingFormat:@"setuserinfo&userid=%ld&userarea=%@",user.userid,content];
            
            break;
            
            
        default:
            break;
    }
    
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    [self.session GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        
        NSString *result = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        XMLOG(@"---------保存成功-----%@----",result);
        
        if (type == 0)
        {
            //!< 保存头像成功，修改上个界面的头像
            self.callBack(_headerImage);
        }
        if(type == 1)
        {
            //!< 保存昵称成功，修改上移界面昵称
            self.callBack(content);
            
            //!< 修改单例名称
            XMDashPalManager *manager = [XMDashPalManager shareManager];
            
            manager.userNickName = content;
            
            XMUser *user = [XMUser user];
            
            user.vin = content;
            
            [XMUser save:user whenUserExist:YES];
        
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        XMLOG(@"---------%@ 保存失败---------",error);
                
        
    }];
    
}
    

@end
