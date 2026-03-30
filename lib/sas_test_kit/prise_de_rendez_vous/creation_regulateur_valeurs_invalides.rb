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
            fhir_create(bad_regulator)
            assert(response[:status] >= 400 && response[:status] < 600, "Test EMPTY_NAME: Expected response status 4xx or 5xx, got #{response[:status]}")
            #----------
            bad_regulator = InvalidPractitionerValues::EMPTY_MAIL
            fhir_create(bad_regulator)
            assert(response[:status] >= 400 && response[:status] < 600, "Test EMPTY_MAIL: Expected response status 4xx or 5xx, got #{response[:status]}")
            #----------
            bad_regulator = InvalidPractitionerValues::WRONG_TELECOM_SYSTEM
            fhir_create(bad_regulator)
            assert(response[:status] >= 400 && response[:status] < 600, "Test WRONG_TELECOM_SYSTEM: Expected response status 4xx or 5xx, got #{response[:status]}")
             #----------
            bad_regulator = InvalidPractitionerValues::WRONG_CODE_FOR_IDNPS_SYSTEM
            fhir_create(bad_regulator)
            assert(response[:status] >= 400 && response[:status] < 600, "Test WRONG_CODE_FOR_IDNPS_SYSTEM: Expected response status 4xx or 5xx, got #{response[:status]}")
             #----------
            bad_regulator = InvalidPractitionerValues::WRONG_CODE_FOR_INTRN_SYSTEM
            fhir_create(bad_regulator)
            assert(response[:status] >= 400 && response[:status] < 600, "Test WRONG_CODE_FOR_INTRN_SYSTEM: Expected response status 4xx or 5xx, got #{response[:status]}")
        end
    end
end
