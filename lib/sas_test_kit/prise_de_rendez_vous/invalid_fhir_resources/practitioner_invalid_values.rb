require 'securerandom'

module InvalidPractitionerValues
    PROFILE_URL = "https://interop.esante.gouv.fr/ig/fhir/sas/StructureDefinition/FrPractitionerRegul"

    EMPTY_NAME = FHIR::Practitioner.new(
            resourceType: "Practitioner",
            id: "empty-name",
            meta: {
            source: "urn:oid:1.2.250.1.213.3.6",
            profile: [PROFILE_URL]
            },
            identifier: [
            {
                type: {
                coding: [
                    {
                    system: "http://interopsante.org/fhir/CodeSystem/fr-v2-0203",
                    code: "IDNPS"
                    }
                ]
                },
                system: "urn:oid:1.2.250.1.213.3.6",
                value: "#{SecureRandom.uuid}"
            }
            ],
            active: true,
            name: [
            {
                family: "",
                given: ["Claire"]
            }
            ],
            telecom: [
            {
                system: "email",
                value: "#{SecureRandom.uuid} + claire.@example.com"
            }
            ]
        )

    EMPTY_MAIL = FHIR::Practitioner.new(
            resourceType: "Practitioner",
            id: "empty-mail",
            meta: {
            source: "urn:oid:1.2.250.1.213.3.6",
            profile: [PROFILE_URL]
            },
            identifier: [
            {
                type: {
                coding: [
                    {
                    system: "http://interopsante.org/fhir/CodeSystem/fr-v2-0203",
                    code: "IDNPS"
                    }
                ]
                },
                system: "urn:oid:1.2.250.1.213.3.6",
                value: "#{SecureRandom.uuid}"
            }
            ],
            active: true,
            name: [
            {
                family: "Marie",
                given: ["Claire"]
            }
            ],
            telecom: [
            {
                system: "email",
                value: ""
            }
            ]
        )
    
    WRONG_TELECOM_SYSTEM = FHIR::Practitioner.new(
            resourceType: "Practitioner",
            id: "wrong-telecom-system",
            meta: {
            source: "urn:oid:1.2.250.1.213.3.6",
            profile: [PROFILE_URL]
            },
            identifier: [
            {
                type: {
                coding: [
                    {
                    system: "http://interopsante.org/fhir/CodeSystem/fr-v2-0203",
                    code: "IDNPS"
                    }
                ]
                },
                system: "urn:oid:1.2.250.1.71.4.2.1",
                value: "1234567890"
            }
            ],
            active: true,
            name: [
            {
                family: "Marie",
                given: ["Claire"]
            }
            ],
            telecom: [
            {
                system: "phone",
                value: "#{SecureRandom.uuid} + claire.Marie@example.com"
            }
            ]
        )
    
    WRONG_CODE_FOR_IDNPS_SYSTEM = FHIR::Practitioner.new(
            resourceType: "Practitioner",
            id: "invalid-wrong-code-for-idnps-system",
            meta: {
            source: "urn:oid:1.2.250.1.213.3.6",
            profile: [PROFILE_URL]
            },
            identifier: [
            {
                type: {
                coding: [
                    {
                    system: "http://interopsante.org/fhir/CodeSystem/fr-v2-0203",
                    code: "INTRN"
                    }
                ]
                },
                system: "urn:oid:1.2.250.1.71.4.2.1",
                value: "1223432432"
            }
            ],
            active: true,
            name: [
            {
                family: "Dubois",
                given: ["Claire"]
            }
            ],
            telecom: [
            {
                system: "email",
                value: "#{SecureRandom.uuid} + claire.dubois@example.com"
            }
            ]
        )

    WRONG_CODE_FOR_INTRN_SYSTEM = FHIR::Practitioner.new(
            resourceType: "Practitioner",
            id: "invalid-wrong-code-for-intrn-system",
            meta: {
            source: "urn:oid:1.2.250.1.213.3.6",
            profile: [PROFILE_URL]
            },
            identifier: [
            {
                type: {
                coding: [
                    {
                    system: "http://interopsante.org/fhir/CodeSystem/fr-v2-0203",
                    code: "IDNPS"
                    }
                ]
                },
                system: "urn:oid:1.2.250.1.213.3.6",
                value: "#{SecureRandom.uuid}"
            }
            ],
            active: true,
            name: [
            {
                family: "Dubois",
                given: ["Claire"]
            }
            ],
            telecom: [
            {
                system: "email",
                value: "#{SecureRandom.uuid} + claire.dubois@example.com"
            }
            ]
        )
end 
    