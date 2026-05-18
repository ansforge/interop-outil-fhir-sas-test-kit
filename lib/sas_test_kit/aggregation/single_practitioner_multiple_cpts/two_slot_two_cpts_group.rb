require_relative '../setup_test'

require_relative 'tests/cpts_validate_organization_cardinality_test'
require_relative 'tests/cpts_validate_healthcare_service_cardinality_test'
require_relative 'tests/cpts_validate_meta_test'
require_relative 'tests/cpts_validate_service_type_test'
require_relative 'tests/cpts_validate_service_type_healthcare_service_ref_test'
require_relative 'tests/cpts_validate_healthcare_service_organization_ref_test'

module SasTestKit
    module SinglePractitionerMultipleCPTS
        class TwoSlotTwoCPTS < Inferno::TestGroup
            title 'Validation de Slots associés à deux CPTS distinctes'
            id :two_slot_two_cpts
            description %(
                Ce groupe de tests vérifie la conformité des ressources retournées lorsqu'un practicien possède plusieurs créneaux
                associés à des CPTS distinctes.

                Avant d'effectuer ces tests assurez vous que vous renseignez un practicien avec le paramétrage suivant :
                - le praticien est associé à au moins deux CPTS différentes
                - Il doit avoir au moinsun créneau mit en visibilité d'une CPTS A et au moins un autre créneau mit en visibilité d'une CPTS B
                - Ne pas lui associer d'autres créneaux hors CPTS

                Les tests valident notamment :
                - la conformité des ressources Slot (meta.security, serviceType)
                - la cohérence des références vers les HealthcareService
                - la cohérence des références vers les Organization (CPTS)
            )

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

            test from: :cpts_validate_service_type_healthcare_service_ref

            test from: :cpts_validate_healthcare_service_organization_ref
        end
    end
end