import 'package:fhir/r4.dart';

class PersonDetails {
  final R4ResourceType resourceType = R4ResourceType.Person;
  final Id id;
  final List<HumanName> name;
  final Date? birthDate;
  final PersonGender? gender;
  final Attachment? photo;
  final List<ContactPoint>? telecom;
  final Boolean? active;
  final List<Address>? address;
  final List<Identifier>? identifier;
  final Code? language;
  final Narrative? text;
  final List<PersonLink>? link;
  final Meta? meta;
  final FhirUri? implicitRules;
  final Reference? managingOrganization;
  final List<FhirExtension>? modifierExtension;
  PersonDetails(
      {required this.id,
      required this.name,
      this.birthDate,
      this.telecom,
      this.gender,
      this.active,
      this.address,
      this.photo,
      this.identifier,
      this.language,
      this.text,
      this.link,
      this.implicitRules,
      this.modifierExtension,
      this.meta,
      this.managingOrganization});
}
