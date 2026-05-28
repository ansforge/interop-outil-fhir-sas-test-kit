require_relative 'single-practitioner-single-location_group'
require_relative 'multi_lieux_group'
require_relative 'options_slot_group'
require_relative 'performance_group'
require_relative 'practitioner_optionnel_group'
require_relative 'search_multiple_ps_group'
require_relative 'slot_group'
require_relative 'organizational_group_optionnel'
require_relative 'single_practitioner_multiple_cpts_group'

require_relative '../sas_options.rb'

module SasTestKit
    class AggregationGroup < Inferno::TestGroup
        title 'Flux agregateur'
        id    :aggregation_group
        description %(
            Ce groupe de test vérifie la conformité du **serveur FHIR** aux spécifications du flux **agrégation de créneaux**.  

            Les spécifications du flux **agrégation de créneaux** selon les cas d'usages :
            -   [PS indiv](https://interop.esante.gouv.fr/ig/fhir/sas/specifications_techniques-ps-recherche_creneaux.html)
            -   [CPTS](https://interop.esante.gouv.fr/ig/fhir/sas/specifications_techniques-cpts-recherche_creneaux.html)
            -   [SOS Médecins](https://interop.esante.gouv.fr/ig/fhir/sas/specifications_techniques-sos-recherche_creneaux.html)
        )
        verifies_requirements 'agg-psindiv@4', 'agg-psindiv@26', 'agg-psindiv@27', 'agg-psindiv@28', 'agg-psindiv@29', 'agg-psindiv@30'

        input_order :base_url, :mTLS, :practitioner_id, :practitioner_id2, :practitioner_id3, :practitioner_id4

        group from: :performance_group

        group from: :slot_group

        group from: :single_practitioner_single_location

        group from: :multi_lieux_group

        group from: :search_multiple_ps_group

        group from: :practi_optionnel_group_ps

        group from: :optionslots_group
            
        group from: :single_practitioner_multiple_cpts,
            required_suite_options: SASOptions::IG_REQUIREMENT_CPTS

        group from: :orga_optionnel_group,
            required_suite_options: SASOptions::IG_REQUIREMENT_CPTS
    end
end