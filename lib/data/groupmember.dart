import 'package:fhir/r4.dart';

class GroupMemberDetails {
  final Reference entity;
  final String? id;
  final Boolean? inactive;
  final List<FhirExtension>? modifierExtension;
  final Period? period;
  GroupMemberDetails(
      {required this.entity,
      this.id,
      this.inactive,
      this.modifierExtension,
      this.period});
}
