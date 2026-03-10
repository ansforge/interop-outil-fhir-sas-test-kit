require_relative 'helper_fluxv1'

module MyTestKit
    class ModificationNomRegulateurTest < Inferno::Test
        title 'Modification du nom du compte régulateur'
        id :modification_nom_regulateur_test
        description %(
            Ce test modifie le nom du compte régulateur créé précédement et vérifie la réponse du serveur.
        )
        run do
            sys = 'urn:oid:1.2.250.1.71.4.2.1'            
            updated_regulator = HelperFLuxv1.build_regulateur_body(regulator_id_modif, regulator_mail_modif, resource_id, regulator_first_name, regulator_last_name_modif, sys)

            http, url, headers = HelperFLuxv1.http_client(base_url)
            url.query = URI.encode_www_form({ 'identifier': 'urn:oid:1.2.250.1.71.4.2.1|' + regulator_id_modif })
            response = http.put(url, updated_regulator.to_json, headers)

            add_message("info", "request : #{url}")
            add_message("info", "response body: #{response.body}")
            assert(response.code.to_i >=200 && response.code.to_i < 400, "Expected response status 2xx or 3xx, got #{response.code}")
        end
    end
end