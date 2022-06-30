import 'package:fhir/r4.dart';
import 'package:fhir_demo/data/patient_details.dart';

class ConvertPatientDetails {
  final Patient patient;
  ConvertPatientDetails({required this.patient});

  PatientDetails convertFromJson() {
    return PatientDetails(
        name: patient.name!,
        active: patient.active!,
        address: patient.address!,
        birthDate: patient.birthDate!,
        contact: patient.contact!,
        gender: patient.gender!,
        id: patient.id!,
        telecom: patient.telecom!);
  }
}
