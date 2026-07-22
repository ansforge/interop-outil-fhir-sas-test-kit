require_relative 'single_pfg_single_location_tests/sos_validate_organization_cardinality_test'
require_relative 'single_pfg_single_location_tests/sos_validate_location_cardinality_test'
require_relative 'single_pfg_single_location_tests/sos_validate_organization_siret_test'

module SasTestKit
    module SingleAssociation
        class SingleAssociation < Inferno::TestGroup
            title 'PFG associé à une seule association'
            description %()
            id :single_association

            input :siret, 
                    title: 'SIRET du PFG',
                    type: 'text',
                    description: 'SIRET du PS à utiliser pour la recherche de créneaux'

            input_order :base_url, :mTLS, :siret
      
            run_as_group
            
            test from: :slot_search_setup do
                config(
                    inputs: { 
                        practitioner_id: { name: :siret },
                    }
                )
            end

            test from: :validate_organization_cardinality

            test from: :validate_location_cardinality

            test from: :validate_organization_siret
        end
    end
end