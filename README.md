
Sets the highlight state on the target text.
对目标文本设置高亮状态

## Features

What needs to be highlighted is limited to a single target match.
需要高亮显示的内容仅限单个目标匹配
Content that needs to be highlighted supports multiple target matches.
需要高亮显示的内容支持多个目标匹配

## Getting started

```dart
import 'package:hight_text_widget/hight_text_widget.dart';
```

## Usage


```dart
var fonts = map["content"]["attributes"]["font"];
var fontEntitys = (fonts as List).map((v) {
  var e = MessageFontColorEntity().fromJson(v);
  return FontColorTextEntity(
      e.target ?? "", ScreenUtil().setSp(e.fontSize ?? 24), e.fontWeight!, HexColor(e.color));
}).toList();

var spans = HighlightTextUtil.lightTextEntitysSpans(
text: widget.data.text ?? '',
lightEntitys: fontEntitys,
);
```

## Additional information

Hava fun
