import 'package:fhir/r4.dart';

class PatientDetails {
  final R4ResourceType resourceType = R4ResourceType.Patient;
  final List<Address>? address;
  final Id id;
  final Date? birthDate;
  final List<HumanName> name;
  final List<ContactPoint>? telecom;
  final Boolean? active;
  final List<PatientContact>? contact;
  final PatientGender? gender;
  final List<Attachment>? photo;
  final List<PatientCommunication>? communication;
  final Code? language;
  final CodeableConcept? maritalStatus;
  final List<PatientLink>? link;
  final Meta? meta;
  final List<Identifier>? identifier;
  final List<Reference>? generalPractitioner;
  final Reference? managingOrganization;
  final Boolean? deceasedBoolean;
  final FhirDateTime? deceasedDateTime;

  PatientDetails(
      {required this.name,
      required this.id,
      this.telecom,
      this.deceasedBoolean,
      this.deceasedDateTime,
      this.birthDate,
      this.active,
      this.contact,
      this.gender,
      this.address,
      this.photo,
      this.communication,
      this.language,
      this.link,
      this.managingOrganization,
      this.generalPractitioner,
      this.meta,
      this.identifier,
      this.maritalStatus});
}
