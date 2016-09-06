//
//  pageSeparationTools.m
//  阅读器
//
//  Created by xiong on 16/8/31.
//  Copyright © 2016年 xiong. All rights reserved.
//

#import "pageSeparationTools.h"


@implementation pageSeparationTools{

    NSString *tempSTR;
}

static pageSeparationTools *shareInstance = nil;
//static NSStringEncoding encUTF8;
+(instancetype)sharepageSeparationTools{

    @synchronized (self) {
        if (!shareInstance) {
            shareInstance = [[[self class] alloc] init];

        }
    }
    return shareInstance;
}
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    @synchronized (self) {
        if (!shareInstance) {
            shareInstance = [super allocWithZone:zone];
            return shareInstance;
        }
    }
    return nil;
}
-(NSMutableArray *)upBIGFont{
    self.fontsize++;

    return [self pageSeparationWithSting:tempSTR];

}
-(NSMutableArray *)upSamilFont{
    self.fontsize--;
   return [self pageSeparationWithSting:tempSTR];
}
-(NSDictionary *)lineSpace:(CGFloat)lineSpace fontSize:(CGFloat)fontsize{

    if (self.fontsize == 0) {
        self.fontsize = 15;
    }
    if (self.lineSpace == 0) {
        self.lineSpace = 15;
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineHeightMultiple  = 1.f;                    // 可变行高,乘因数
    paragraphStyle.lineSpacing         = _lineSpace;                    // 行间距
    paragraphStyle.minimumLineHeight   = 10.f;                   // 最小行高
    paragraphStyle.maximumLineHeight   = 20.f;                   // 最大行高
    paragraphStyle.paragraphSpacing    = 0.f;                   // 段间距
    paragraphStyle.alignment           = NSTextAlignmentLeft;    // 对齐方式
    paragraphStyle.firstLineHeadIndent = 30.f;                   // 段落首文字离边缘间距
    paragraphStyle.headIndent          = 0.f;                    // 段落除了第一行的其他文字离边缘间距
    paragraphStyle.tailIndent          = 0.f;                    // ???????
    return  @{NSFontAttributeName:[UIFont systemFontOfSize:_fontsize],NSParagraphStyleAttributeName : paragraphStyle};

}
-(NSMutableArray *)pageSeparationWithSting:(NSString *)ChapterContent{
    tempSTR = ChapterContent;
//    CGFloat Uwidth  = [UIScreen mainScreen].bounds.size.width;
//    CGFloat Uheight = [UIScreen mainScreen].bounds.size.height;
    //    创建属性文字字典
    NSDictionary *attriDic = [self lineSpace:_lineSpace fontSize:_fontsize];
    NSMutableArray *tempArray = [NSMutableArray new];
    //    创建属性文字
    NSMutableAttributedString *orginAttStr =[[NSMutableAttributedString alloc] initWithString:ChapterContent attributes:attriDic];
    //    创建容器
    NSTextStorage *textStrong = [[NSTextStorage alloc] initWithAttributedString:orginAttStr];
    NSLayoutManager *layoutManger = [NSLayoutManager new];
    [textStrong addLayoutManager:layoutManger];
    while (YES) {
        NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:CGSizeMake(screenW -90, screenH - 100)];
        [layoutManger addTextContainer:textContainer];
        NSRange range = [layoutManger glyphRangeForTextContainer:textContainer];
        if (range.length <= 0) {
            break;
        }
        NSString *pageStr = [ChapterContent substringWithRange:range];
        NSMutableAttributedString *pageAtt = [[NSMutableAttributedString alloc] initWithString:pageStr attributes:attriDic];

        [tempArray addObject:pageAtt];
    }
    self.pageArray = tempArray;
    return tempArray;
}
@end
