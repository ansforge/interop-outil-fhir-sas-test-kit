require_relative 'sos_single_association_single_pfg_group'
require_relative 'sos_single_association_two_pfg_group'

module SasTestKit
    module SingleAssociation
        class SingleAssociation < Inferno::TestGroup
            title 'Une association'
            id    :single_association
            description %(
            ## Description
            Ce groupe de tests vérifie la conformité d'une recherche de créneaux réalisée pour une seule association.  
            Il est divisé en deux sous groupes représentant deux scénario avec respectivement un et deux PFG ayant des disponibilités.
            )

            input_order :base_url, :mTLS

            group from: :single_association_single_pfg,
                config: {
                    options: {
                        launch_version: SASOptions::IG_VERSION_SOS
                    }
                }

            group from: :single_association_two_pfg,
                config: {
                    options: {
                        launch_version: SASOptions::IG_VERSION_SOS
                    }
                }
        end
    end
end