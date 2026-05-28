require_relative 'single_practitioner_multiple_cpts/two_slot_two_cpts_group'
require_relative 'single_practitioner_multiple_cpts/single_slot_two_cpts_group'

module SasTestKit
    module SinglePractitionerMultipleCPTS
        class SinglePractitionerMultipleCPTS < Inferno::TestGroup
            title 'Validation des cas multi-CPTS pour un même praticien'
            id :single_practitioner_multiple_cpts
            verifies_requirements 'agg-psindiv@4', 'agg-psindiv@26', 'agg-psindiv@27', 'agg-psindiv@28', 'agg-psindiv@29', 'agg-psindiv@30'
            description %(
                Ce groupe de tests vérifie la conformité des ressources retournées lorsqu'un même praticien
                est associé à plusieurs CPTS.

                Deux scénarios sont couverts :
                - plusieurs Slots distincts associés chacun à une CPTS différente
                - un même Slot partagé entre plusieurs CPTS

                Les tests valident notamment :
                - la conformité des ressources Slot (meta.security, serviceType)
                - la cohérence des références vers les HealthcareService
                - la cohérence des références vers les Organization (CPTS)
            )

            input_order :base_url, :mTLS, :practitioner_id

            group from: :two_slot_two_cpts

            group from: :single_slot_two_cpts
        end
    end
end