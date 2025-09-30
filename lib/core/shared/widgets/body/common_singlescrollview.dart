import 'package:flutter/material.dart';

import 'package:video_calling/core/shared/widgets/body/common_column.dart';

class CommonSingleScrollview extends CommonColumn {
  const CommonSingleScrollview({
    super.key,
    required super.children,
    super.mainAxisAlignment,
    super.crossAxisAlignment,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: super.build(context));
  }
}
