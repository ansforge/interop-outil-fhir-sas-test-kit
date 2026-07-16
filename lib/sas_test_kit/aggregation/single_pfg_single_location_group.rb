module SasTestKit
    module SinglePFGSingleLocation
        class SinglePFGSingleLocation < Inferno::TestGroup
            title ''
            description %()
            id :single_pfg_single_location

            input :SIRET, 
                    title: 'SIRET du PFG',
                    type: 'text',
                    description: 'SIRET du PS à utiliser pour la recherche de créneaux'

            input_order :base_url, :mTLS, :SIRET
      
            run_as_group
            
            test from: :slot_search_setup do
                config(
                    inputs: { 
                        practitioner_id: { name: :SIRET },
                    }
                )
            end
        end
    end
end