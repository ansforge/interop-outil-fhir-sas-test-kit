require_relative 'sos_single_association_group'
require_relative 'sos_two_association_group'

module SasTestKit
    class SOSAggregationGroup < Inferno::TestGroup
        title 'Flux agregateur'
        id    :sos_aggregation_group
        description %(
           )

        input :siret, 
                title: "SIRET de l'association",
                type: 'text',
                description: "SIRET d'une association contenant des disponibilités sur un PFG pour la recherche de créneaux"
            
        input :siret_2, 
                title: "SIRET de l'association",
                type: 'text',
                description: "SIRET d'une association contenant des disponibilités sur deux PFG pour la recherche de créneaux"

        input_order :base_url, :mTLS

        group from: :single_association,
            config: {
                options: {
                    launch_version: SASOptions::IG_VERSION_SOS
                }
            }
        
        group from: :two_association,
            config: {
                options: {
                    launch_version: SASOptions::IG_VERSION_SOS
                }
            }
    end
end