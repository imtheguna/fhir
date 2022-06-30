import 'package:fhir/r4.dart';

class AppointmentDetails {
  // Appointment appointment = Appointment( d);
  final R4ResourceType resourceType = R4ResourceType.Appointment;
  final List<AppointmentParticipant> participant;
  final Id id;
  final AppointmentStatus status;
  final CodeableConcept? cancelationReason;
  final List<CodeableConcept>? serviceCategory;
  final List<CodeableConcept>? serviceType;
  final List<CodeableConcept> specialty;
  final CodeableConcept appointmentType;
  final List<CodeableConcept>? reasonCode;
  final Instant start;
  final List<Reference>? slot;
  final FhirDateTime? created;
  final Instant? end;
  final String? description;
  final PositiveInt? minutesDuration;
  final UnsignedInt? priority;
  final List<Reference>? supportingInformation;
  final String? patientInstruction;
  final List<Identifier>? identifier;
  final Meta? meta;
  final Code? language;
  final List<Reference>? basedOn;
  final String? comment;
  final List<Reference>? reasonReference;
  final List<Period>? requestedPeriod;
  AppointmentDetails(
      {required this.participant,
      required this.id,
      this.end,
      required this.status,
      this.meta,
      this.serviceCategory,
      this.serviceType,
      required this.specialty,
      required this.appointmentType,
      required this.start,
      required this.created,
      this.language,
      this.slot,
      this.identifier,
      this.reasonCode,
      this.cancelationReason,
      this.description,
      this.minutesDuration,
      this.priority,
      this.requestedPeriod,
      this.basedOn,
      this.comment,
      this.reasonReference,
      this.supportingInformation,
      this.patientInstruction});
}
