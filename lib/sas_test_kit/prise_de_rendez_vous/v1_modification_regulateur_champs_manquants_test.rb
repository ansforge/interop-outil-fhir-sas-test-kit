require_relative 'invalid_fhir_resources/practitioner_missing_fields'
require_relative 'helper_fluxv1'

module SasTestKit
    class BadModificationRegulateurTest < Inferno::Test
        title "Modifications multiples : vérification des erreurs lors d'absence de champs obligatoires"
        id :modification_regulateur_champs_manquants_test
        description %(
            ## Description

            Ce test effectue une série de tentatives de modifications à l'aide de requêtes `PUT` volontairement incomplètes, chacune omettant un ou plusieurs champs obligatoires.  
            L'objectif est de vérifier que l'API réagit correctement lorsque les données nécessaires à la modification ne sont pas fournies.

            Le test doit valider que :

            - chaque requête de modification incomplète est rejetée ;
            - les statuts HTTP renvoyés correspondent à l'erreur attendue ;

            Ce scénario garantit que la validation des champs obligatoires fonctionne correctement sur l'ensemble des modifications testées.
        )
        run do
            bad_regulator = InvalidPractitionerField::NO_IDENTIFIER
            put("Practitioner?identifier=urn:oid:1.2.250.1.71.4.2.1|#{regulator_id_modif}", body: bad_regulator.to_json)
            assert(response[:status] >= 400 && response[:status] < 600, "Test NO_IDENTIFIER: Expected response status 4xx or 5xx, got #{response[:status]}")
            #------------
            bad_regulator = InvalidPractitionerField::NO_NAME
            put("Practitioner?identifier=urn:oid:1.2.250.1.71.4.2.1|#{regulator_id_modif}", body: bad_regulator.to_json)
            assert(response[:status] >= 400 && response[:status] < 600, "Test NO_NAME: Expected response status 4xx or 5xx, got #{response[:status]}")
            #------------
            bad_regulator = InvalidPractitionerField::NO_TELECOM
            put("Practitioner?identifier=urn:oid:1.2.250.1.71.4.2.1|#{regulator_id_modif}", body: bad_regulator.to_json)
            assert(response[:status] >= 400 && response[:status] < 600, "Test NO_TELECOM: Expected response status 4xx or 5xx, got #{response[:status]}")
            #------------
            bad_regulator = InvalidPractitionerField::NO_ACTIVE
            put("Practitioner?identifier=urn:oid:1.2.250.1.71.4.2.1|#{regulator_id_modif}", body: bad_regulator.to_json)
            assert(response[:status] >= 400 && response[:status] < 600, "Test NO_ACTIVE: Expected response status 4xx or 5xx, got #{response[:status]}")
        end
    end
end