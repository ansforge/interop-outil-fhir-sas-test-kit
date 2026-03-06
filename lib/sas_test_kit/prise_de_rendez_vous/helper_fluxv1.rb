module MyTestKit
    module HelperFLuxv1
        def self.build_regulateur_body(regulator_id, regulator_mail, resource_id, regulator_first_name, regulator_last_name, sys, active = true)
            code = nil
            if sys == 'urn:oid:1.2.250.1.71.4.2.1'
                code = 'IDNPS'
            else
                code = 'INTRN'
            end

            FHIR::Practitioner.new(
                resourceType: "Practitioner",
                id: "#{resource_id}",
                meta: {
                    source: "urn:oid:1.2.250.1.213.3.6",
                    profile: [
                        "https://interop.esante.gouv.fr/ig/fhir/sas/StructureDefinition/FrPractitionerRegul"
                    ]
                },
                text: {
                    status: "generated",
                    div: "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p class=\"res-header-id\"><b>Narratif généré : Praticien ExamplePractitionerRegul1</b></p><a name=\"ExamplePractitionerRegul1\"> </a><a name=\"hcExamplePractitionerRegul1\"> </a><div style=\"display: inline-block; background-color: #d9e0e7; padding: 6px; margin: 4px; border: 1px solid #8da1b4; border-radius: 5px; line-height: 60%\"><p style=\"margin-bottom: 0px\"/><p style=\"margin-bottom: 0px\">Information Source: <a href=\"https://simplifier.net/resolve?scope=hl7.fhir.fr.core@1.1.0&amp;canonical=urn:oid:1.2.250.1.213.3.6\">urn:oid:1.2.250.1.213.3.6</a></p><p style=\"margin-bottom: 0px\">Profil: <a href=\"StructureDefinition-FrPractitionerRegul.html\">FrPractitionerRegul</a></p></div><p><b>identifier</b>: Identifiant National de Professionnel de Santé/3456780581/11242343</p><p><b>active</b>: true</p><p><b>name</b>: Sébastien Loridon </p><p><b>telecom</b>: <a href=\"mailto:sebastien.loridon@test.com\">sebastien.loridon@test.com</a></p></div>"
                },
                identifier: [
                    {
                    type: {
                        coding: [
                        {
                            system: "http://interopsante.org/fhir/CodeSystem/fr-v2-0203",
                            code: "#{code}"
                        }
                        ]
                    },
                    system: "#{sys}",
                    value: "#{regulator_id}"
                    }
                ],
                active: active,
                name: [
                    {
                    family: "#{regulator_last_name}",
                    given: [
                        "#{regulator_first_name}"
                    ]
                    }
                ],
                telecom: [
                    {
                        system: "email",
                        value: "#{regulator_mail}"
                    }
                ]
            )
        end

        def self.build_bad_regulateur_body(regulator_id, regulator_mail, resource_id, regulator_first_name, regulator_last_name, sys)
            FHIR::Practitioner.new(
                resourceType: "Practitioner",
                id: "#{resource_id}",
                meta: {
                    source: "urn:oid:1.2.250.1.213.3.6",
                    profile: [
                        "https://interop.esante.gouv.fr/ig/fhir/sas/StructureDefinition/FrPractitionerRegul"
                    ]
                },
                text: {
                    status: "generated",
                    div: "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p class=\"res-header-id\"><b>Narratif généré : Praticien ExamplePractitionerRegul1</b></p><a name=\"ExamplePractitionerRegul1\"> </a><a name=\"hcExamplePractitionerRegul1\"> </a><div style=\"display: inline-block; background-color: #d9e0e7; padding: 6px; margin: 4px; border: 1px solid #8da1b4; border-radius: 5px; line-height: 60%\"><p style=\"margin-bottom: 0px\"/><p style=\"margin-bottom: 0px\">Information Source: <a href=\"https://simplifier.net/resolve?scope=hl7.fhir.fr.core@1.1.0&amp;canonical=urn:oid:1.2.250.1.213.3.6\">urn:oid:1.2.250.1.213.3.6</a></p><p style=\"margin-bottom: 0px\">Profil: <a href=\"StructureDefinition-FrPractitionerRegul.html\">FrPractitionerRegul</a></p></div><p><b>identifier</b>: Identifiant National de Professionnel de Santé/3456780581/11242343</p><p><b>active</b>: true</p><p><b>name</b>: Sébastien Loridon </p><p><b>telecom</b>: <a href=\"mailto:sebastien.loridon@test.com\">sebastien.loridon@test.com</a></p></div>"
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
                    system: "#{sys}",
                    value: "#{regulator_id}"
                    }
                ],
                name: [
                    {
                    family: "#{regulator_last_name}",
                    given: [
                        "#{regulator_first_name}"
                    ]
                    }
                ],
                telecom: [
                    {
                        system: "email",
                        value: "#{regulator_mail}"
                    }
                ]
            )
        end

        def self.http_client(base_url)
            url = URI(base_url)
            url.path += "/Practitioner"
            http = Net::HTTP.new(url.host, url.port)
            http.cert = OpenSSL::X509::Certificate.new(File.read("./config/cert/inferno-prePROD.pem"))
            http.key = OpenSSL::PKey::RSA.new(File.read("./config/cert/inferno-prePROD.key"))
            http.use_ssl = true
            headers = { 'content-type': 'application/fhir+json' }
            return http, url, headers
        end

        def self.build_search_params(regulator_id, sys)
            {
                _include: 'Practitioner:identifier',
                'value': "#{sys}|#{regulator_id}"
            }
        end
    end
end