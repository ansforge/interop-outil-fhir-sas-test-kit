require_relative 'v2_connected_group'
require_relative 'v2_not_connected_group'

require 'nokogiri'

module SasTestKit
    class FluxV2Group < Inferno::TestGroup
        title "Tests de conformité SAS - Flux V2 (SSO)"
        description %(
            ## Description

            Ce groupe regroupe un ensemble de tests de conformité relatifs au **flux V2 de gestion des comptes régulateurs**, tel que défini dans les spécifications techniques SAS publiées par l'ANS.  
            Ces tests valident le comportement du serveur vis à vis des spécifications du flux de délégation d'authentification [1](https://esante.gouv.fr/sites/default/files/media/document/SAS_DOC_SPEC%20INT_SSO_Delegation-dauthentification_20230609_V2.2.pdf).
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