require_relative 'helper_fluxv1'
require 'securerandom'

module MyTestKit
    class PutAsCreate < Inferno::Test
        title 'Put as create'
        id :put_as_create
        description %(
            Ce test envoie une requête PUT pour un practitioner non-existant.
        )
        run do
            sys = 'urn:oid:1.2.250.1.71.4.2.1'
            uuid = SecureRandom.uuid
            updated_regulator = HelperFLuxv1.build_regulateur_body(uuid, "#{uuid}" + regulator_mail, resource_id, "#{uuid}" + regulator_first_name, "#{uuid}" + regulator_last_name, sys)

            http, url, headers = HelperFLuxv1.http_client(base_url)
            url.query = URI.encode_www_form({ 'identifier': 'urn:oid:1.2.250.1.71.4.2.1|' + uuid })
            response = http.put(url, updated_regulator.to_json, headers)

            add_message("info", "request : #{url}")
            add_message("info", "response body: #{response.body}")
            assert(response.code.to_i == 201, "Expected response status 201, got #{response.code}")
        end
    end
end