require_relative 'affichageSlot_group_ps'
require_relative 'affichageSlot_group_cpts'
require_relative 'multi_lieux_group_ps'
require_relative 'options_slot_group_ps'
require_relative 'options_slot_group_cpts'
require_relative 'organizational_group_optionnel_cpts'
require_relative 'performance_group'
require_relative 'practitioner_group_optionnel_ps'
require_relative 'search_multiple_ps_group'
require_relative 'slot_group_ps'
require_relative 'slot_group_cpts'
require_relative '../sas_options.rb'

module SasTestKit
    class AggregationGroup < Inferno::TestGroup
        title 'Flux agregateur'
        id    :aggregation_group
        description %(
        )

        group from: :slot_group_cpts,
            required_suite_options: SASOptions::IG_REQUIREMENT_CPTS

        group from: :slot_group_ps,
            required_suite_options: SASOptions::IG_REQUIREMENT_PSINDIV
            
        group from: :affichage_slot_group_cpts,
            required_suite_options: SASOptions::IG_REQUIREMENT_CPTS

        group from: :affichage_slot_group_ps,
            required_suite_options: SASOptions::IG_REQUIREMENT_PSINDIV

        group from: :multiLieu_group_ps,
            required_suite_options: SASOptions::IG_REQUIREMENT_PSINDIV

        group from: :search_multiple_ps_group,
            required_suite_options: SASOptions::IG_REQUIREMENT_PSINDIV

        group from: :practi_optionnel_group_ps, 
            required_suite_options: SASOptions::IG_REQUIREMENT_PSINDIV

        group from: :orga_optionnel_group_cpts,
            required_suite_options: SASOptions::IG_REQUIREMENT_CPTS

        group from: :optionslots_group_ps,
            required_suite_options: SASOptions::IG_REQUIREMENT_PSINDIV
            
        group from: :optionslots_group_cpts,
            required_suite_options: SASOptions::IG_REQUIREMENT_CPTS
            
        group from: :performance_group
    end
end