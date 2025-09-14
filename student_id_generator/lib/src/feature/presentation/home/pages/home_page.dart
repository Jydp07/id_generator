import 'package:flutter/material.dart';
import 'package:student_id_generator/src/core/constants/app_strings.dart';
import 'package:student_id_generator/src/core/extensions/size_extension.dart';
import 'package:student_id_generator/src/feature/presentation/home/widgets/arrange_columns_panel.dart';
import 'package:student_id_generator/src/feature/presentation/home/widgets/left_side_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.appName), centerTitle: false),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 1200;
          final isMedium = constraints.maxWidth >= 768;

          return SingleChildScrollView(
            padding: EdgeInsets.all(isMedium ? 16 : 8),
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 1400),
                child: isWide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 1, child: const LeftSidebar()),
                          16.horizontalBox,
                          const Expanded(flex: 3, child: ArrangeColumnsPanel()),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const LeftSidebar(),
                          16.verticalBox,
                          const ArrangeColumnsPanel(),
                        ],
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}
