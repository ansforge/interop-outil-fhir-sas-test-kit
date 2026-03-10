require 'securerandom'

module InvalidPractitionerField
    PROFILE_URL = "https://interop.esante.gouv.fr/ig/fhir/sas/StructureDefinition/FrPractitionerRegul"
    
    NO_IDENTIFIER = FHIR::Practitioner.new(
            resourceType: "Practitioner",
            id: "invalid-no-identifier",
            meta: {
            source: "urn:oid:1.2.250.1.213.3.6",
            profile: [PROFILE_URL]
            },
            # identifier MANQUANT
            active: true,
            name: [
            {
                family: "Dupont",
                given: ["Jean"]
            }
            ],
            telecom: [
            {
                system: "email",
                value: "#{SecureRandom.uuid} + jean.dupont@example.com"
            }
            ]
        )
    
    
    NO_NAME = FHIR::Practitioner.new(
            resourceType: "Practitioner",
            id: "invalid-no-name",
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
                value: "#{SecureRandom.uuid}"
            }
            ],
            active: true,
            # name MANQUANT
            telecom: [
            {
                system: "email",
                value: "#{SecureRandom.uuid} + practitioner@example.com"
            }
            ]
        )
    
    
    NO_TELECOM = FHIR::Practitioner.new(
            resourceType: "Practitioner",
            id: "invalid-no-telecom",
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
                value: "#{SecureRandom.uuid}"
            }
            ],
            active: true,
            name: [
            {
                family: "Martin",
                given: ["Alice"]
            }
            ]
            # telecom MANQUANT
        )
    
    
    NO_ACTIVE = FHIR::Practitioner.new(
            resourceType: "Practitioner",
            id: "invalid-no-active",
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
                value: "#{SecureRandom.uuid}"
            }
            ],
            # active MANQUANT
            name: [
            {
                family: "Leroy",
                given: ["Paul"]
            }
            ],
            telecom: [
            {
                system: "email",
                value: "#{SecureRandom.uuid} + paul.leroy@example.com"
            }
            ]
        )
end

