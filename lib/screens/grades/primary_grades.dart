import 'package:flutter/material.dart';
import 'package:cintli_montessori/screens/grades/group_report_cards_screen.dart';

/// Adapta un grupo de primaria al flujo común de boletas.
class PrimaryGradesScreen extends StatelessWidget {
  const PrimaryGradesScreen({
    super.key,
    required this.groupId,
    required this.groupName,
  });

  final String groupId;
  final String groupName;

  @override
  Widget build(BuildContext context) {
    return GroupReportCardsScreen(groupId: groupId, groupName: groupName);
  }
}
