//
//  RYGCommonDefine.h
//  shoumila
//
//  Created by jiaocx on 15/7/28.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#ifndef shoumila_RYGCommonDefine_h
#define shoumila_RYGCommonDefine_h

#define SeparatorLineHeight 0.5

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
#define RYG_TEXTSIZE(text, font) [text length] > 0 ? [text sizeWithAttributes:@{NSFontAttributeName:font}] : CGSizeZero;
#else
#define RYG_TEXTSIZE(text, font) [text length] > 0 ? [text sizeWithFont:font] : CGSizeZero;
#endif

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
#define RYG_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text boundingRectWithSize:maxSize options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:font} context:nil].size : CGSizeZero;
#else
#define RYG_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text sizeWithFont:font constrainedToSize:maxSize lineBreakMode:mode] : CGSizeZero;
#endif


#define RYGMessageTableViewCellCommentPhotoHeight 50
#define RYGMessageTableViewCellCommentTopMagin 7
#define RYGMessageTableViewCellCommentMagin 10


#endif
