require_relative 'single-practitioner-single-location_group'
require_relative 'multi_lieux_group'
require_relative 'options_slot_group'
require_relative 'performance_group'
require_relative 'practitioner_group_optionnel_ps'
require_relative 'search_multiple_ps_group'
require_relative 'slot_group'
require_relative 'organizational_group_optionnel'

require_relative '../sas_options.rb'

module SasTestKit
    class AggregationGroup < Inferno::TestGroup
        title 'Flux agregateur'
        id    :aggregation_group
        description %(
        )

        group from: :slot_group

        group from: :single_practitioner_single_location

        group from: :multi_lieux_group

        group from: :search_multiple_ps_group

        group from: :practi_optionnel_group_ps

        group from: :optionslots_group
            
        group from: :performance_group

        group from: :orga_optionnel_group,
            required_suite_options: SASOptions::IG_REQUIREMENT_CPTS
    end
end