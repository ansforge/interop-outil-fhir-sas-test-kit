require_relative 'invalid_fhir_resources'
require_relative 'helper_fluxv1'


module MyTestKit
    class BadModificationRegulateurTest < Inferno::Test
        title "Modifications multiples : vérification des erreurs lors d'absence de champs obligatoires"
        id :modification_regulateur_champs_manquants_test
        description %(
            ## Description

            Ce test effectue une série de tentatives de modifications volontairement incomplètes, chacune omettant un ou plusieurs champs obligatoires.  
            L'objectif est de vérifier que l'API réagit correctement lorsque les données nécessaires à la modification ne sont pas fournies.

            Le test doit valider que :

            - chaque requête de modification incomplète est rejetée ;
            - les statuts HTTP renvoyés correspondent à l'erreur attendue ;

            Ce scénario garantit que la validation des champs obligatoires fonctionne correctement sur l'ensemble des modifications testées.
        )
        run do
            http, url, headers = HelperFLuxv1.http_client(base_url)
            url.query = URI.encode_www_form({ 'identifier': 'urn:oid:1.2.250.1.71.4.2.1|' + regulator_id_modif })

            bad_regulator = InvalidPractitionerFixtures::NO_IDENTIFIER
            response = http.put(url, bad_regulator.to_json, headers)
            assert(response.code.to_i >= 400 && response.code.to_i < 600, "Test NO_IDENTIFIER: Expected response status 4xx or 5xx, got #{response.code}")
            #------------
            bad_regulator = InvalidPractitionerFixtures::NO_NAME
            response = http.put(url, bad_regulator.to_json, headers)
            assert(response.code.to_i >= 400 && response.code.to_i < 600, "Test NO_NAME: Expected response status 4xx or 5xx, got #{response.code}")
            #------------
            bad_regulator = InvalidPractitionerFixtures::NO_TELECOM
            response = http.put(url, bad_regulator.to_json, headers)
            assert(response.code.to_i >= 400 && response.code.to_i < 600, "Test NO_TELECOM: Expected response status 4xx or 5xx, got #{response.code}")
            #------------
            bad_regulator = InvalidPractitionerFixtures::NO_ACTIVE
            response = http.put(url, bad_regulator.to_json, headers)
            assert(response.code.to_i >= 400 && response.code.to_i < 600, "Test NO_ACTIVE: Expected response status 4xx or 5xx, got #{response.code}")

        end
    end
end