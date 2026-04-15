require_relative '../aggregation/setup_test'
require_relative '../sas_options'
require_relative 'v2_connexion_without_origin_test'
require_relative 'v2_connexion_while_unidentified_test'

module SasTestKit
    class FluxV2NotConnectedGroup < Inferno::TestGroup
        title "Régulateur non identifié sur la plateforme numérique du SAS"
        description %(
            ## Description

            Ce groupe de tests a pour objectif de valider le comportement du flux SSO v2
            dans des scénarios où le régulateur n'est pas préalablement identifié sur la
            plateforme numérique du SAS.

            Les tests couvrent les cas suivants :
            - le paramètre `origin` est absent de la requête initiant le flux SSO
            - l'utilisateur n'est pas connecté à la plateforme numérique du SAS au moment
                de l'initiation du parcours.

            L'objectif est de vérifier que, dans ces situations, le parcours
            d'authentification est correctement déclenché et conforme aux attentes
            fonctionnelles définies dans les spécifications.
        )
        id :flux_v2_not_connected_group

        test from: :slot_search_setup do
            config(
                inputs: { 
                practitioner_id: { name: :practitioner_id },
                }
            )
        end

        test from: :sso_without_origin

        test from: :sso_while_unidentified
    end
end