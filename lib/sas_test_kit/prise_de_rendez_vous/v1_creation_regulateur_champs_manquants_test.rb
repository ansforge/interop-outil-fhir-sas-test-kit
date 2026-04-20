require_relative 'invalid_fhir_resources/practitioner_missing_fields'

module SasTestKit
    class BadCreationRegulateurTest < Inferno::Test
        title "Créations multiples : vérification des erreurs lors d'absence de champs obligatoires"
        id :creation_regulateur_champs_manquants_test
        description %(
            ## Description

            Ce test effectue une série de tentatives de création à l'aide de requêtes `POST` volontairement incomplètes, chacune omettant un ou plusieurs champs obligatoires.  
            L'objectif est de vérifier que l'API réagit correctement lorsque les données nécessaires à la création ne sont pas fournies.

            Le test doit valider que :

            - chaque requête de création incomplète est rejetée ;
            - les statuts HTTP renvoyés correspondent à l'erreur attendue ;

            Ce scénario garantit que la validation des champs obligatoires fonctionne correctement sur l'ensemble des créations testées.
        )
        run do
            bad_regulator = InvalidPractitionerField::NO_IDENTIFIER
            mTLS == 'true' ? fhir_create(bad_regulator) : fhir_create(bad_regulator, client: :no_mTLS)
            assert(response[:status] >= 400 && response[:status] < 600, "Test NO_IDENTIFIER: Expected response status 4xx or 5xx, got #{response[:status]}")
            #----------
            bad_regulator = InvalidPractitionerField::NO_NAME
            mTLS == 'true' ? fhir_create(bad_regulator) : fhir_create(bad_regulator, client: :no_mTLS)
            assert(response[:status] >= 400 && response[:status] < 600, "Test NO_NAME: Expected response status 4xx or 5xx, got #{response[:status]}")
            #----------
            bad_regulator = InvalidPractitionerField::NO_TELECOM
            mTLS == 'true' ? fhir_create(bad_regulator) : fhir_create(bad_regulator, client: :no_mTLS)
            assert(response[:status] >= 400 && response[:status] < 600, "Test NO_TELECOM: Expected response status 4xx or 5xx, got #{response[:status]}")
            #----------
            bad_regulator = InvalidPractitionerField::NO_ACTIVE
            mTLS == 'true' ? fhir_create(bad_regulator) : fhir_create(bad_regulator, client: :no_mTLS)
            assert(response[:status] >= 400 && response[:status] < 600, "Test NO_ACTIVE: Expected response status 4xx or 5xx, got #{response[:status]}")
        end
    end
end