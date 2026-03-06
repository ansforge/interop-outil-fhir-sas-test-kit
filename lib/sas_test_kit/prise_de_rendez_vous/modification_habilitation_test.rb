require_relative 'helper_fluxv1'

module MyTestKit
    class ModificationHabilitationTest < Inferno::Test
        title "Habilite un ps"
        id :modification_habilitation
        description %(
            Ce test passe le champ "active" d'une resource practitioner à true
        )
        run do
            sys = 'urn:oid:1.2.250.1.71.4.2.1'            
            updated_regulator = HelperFLuxv1.build_regulateur_body(regulator_id, regulator_mail, resource_id, regulator_first_name, regulator_last_name, sys)

            http, url, headers = HelperFLuxv1.http_client(base_url)
            url.query = URI.encode_www_form({ 'identifier': 'urn:oid:1.2.250.1.71.4.2.1|' + regulator_id })
            response = http.put(url, updated_regulator.to_json, headers)

            add_message("info", "request : #{url}")
            add_message("info", "response body: #{response.body}")
            assert(response.code.to_i == 200, "Expected response status 200, got #{response.code}")
        end
    end
end