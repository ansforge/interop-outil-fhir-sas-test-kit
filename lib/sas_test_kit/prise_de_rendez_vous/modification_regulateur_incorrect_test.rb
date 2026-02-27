require_relative 'helper_fluxv1'

module MyTestKit
    class BadModificationRegulateurTest < Inferno::Test
        title 'Modification incorrect du compte régulateur'
        id :modification_regulateur_incorrect_test
        description %(
            Ce test tente de modifier un compte régulateur avec des informations incorrects
        )
        run do
            updated_regulator = HelperFLuxv1.build_bad_regulateur_body(regulator_id, regulator_mail, resource_id, regulator_first_name, regulator_last_name)

            http, url, headers = HelperFLuxv1.http_client(base_url)
            url.query = URI.encode_www_form({ 'identifier': 'urn:oid:1.2.250.1.71.4.2.1|' + regulator_id })
            response = http.put(url, updated_regulator.to_json, headers)

            add_message("info", "request : #{url}")
            add_message("info", "response body: #{response.body}")
            assert(response.code.to_i >= 400 && response.code.to_i < 600, "Expected response status to be 4xx or 5xx, got #{response.code}")

        end
    end
end