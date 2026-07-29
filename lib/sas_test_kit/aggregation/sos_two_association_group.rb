require_relative 'two_association_tests/sos_validate_organization_cardinality_2_test'
require_relative 'two_association_tests/sos_validate_location_cardinality_3_test'
require_relative 'two_association_tests/sos_validate_schedule_cardinality_3_test'
require_relative 'single_association_tests/sos_validate_location_organization_ref_test'
require_relative 'single_association_tests/sos_validate_schedule_location_ref_test'
require_relative 'single_association_tests/sos_validate_slot_schedule_ref_test'
require_relative 'single_association_tests/sos_validate_organization_name_test'
require_relative 'single_association_tests/sos_validate_location_name_test'
require_relative 'single_association_tests/sos_validate_location_adresse_test'
require_relative 'single_association_tests/sos_validate_location_phone_test'
require_relative 'single_association_tests/sos_validate_location_idnst_test'
require_relative 'single_association_tests/sos_validate_slots_status_test'
require_relative 'single_association_tests/sos_validate_slots_dates_test'
require_relative 'single_association_tests/sos_validate_slots_meta_security_test'
require_relative 'single_association_tests/sos_validate_slots_appointmentType_test'
require_relative 'single_association_tests/sos_validate_slots_serviceType_test'
require_relative 'single_association_tests/sos_validate_slots_comment_test'
require_relative 'single_association_tests/sos_validate_bundle_link_test'

module SasTestKit
    module TwoAssociation
        class TwoAssociation < Inferno::TestGroup
            title 'Deux associations'
            id    :two_association
            description %(
            ## Description
            Ce groupe de tests vérifie la conformité d'une recherche de créneaux réalisée pour deux associations.
            )

            input_order :base_url, :mTLS

            test from: :slot_search_setup do
                config(
                    inputs: { 
                        practitioner_id: { name:  :siret},
                        practitioner_id_opt: { name: :siret_2, hidden: false }
                    }
                )
            end

            test from: :sos_validate_organization_cardinality_2

            test from: :sos_validate_location_cardinality_3

            test from: :sos_validate_schedule_cardinality_3

            test from: :validate_location_organization_ref

            test from: :validate_schedule_location_ref

            test from: :validate_slot_schedule_ref

            test from: :sos_validate_organization_name
            
            test from: :sos_validate_location_name

            test from: :validate_location_adresse

            test from: :validate_location_phone

            test from: :sos_validate_location_idnst

            test from: :sos_validate_slots_status

            test from: :sos_validate_dates

            test from: :sos_validate_meta

            test from: :sos_validate_slots_appointmentType

            test from: :sos_validate_serviceType

            test from: :sos_validate_slots_comment

            test from: :sos_validate_bundle_link
        end
    end
end