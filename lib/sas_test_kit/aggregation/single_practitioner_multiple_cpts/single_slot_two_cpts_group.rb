require_relative '../setup_test'

require_relative 'tests/cpts_validate_organization_cardinality_test'
require_relative 'tests/cpts_validate_healthcare_service_cardinality_test'
require_relative 'tests/cpts_validate_meta_test'
require_relative 'tests/cpts_validate_service_type_test'
require_relative 'tests/cpts_validate_service_type_multiple_healthcare_service_ref_test'
require_relative 'tests/cpts_validate_healthcare_service_organization_ref_test'

module SasTestKit
    module SinglePractitionerMultipleCPTS
        class SingleSlotTwoCPTS < Inferno::TestGroup
            title "Validation d'un Slot associés à deux CPTS distinctes"
            id :single_slot_two_cpts
            description %()

            input_order :base_url, :mTLS, :practitioner_id2
            
            test from: :slot_search_setup do
                config(
                    inputs: { 
                        practitioner_id: { name: :practitioner_id2 },
                    }
                )
            end

            test from: :cpts_validate_healthcare_service_cardinality

            test from: :cpts_validate_organization_cardinality

            test from: :cpts_validate_meta

            test from: :cpts_validate_service_type

            test from: :cpts_validate_service_type_multiple_healthcare_service_ref

            test from: :cpts_validate_healthcare_service_organization_ref
        end
    end
end