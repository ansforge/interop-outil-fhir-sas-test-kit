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
            error_message = %(
                ### Échec du test : NO_IDENTIFIER

                - **Résultat attendu** : erreur HTTP (**4xx ou 5xx**)  
                - **Résultat obtenu** : **`#{response[:status]}`**

                L'API aurait dû rejeter la requête en raison de l'absence du champ **identifier**.
            )
            assert(response[:status] >= 400 && response[:status] < 600, error_message)
            #----------
            bad_regulator = InvalidPractitionerField::NO_NAME
            mTLS == 'true' ? fhir_create(bad_regulator) : fhir_create(bad_regulator, client: :no_mTLS)
            error_message = %(
                ### Échec du test : NO_NAME

                - **Résultat attendu** : erreur HTTP (**4xx ou 5xx**)  
                - **Résultat obtenu** : **`#{response[:status]}`**

                L'API aurait dû rejeter la requête en raison de l'absence du champ **name**.
            )
            assert(response[:status] >= 400 && response[:status] < 600, error_message)
            #----------
            bad_regulator = InvalidPractitionerField::NO_TELECOM
            mTLS == 'true' ? fhir_create(bad_regulator) : fhir_create(bad_regulator, client: :no_mTLS)
            error_message = %(
                ### Échec du test : NO_TELECOM

                - **Résultat attendu** : erreur HTTP (**4xx ou 5xx**)  
                - **Résultat obtenu** : **`#{response[:status]}`**

                L'API aurait dû rejeter la requête en raison de l'absence du champ **telecom**.
            )
            assert(response[:status] >= 400 && response[:status] < 600, error_message)
            #----------
            bad_regulator = InvalidPractitionerField::NO_ACTIVE
            mTLS == 'true' ? fhir_create(bad_regulator) : fhir_create(bad_regulator, client: :no_mTLS)
            error_message = %(
                ### Échec du test : NO_ACTIVE

                - **Résultat attendu** : erreur HTTP (**4xx ou 5xx**)  
                - **Résultat obtenu** : **`#{response[:status]}`**

                L'API aurait dû rejeter la requête en raison de l'absence du champ **active**.
            )
            assert(response[:status] >= 400 && response[:status] < 600, error_message)
        end
    end
end