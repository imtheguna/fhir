import 'package:fhir/r4.dart';

class GroupDetails {
  final R4ResourceType resourceType = R4ResourceType.Group;
  final Boolean? active;
  final Boolean? actual;
  final List<GroupCharacteristic>? characteristic;
  final CodeableConcept? code;
  final List<Resource>? contained;
  final Id? id;
  final List<Identifier>? identifier;
  final FhirUri? implicitRules;
  final Code? language;
  final List<GroupMember>? member;
  final Meta? meta;
  final String name;
  final Reference? managingEntity;
  final UnsignedInt? quantity;
  final GroupType? type;

  GroupDetails({
    required this.name,
    this.active,
    this.actual,
    this.characteristic,
    this.code,
    this.contained,
    this.id,
    this.identifier,
    this.implicitRules,
    this.language,
    this.member,
    this.meta,
    this.quantity,
    this.managingEntity,
    this.type,
  });
}
