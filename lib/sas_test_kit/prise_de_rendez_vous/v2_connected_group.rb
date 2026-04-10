require_relative 'v2_connexion_lga_test'
require_relative 'v2_connexion_sas_test'

module SasTestKit
    class FluxV2ConnectedGroup < Inferno::TestGroup
        title "FLux V2 - Régulateur déjà identifié sur la plateforme numérique du SAS"
        description %(
        # Scénario
        1. Le régulateur est déjà identifié sur la plateforme numérique du SAS.
        2. Le régulateur initie une connexion a une solution de prise de rendez-vous.
        3. Le régulateur est bien identifié et connecté à la solution de prise de rendez-vous.

        ## Méthodologie de test
        1. Le testeur doit être identifié sur la plateforme numérique du SAS.
        2. Le testeur initie une connexion a une solution de prise de rendez-vous.
        3. Le testeur est bien identifié et connecté à la solution de prise de rendez-vous.
        )
        id :flux_v2_connected_group
        
        run_as_group

        test from: :sso_sas

        test from: :sso_lga
    end
end