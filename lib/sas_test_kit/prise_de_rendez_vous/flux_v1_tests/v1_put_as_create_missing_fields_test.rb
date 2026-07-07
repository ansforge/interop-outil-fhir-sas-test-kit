require_relative 'invalid_fhir_resources/practitioner_missing_fields'
require_relative 'helper_fluxv1'

module SasTestKit
    class BadModificationAsCreationRegulateurTest < Inferno::Test
        title "Modifications en tant que création multiples : vérification des erreurs lors d'absence de champs obligatoires"
        id :put_as_create_missing_fields_test
        description %(
            ## Description

            Ce test effectue une série de tentatives de creations à l'aide de requêtes `PUT` volontairement incomplètes, chacune omettant un ou plusieurs champs obligatoires.  
            L'objectif est de vérifier que l'API réagit correctement lorsque les données nécessaires à la création ne sont pas fournies.

            Le test doit valider que :

            - chaque requête de création incomplète est rejetée ;
            - les statuts HTTP renvoyés correspondent à l'erreur attendue ;

            Ce scénario garantit que la validation des champs obligatoires fonctionne correctement sur l'ensemble des créations testées.
        )
        run do
            uuid = SecureRandom.uuid

            bad_regulator = InvalidPractitionerField::NO_IDENTIFIER
            put("Practitioner?identifier=urn:oid:1.2.250.1.213.3.6|#{uuid}", body: bad_regulator.to_json)
            error_message = %(
                ### Échec du test : NO_IDENTIFIER

                - **Résultat attendu** : erreur HTTP (**4xx ou 5xx**)  
                - **Résultat obtenu** : **`#{response[:status]}`**

                L'API aurait dû rejeter la requête en raison de l'absence du champ **identifier**.
            )
            assert(response[:status] >= 400 && response[:status] < 600, error_message)
            #------------
            bad_regulator = InvalidPractitionerField::NO_NAME
            put("Practitioner?identifier=urn:oid:1.2.250.1.213.3.6|#{uuid}", body: bad_regulator.to_json)
            error_message = %(
                ### Échec du test : NO_NAME

                - **Résultat attendu** : erreur HTTP (**4xx ou 5xx**)  
                - **Résultat obtenu** : **`#{response[:status]}`**

                L'API aurait dû rejeter la requête en raison de l'absence du champ **name**.
            )
            assert(response[:status] >= 400 && response[:status] < 600, error_message)
            #------------
            bad_regulator = InvalidPractitionerField::NO_TELECOM
            put("Practitioner?identifier=urn:oid:1.2.250.1.213.3.6|#{uuid}", body: bad_regulator.to_json)
            error_message = %(
                ### Échec du test : NO_TELECOM

                - **Résultat attendu** : erreur HTTP (**4xx ou 5xx**)  
                - **Résultat obtenu** : **`#{response[:status]}`**

                L'API aurait dû rejeter la requête en raison de l'absence du champ **telecom**.
            )
            assert(response[:status] >= 400 && response[:status] < 600, error_message)
            #------------
            bad_regulator = InvalidPractitionerField::NO_ACTIVE
            put("Practitioner?identifier=urn:oid:1.2.250.1.213.3.6|#{uuid}", body: bad_regulator.to_json)
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