module SasTestKit
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

        def self.http_client(base_url)
            url = URI(base_url)
            url.path += "/Practitioner"
            http = Net::HTTP.new(url.host, url.port)
            http.cert = OpenSSL::X509::Certificate.new(File.read("./config/cert/inferno-prePROD.pem"))
            http.key = OpenSSL::PKey::RSA.new(File.read("./config/cert/inferno-prePROD.key"))
            http.use_ssl = true
            headers = { 'content-type': 'application/json', 'Accept': 'application/json+fhir' }
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