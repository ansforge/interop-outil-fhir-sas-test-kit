require_relative 'v2_connected_group'
require_relative 'v2_not_connected_group'

require 'nokogiri'

module SasTestKit
    class FluxV2Group < Inferno::TestGroup
        title "SSO - Flux V2"
        description %(
            # Description des tests du flux SSO

            Ce groupe regroupe un ensemble de tests de conformité relatifs au **flux SSO**, tel que défini dans les spécifications techniques SAS publiées par l'ANS.  
            Ces tests visent à valider le bon déroulement du processus de **délégation d'authentification**, conformément aux exigences 
            décrites dans la [documentation de référence](https://esante.gouv.fr/sites/default/files/media/document/SAS_DOC_SPEC%20INT_SSO_Delegation-dauthentification_20230609_V2.2.pdf).

            ## Fonctionnement des tests

            - Phase **d'initialisation** :
                - Une requête d'agrégation de créneaux est effectuée à l'aide du RPPS utilisé pour les tests d'agrégation.
                - Une réponse HTTP 200 contenant un Bundle conforme est attendue.
                - L'URL permettant de déclencher le flux SSO est extraite du champ `comment` du premier `Slot` présent dans le Bundle retourné.

            - Phase de **test** :
                - Des requêtes GET construites à partir de l'URL récupérée lors de la phase d'initialisation sont envoyées afin de démarrer le flux SSO.
                - La validation des tests est effectuée par l'analyse des réponses et des redirections obtenues.
                - Certains tests peuvent être omis lorsque le contenu des réponses ne permet pas une analyse exploitable.
        )

        id :flux_v2_group

        run_as_group

        http_client do
            url ''
        end

        group from: :flux_v2_not_connected_group

        group from: :flux_v2_connected_group
    end
end