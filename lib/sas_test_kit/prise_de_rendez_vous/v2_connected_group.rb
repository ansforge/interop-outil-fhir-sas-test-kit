require_relative 'v2_connexion_lga_test'
require_relative 'v2_connexion_sas_test'

module SasTestKit
    class FluxV2ConnectedGroup < Inferno::TestGroup
        title "Régulateur déjà identifié sur la plateforme numérique du SAS"
        description %(
            # Test manuel

            ## Scénario
            1. Le régulateur est déjà authentifié sur la plateforme numérique du SAS.
            2. Le régulateur initie une connexion vers une solution de prise de rendez-vous.
            3. Le régulateur est automatiquement identifié et connecté à la solution de prise de rendez-vous, sans nouvelle authentification.

            ## Méthodologie de test
            1. Ouvrir le premier lien dans un nouvel onglet afin de se connecter à la plateforme numérique du SAS.
            2. Revenir ensuite sur la page Inferno.
            3. Ouvrir le second lien dans un nouvel onglet pour initier la connexion vers la solution éditeur.
            4. Procéder à l'évaluation du test.

            ## Évaluation du test
            Le test est considéré comme valide si l'ouverture du second lien redirige directement l'utilisateur vers une page de prise de rendez-vous ou un agenda,
            sans qu'aucune étape d'authentification supplémentaire ne soit demandée.
        )
        id :flux_v2_connected_group
        
        run_as_group

        test from: :sso_sas

        test from: :sso_lga
    end
end