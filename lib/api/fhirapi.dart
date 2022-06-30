import 'dart:developer';

import 'package:fhir/r4.dart';
import 'package:fhir_at_rest/r4.dart';
import 'package:fhir_demo/data/appointment_details.dart';
import 'package:fhir_demo/data/groupdetails.dart';
import 'package:fhir_demo/data/groupmember.dart';
import 'package:fhir_demo/data/patient_details.dart';
import 'package:fhir_demo/data/persondetails.dart';
import 'package:fhir_demo/modals/constants.dart';
import 'package:flutter/foundation.dart';

class FhirApi {
  static Future<Patient> hapiReadPatient(Id id) async {
    var request = FhirRequest.read(
      base: Uri.parse(Constants.fhirapilink),
      type: R4ResourceType.Patient,
      id: id,
    );
    var response = await request.request(
        headers: {'content-type': 'application/fhir+json;charset=UTF-8'});

    Patient patient = (response as Patient);
    return patient;
  }

  static Future hapiReadAppointment(Id id) async {
    var request = FhirRequest.read(
      base: Uri.parse(Constants.fhirapilink),
      type: R4ResourceType.Appointment,
      id: id,
    );
    var response = await request.request(
        headers: {'content-type': 'application/fhir+json;charset=UTF-8'});

    if (response?.resourceType == R4ResourceType.Appointment) {
      Appointment appointment = (response as Appointment);
      return appointment;
    }

    return response;
  }

  static Future hapiPatientCreate(PatientDetails patientDetails) async {
    var newPatient = Patient(
        photo: patientDetails.photo,
        communication: patientDetails.communication,
        language: patientDetails.language,
        maritalStatus: patientDetails.maritalStatus,
        resourceType: patientDetails.resourceType,
        address: patientDetails.address,
        name: patientDetails.name,
        birthDate: patientDetails.birthDate,
        active: patientDetails.active,
        gender: patientDetails.gender,
        telecom: patientDetails.telecom,
        contact: patientDetails.contact,
        id: patientDetails.id,
        meta: patientDetails.meta,
        identifier: patientDetails.identifier,
        generalPractitioner: patientDetails.generalPractitioner,
        link: patientDetails.link,
        managingOrganization: patientDetails.managingOrganization,
        deceasedBoolean: patientDetails.deceasedBoolean,
        deceasedDateTime: patientDetails.deceasedDateTime);
    var newRequest = FhirRequest.create(
      base: Uri.parse(Constants.fhirapilink),
      resource: newPatient,
    );
    var response = await newRequest.request(
        headers: {'content-type': 'application/fhir+json;charset=UTF-8'});
    if (response?.resourceType == R4ResourceType.Patient) {
      Patient patient = (response as Patient);
      print(response);
      return response;
    } else {
      print(response?.toJson());
    }
    print(response);
    return response;
  }

  static Future hapiAppointmentCreate(
      AppointmentDetails appointmentDetails) async {
    var newPatient = Appointment(
      participant: appointmentDetails.participant,
      id: appointmentDetails.id,
      status: appointmentDetails.status,
      serviceCategory: appointmentDetails.serviceCategory,
      serviceType: appointmentDetails.serviceType,
      specialty: appointmentDetails.specialty,
      appointmentType: appointmentDetails.appointmentType,
      start: appointmentDetails.start,
      created: appointmentDetails.created,
      end: appointmentDetails.end,
      cancelationReason: appointmentDetails.cancelationReason,
      description: appointmentDetails.description,
      priority: appointmentDetails.priority,
      slot: appointmentDetails.slot,
      identifier: appointmentDetails.identifier,
      reasonCode: appointmentDetails.reasonCode,
      minutesDuration: appointmentDetails.minutesDuration,
      patientInstruction: appointmentDetails.patientInstruction,
      supportingInformation: appointmentDetails.supportingInformation,
      meta: appointmentDetails.meta,
      language: appointmentDetails.language,
      resourceType: appointmentDetails.resourceType,
      basedOn: appointmentDetails.basedOn,
      comment: appointmentDetails.comment,
      reasonReference: appointmentDetails.reasonReference,
      requestedPeriod: appointmentDetails.requestedPeriod,
    );
    var newRequest = FhirRequest.create(
      base: Uri.parse(Constants.fhirapilink),
      resource: newPatient,
    );
    var response = await newRequest.request(
        headers: {'content-type': 'application/fhir+json;charset=UTF-8'});
    if (response?.resourceType == R4ResourceType.Appointment) {
      print(response);
    } else {
      debugPrint(response.toString());
    }
    return response;
  }

  static Future hapiPersonCreate({required PersonDetails personDetails}) async {
    var newPerson = Person(
      resourceType: personDetails.resourceType,
      active: personDetails.active,
      address: personDetails.address,
      birthDate: personDetails.birthDate,
      gender: personDetails.gender,
      telecom: personDetails.telecom,
      photo: personDetails.photo,
      identifier: personDetails.identifier,
      language: personDetails.language,
      text: personDetails.text,
      link: personDetails.link,
      name: personDetails.name,
      id: personDetails.id,
      meta: personDetails.meta,
      implicitRules: personDetails.implicitRules,
      managingOrganization: personDetails.managingOrganization,
      modifierExtension: personDetails.modifierExtension,
    );
    var newRequest = FhirRequest.create(
      base: Uri.parse(Constants.fhirapilink),
      resource: newPerson,
    );
    var response = await newRequest.request(
        headers: {'content-type': 'application/fhir+json;charset=UTF-8'});
    if (response?.resourceType == R4ResourceType.Person) {
      print(response);
    } else {
      print(response?.toJson());
    }
    return response;
  }

  static Future<bool> hapiDeleteRes(
      R4ResourceType r4ResourceType, String id) async {
    try {
      final request = FhirRequest.delete(
        base: Uri.parse(Constants.fhirapilink),
        type: r4ResourceType,
        id: Id(id),
      );
      var response = await request.request(
          headers: {'content-type': 'application/fhir+json;charset=UTF-8'});
      print(response);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future hapiGroupCreate(GroupDetails groupDetails) async {
    var newGroup = Group(
        active: groupDetails.active,
        actual: groupDetails.actual,
        characteristic: groupDetails.characteristic,
        code: groupDetails.code,
        id: groupDetails.id,
        identifier: groupDetails.identifier,
        implicitRules: groupDetails.implicitRules,
        managingEntity: groupDetails.managingEntity,
        language: groupDetails.language,
        member: groupDetails.member,
        meta: groupDetails.meta,
        quantity: groupDetails.quantity,
        name: groupDetails.name,
        resourceType: groupDetails.resourceType,
        type: groupDetails.type);
    var newRequest = FhirRequest.create(
      base: Uri.parse(Constants.fhirapilink),
      resource: newGroup,
    );
    var response = await newRequest.request(
        headers: {'content-type': 'application/fhir+json;charset=UTF-8'});
    if (response?.resourceType == R4ResourceType.Group) {
      print(response);
    } else {
      print(response?.toJson());
    }
    return response;
  }

  static GroupMember hapiGroupMemberCreate(
      GroupMemberDetails groupMemberDetails) {
    var newGroupMember = GroupMember(
      entity: groupMemberDetails.entity,
      id: groupMemberDetails.id,
      inactive: groupMemberDetails.inactive,
      modifierExtension: groupMemberDetails.modifierExtension,
      period: groupMemberDetails.period,
    );

    return newGroupMember;
  }
}