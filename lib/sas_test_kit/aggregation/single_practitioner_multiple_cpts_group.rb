require_relative 'single_practitioner_multiple_cpts/two_slot_two_cpts_group'
require_relative 'single_practitioner_multiple_cpts/single_slot_two_cpts_group'

module SasTestKit
    module SinglePractitionerMultipleCPTS
        class SinglePractitionerMultipleCPTS < Inferno::TestGroup
            title ''
            id :single_practitioner_multiple_cpts
            description %()

            input_order :base_url, :mTLS, :practitioner_id

            group from: :two_slot_two_cpts

            group from: :single_slot_two_cpts
        end
    end
end