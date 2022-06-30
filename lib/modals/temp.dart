import 'package:fhir/r4.dart';
import 'package:fhir_demo/data/patient_details.dart';
import 'package:fhir_demo/data/appointment_details.dart';
import 'package:fhir_demo/data/persondetails.dart';
import 'package:fhir_demo/modals/constants.dart';
import 'package:flutter/material.dart';

class TempData {
  //957,959,960
  static PatientDetails patientDetails = PatientDetails(
      id: Id('957'),
      photo: [
        Attachment(
            contentType: Code("url"),
            url: FhirUrl("https://randomuser.me/api/portraits/men/79.jpg"))
      ],
      deceasedBoolean: Boolean(false),
      identifier: [
        Identifier(
          use: IdentifierUse.usual,
          type: CodeableConcept(
            coding: [
              Coding(
                code: Code("MR"),
                system:
                    FhirUri('http://terminology.hl7.org/CodeSystem/v2-0203'),
              ),
            ],
          ),
        ),
      ],
      active: Boolean(true),
      birthDate: Date.fromDateTime(DateTime(2000, 10, 9)),
      contact: [
        PatientContact(
            relationship: [
              CodeableConcept(coding: [
                Coding(
                    code: Code("939"),
                    system: FhirUri(
                        'http://ec2-3-138-255-176.us-east-2.compute.amazonaws.com:8080/hapi-fhir-jpaserver/fhir/Person/939'))
              ])
            ],
            gender: PatientContactGender.male,
            name: HumanName(
              family: 'K',
              given: ['Arun'],
            ))
      ],
      managingOrganization: Reference(display: 'BCBSMN'),
      gender: PatientGender.male,
      telecom: [
        ContactPoint(system: ContactPointSystem.email, value: 'Hari@gmail.com'),
        ContactPoint(system: ContactPointSystem.phone, value: '7858596945'),
      ],
      name: [
        HumanName(
          family: 'N',
          given: ['Hari'],
        )
      ],
      address: [
        Address(
          city: 'CBE',
          country: 'INDIA',
          state: 'TN',
          postalCode: '630501',
        ),
      ]);

  static AppointmentDetails appointmentDetails = AppointmentDetails(
    appointmentType: CodeableConcept(
      coding: [
        Coding(
          code: Code("FOLLOWUP"),
          display: 'A follow up visit from a previous appointment',
        )
      ],
    ),

    status: AppointmentStatus.booked,
    serviceType: [
      CodeableConcept(
        coding: [
          Coding(
            code: Code("52"),
            display: "General Discussion",
          )
        ],
      )
    ],
    start: Instant(DateTime.parse('2022-09-07T10:29:12+02:00')),
    end: Instant(DateTime.parse('2022-09-07T11:29:12+02:00')),
    created: FhirDateTime(DateTime.now()),
    id: Id('1000'),
    //slot: [Reference(display: "")],
    participant: [
      AppointmentParticipant(
          actor: Reference(
            display: 'Surendar',
            reference: Constants.fhirapilink + 'Patient/904',
          ),
          status: AppointmentParticipantStatus.accepted,
          required_: AppointmentParticipantRequired.required_,
          type: [
            CodeableConcept(
              coding: [
                Coding(
                  code: Code("ATND"),
                  system: FhirUri(
                      "http://terminology.hl7.org/CodeSystem/v3-ParticipationType"),
                )
              ],
            ),
          ]),
    ],

    // reasonCode: [
    //   CodeableConcept(
    //     id: '1000',
    //     coding: [Coding(code: Code("0"))],
    //     text: '',
    //   ),
    // ],
    serviceCategory: [
      CodeableConcept(
        coding: [
          Coding(
            code: Code("gp"),
            display: "General Discussion",
          )
        ],
      ),
    ],
    specialty: [
      CodeableConcept(
        coding: [
          Coding(
            system: FhirUri('http://snomed.info/sct'),
            code: Code("394814009"),
            display: "General Discussion",
          )
        ],
      ),
    ],
  );

  static PersonDetails personDetails = PersonDetails(
    id: Id("939"),
    photo: Attachment(
        contentType: Code("url"),
        url: FhirUrl("https://randomuser.me/api/portraits/men/47.jpg")),
    name: [
      HumanName(
        family: 'A',
        given: ['Arun'],
      )
    ],
    address: [
      Address(
        city: "CBE",
        country: "IN",
        district: "CBE",
        postalCode: "630501",
        type: AddressType.both,
        state: "TN",
      )
    ],
    birthDate: Date.fromDateTime(DateTime(2000, 10, 9)),
    active: Boolean(true),
    gender: PersonGender.male,
    managingOrganization: Reference(
      display: "BCBSMN",
    ),
    telecom: [
      ContactPoint(
        system: ContactPointSystem.email,
        value: "arun2000@gmail.com",
      ),
      ContactPoint(
        system: ContactPointSystem.phone,
        value: "22522252555",
      ),
    ],
  );
}
// "Care & Cure Hospital"
// (string)
// 1
// "Flowerence"
// 2
// "Health Object Hospital"
// 3
// "Newlife hospital"