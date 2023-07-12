library hight_text_widget;

import 'package:flutter/material.dart';

class HighlightTextWidget extends StatefulWidget {

  //正常文本
  final TextStyle? normalStyle;
  //高亮文本
  final TextStyle? highlightStyle;
  //全部的字符
  final String text;
  // 高亮的字符串
  final String lighlight;

  const HighlightTextWidget({
    Key? key,
    this.normalStyle,
    this.highlightStyle,
    required this.text,
    required this.lighlight,
  }) : super(key: key);

  @override
  _HighlightTextWidgetState createState() => _HighlightTextWidgetState();
}

class _HighlightTextWidgetState extends State<HighlightTextWidget> {

  late String _text;
  late TextStyle _normalStyle;
  late TextStyle _highlightStyle;


  @override
  void initState() {
    //全部字符
    _text = widget.text;

    //正常文本
    _normalStyle = widget.normalStyle ?? const TextStyle(
      fontSize: 16,
      color: Colors.black,
    );

    //高亮文本
    _highlightStyle = widget.highlightStyle ?? const TextStyle(
      fontSize: 16,
      color: Colors.blue,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _lightTextWidget(widget.lighlight);
  }


  _matchLighlightSpan() {

    // RegExp exp = RegExp(r"text:(.+?(?=}))");
    // final matches = exp.allMatches(myString).map((m) => m.group(0)).toString();
    // print("allMatches : $matches");

  }

  /// 需要高亮显示的内容
  Widget _lightTextWidget(String lightText) {
    List<TextSpan> spans = [];
    int start = 0; // 当前要截取字符串的起始位置
    int end; // end 表示要高亮显示的文本出现在当前字符串中的索引

    // 如果有符合的高亮文字
    while ((end = _text.indexOf(lightText, start)) != -1) {
      // 第一步：添加正常显示的文本
      spans.add(TextSpan(text: _text.substring(start, end), style: _normalStyle));
      // 第二步：添加高亮显示的文本
      spans.add(TextSpan(text: lightText, style:_highlightStyle));
      // 设置下一段要截取的开始位置
      start = end + lightText.length;
    }
    // 下面这行代码的意思是
    // 如果没有要高亮显示的，则start=0，也就是返回了传进来的text
    // 如果有要高亮显示的，则start=最后一个高亮显示文本的索引，然后截取到text的末尾
    spans.add(
      TextSpan(text: _text.substring(start, _text.length), style: _normalStyle),
    );

    return RichText(
      text: TextSpan(children: spans),
    );
  }
}

class HighlightTextUtil {
  /// 需要高亮显示的内容仅限单个目标匹配
  static List<TextSpan> lightTextSpans({
    required String text,
    required String lightText,
    required TextStyle highlightStyle,
    TextStyle? normalStyle,
  }) {
    List<TextSpan> spans = [];
    int start = 0; // 当前要截取字符串的起始位置
    int end; // end 表示要高亮显示的文本出现在当前字符串中的索引

    // 如果有符合的高亮文字
    while ((end = text.indexOf(lightText, start)) != -1) {
      // 第一步：添加正常显示的文本
      spans.add(TextSpan(text: text.substring(start, end), style: normalStyle));
      // 第二步：添加高亮显示的文本
      spans.add(TextSpan(text: lightText, style: highlightStyle));
      // 设置下一段要截取的开始位置
      start = end + lightText.length;
    }
    // 下面这行代码的意思是
    // 如果没有要高亮显示的，则start=0，也就是返回了传进来的text
    // 如果有要高亮显示的，则start=最后一个高亮显示文本的索引，然后截取到text的末尾
    spans.add(
      TextSpan(text: text.substring(start, text.length), style: normalStyle),
    );

    return spans;
  }

  /// 需要高亮显示的内容支持多个目标匹配
  static List<TextSpan> lightTextEntitysSpans({
    required String text,
    required List<FontColorTextEntity> lightEntitys, // 匹配的目标数组
    TextStyle? normalStyle, // 默认样式
  }) {

    List<TextSpan> spans = [];
    int start = 0; // 当前要截取字符串的起始位置
    int end; // end 表示要高亮显示的文本出现在当前字符串中的索引

    var lightTexts = lightEntitys.map((e) => e.lightText).toList();

    var matchTexts = matchesStringPositions(text, lightTexts);

    // if (kDebugMode) {
    //   print("lightTextEntitysSpans text: $text, lightTexts: $lightTexts, matchTexts: $matchTexts");
    // }

    for (var e in matchTexts) {

      var index = lightTexts.indexOf(e.input);
      var entity = lightEntitys[index];
      var fontWeight = entity.fontWeight;
      fontWeight = fontWeight >= FontWeight.values.length ? 0 : fontWeight;

      end = e.start;

      // 第一步：添加正常显示的文本
      spans.add(TextSpan(text: text.substring(start, end), style: normalStyle));
      // 第二步：添加高亮显示的文本
      spans.add(
          TextSpan(
            text: e.input,
            style: TextStyle(
              fontSize: entity.fontSize,
              fontWeight: FontWeight.values[fontWeight],
              color: entity.color,
            ),)
      );
      // 设置下一段要截取的开始位置
      start = e.end;

    }
    // 下面这行代码的意思是
    // 如果没有要高亮显示的，则start=0，也就是返回了传进来的text
    // 如果有要高亮显示的，则start=最后一个高亮显示文本的索引，然后截取到text的末尾
    spans.add(
      TextSpan(text: text.substring(start, text.length), style: normalStyle),
    );

    return spans;
  }

  /// 匹配出所有符合字符串的下标索引
  static List<MatchText> matchesStringPositions(String text, List<String> targets) {
    return targets.map((e) {
      var start = text.indexOf(e);
      var end = start + e.length;
      return MatchText(start, end, e);
    }).toList();
  }

}

class FontColorTextEntity {
  String lightText;
  double fontSize; // 字体大小
  int fontWeight; // 字重 FontWeight的index
  Color color;

  FontColorTextEntity(
      this.lightText, this.fontSize, this.fontWeight, this.color);
}

class MatchText {
  int start;
  int end;
  String input;

  MatchText(this.start, this.end, this.input);

  @override
  String toString() {
    return "toString:'input:$input, start:$start, end:$end'";
  }
}
