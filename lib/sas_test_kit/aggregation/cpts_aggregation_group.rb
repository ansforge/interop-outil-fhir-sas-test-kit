require_relative 'cpts_single_practitioner_single_location_group'
require_relative 'ps_multi_lieux_group'
require_relative 'ps_options_slot_group'
require_relative 'performance_group'
require_relative 'ps_practitioner_optionnel_group'
require_relative 'ps_search_multiple_ps_group'
require_relative 'slot_group'
require_relative 'cpts_organizational_group_optionnel'
require_relative 'cpts_single_practitioner_multiple_cpts_group'

require_relative '../sas_options.rb'

module SasTestKit
    class CPTSAggregationGroup < Inferno::TestGroup
        title 'Flux agregateur'
        id :cpts_aggregation_group
        description %(
            Ce groupe de test vérifie la conformité du **serveur FHIR** aux spécifications du flux **agrégation de créneaux**.  

            Les spécifications du flux **agrégation de créneaux** selon les cas d'usages :
            -   [PS indiv](https://interop.esante.gouv.fr/ig/fhir/sas/specifications_techniques-ps-recherche_creneaux.html)
            -   [CPTS](https://interop.esante.gouv.fr/ig/fhir/sas/specifications_techniques-cpts-recherche_creneaux.html)
            -   [SOS Médecins](https://interop.esante.gouv.fr/ig/fhir/sas/specifications_techniques-sos-recherche_creneaux.html)
        )
        verifies_requirements 'agg-psindiv@4', 'agg-psindiv@6', 'agg-psindiv@7','agg-psindiv@26', 'agg-psindiv@27', 'agg-psindiv@28', 'agg-psindiv@29', 'agg-psindiv@30'

        input_order :base_url, :mTLS

        group from: :performance_group

        group from: :slot_group

        group from: :cpts_single_practitioner_single_location

        group from: :multi_lieux_group

        group from: :search_multiple_ps_group

        group from: :practi_optionnel_group_ps

        group from: :optionslots_group do
            replace :ps_validate_slot_type, :cpts_validate_slot_type
        end

        group from: :single_practitioner_multiple_cpts

        group from: :orga_optionnel_group
    end
end