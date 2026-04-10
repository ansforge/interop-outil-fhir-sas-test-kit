require_relative '../aggregation/setup_test'
require_relative '../sas_options'
require_relative 'v2_connexion_without_origin_test'
require_relative 'v2_connexion_while_unidentified_test'

module SasTestKit
    class FluxV2NotConnectedGroup < Inferno::TestGroup
        title "FLux V2 - Régulateur non identifié sur la plateforme numérique du SAS"
        description %(
            # Description

            Ce groupe de tests permet de tester les deux scénarios suivants :  
            -   le paramètre origin= n'est pas présetn dans la requête.
            -   l'utilisateur n'est pas connecté à la plateforme du sas
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