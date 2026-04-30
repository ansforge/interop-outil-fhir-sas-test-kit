require_relative 'invalid_fhir_resources/practitioner_invalid_values'

module SasTestKit
    
class BadCreationRegulateurInvalidValuesTest < Inferno::Test
    title "Créations multiples : vérification des erreurs pour des valeurs invalides"
    id :creation_regulateur_valeurs_invalides
    description %(
      ## Description

      Ce test effectue une série de tentatives de création à l'aide de requêtes `POST` contenant des **valeurs invalides**, tout en respectant la structure minimale requise pour un Practitoner.  
      Chaque ressource envoyée présente une anomalie métier dans ses champs, par exemple :  
      - des paires `system/code` incohérentes dans `identifier` ;  
      - un `family` vide dans `name` ;  
      - une adresse `telecom` vide ;  
      - un type de `telecom.system` non conforme ;  
      - ou tout autre champ devant respecter une règle de cohérence.

      Le test doit valider que :

      - chaque création utilisant des valeurs invalides est correctement rejetée ;
      - les statuts HTTP renvoyés correspondent à l'erreur attendue ;

      Ce scénario garantit que la validation métier est correctement appliquée lorsque les champs fournis sont présents mais incorrects.
    )
    optional

        run do
            bad_regulator = InvalidPractitionerValues::EMPTY_NAME
            mTLS == 'true' ? fhir_create(bad_regulator) : fhir_create(bad_regulator, client: :no_mTLS)
            error_message = %(
                ### Échec du test : EMPTY_NAME

                - **Résultat attendu** : erreur HTTP (**4xx ou 5xx**)  
                - **Résultat obtenu** : **`#{response[:status]}`**

                L'API aurait dû rejeter la requête, le champ name.family étant vide.
            )
            assert(response[:status] >= 400 && response[:status] < 600, error_message)
            #----------
            bad_regulator = InvalidPractitionerValues::EMPTY_MAIL
            mTLS == 'true' ? fhir_create(bad_regulator) : fhir_create(bad_regulator, client: :no_mTLS)
            error_message = %(
                ### Échec du test : EMPTY_MAIL

                - **Résultat attendu** : erreur HTTP (**4xx ou 5xx**)  
                - **Résultat obtenu** : **`#{response[:status]}`**

                L'API aurait dû rejeter la requête, le champ telecom.value étant vide.
            )
            assert(response[:status] >= 400 && response[:status] < 600, error_message)
            #----------
            bad_regulator = InvalidPractitionerValues::WRONG_TELECOM_SYSTEM
            mTLS == 'true' ? fhir_create(bad_regulator) : fhir_create(bad_regulator, client: :no_mTLS)
            error_message = %(
                ### Échec du test : WRONG_TELECOM_SYSTEM

                - **Résultat attendu** : erreur HTTP (**4xx ou 5xx**)  
                - **Résultat obtenu** : **`#{response[:status]}`**

                L'API aurait dû rejeter la requête, le champ telecom.system étant invalide.
            )
            assert(response[:status] >= 400 && response[:status] < 600, error_message)
             #----------
            bad_regulator = InvalidPractitionerValues::WRONG_CODE_FOR_IDNPS_SYSTEM
            mTLS == 'true' ? fhir_create(bad_regulator) : fhir_create(bad_regulator, client: :no_mTLS)
            error_message = %(
                ### Échec du test : WRONG_CODE_FOR_IDNPS_SYSTEM

                - **Résultat attendu** : erreur HTTP (**4xx ou 5xx**)  
                - **Résultat obtenu** : **`#{response[:status]}`**

                L'API aurait dû rejeter la requête, le champ identifier.coding.code devrait être **IDNPS**.
            )
            assert(response[:status] >= 400 && response[:status] < 600, error_message)
             #----------
            bad_regulator = InvalidPractitionerValues::WRONG_CODE_FOR_INTRN_SYSTEM
            mTLS == 'true' ? fhir_create(bad_regulator) : fhir_create(bad_regulator, client: :no_mTLS)
            error_message = %(
                ### Échec du test : WRONG_CODE_FOR_INTRN_SYSTEM

                - **Résultat attendu** : erreur HTTP (**4xx ou 5xx**)  
                - **Résultat obtenu** : **`#{response[:status]}`**

                L'API aurait dû rejeter la requête, le champ identifier.coding.code devrait être **INTRN**.
            )
            assert(response[:status] >= 400 && response[:status] < 600, error_message)
        end
    end
end
