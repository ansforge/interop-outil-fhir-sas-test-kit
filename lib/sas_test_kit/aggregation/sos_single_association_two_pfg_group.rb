require_relative 'single_association_tests/sos_validate_organization_cardinality_test'
require_relative 'single_association_tests/sos_validate_location_cardinality_2_test'
require_relative 'single_association_tests/sos_validate_organization_siret_test'
require_relative 'single_association_tests/sos_validate_bundle_test'
require_relative 'single_association_tests/sos_validate_location_organization_ref_test'
require_relative 'single_association_tests/sos_validate_schedule_cardinality_2_test'
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
    module SingleAssociation
        class SingleAssociationTwoPFG < Inferno::TestGroup
            title 'Deux points fixes de garde'
            description %(
            ## Description
            Ce groupe de tests vérifie la conformité d'une recherche de créneaux réalisée pour une association disposant d'un unique Point Fixe de Garde (PFG).
            À partir du SIRET fourni, les tests contrôlent la structure de la réponse, la présence et la cardinalité des ressources attendues
            (Organization, Location et Schedule), la validité du SIRET de l'association, la cohérence des références entre les ressources, la présence des
            informations d'adresse du PFG ainsi que le statut des créneaux retournés.
            ### Prérequis
            Il est donc nécessaire pour ce scénario de test de renseigner des disponibilités pour une association sur deux PFG.
            )
            id :single_association_two_pfg

            input :siret, 
                title: "SIRET de l'association",
                type: 'text',
                description: "SIRET d'une association contenant des disponibilités sur deux PFG pour la recherche de créneaux",
                optional: true,
                hidden: true

            input :siret_2, 
                title: "SIRET de l'association",
                type: 'text',
                description: "SIRET d'une association contenant des disponibilités sur deux PFG pour la recherche de créneaux"

            input_order :base_url, :mTLS, :siret
      
            run_as_group
            
            test from: :slot_search_setup do
                config(
                    inputs: { 
                        practitioner_id: { name: :siret_2 }
                    }
                )
            end

            test from: :validate_bundle

            test from: :validate_organization_cardinality

            test from: :sos_validate_location_cardinality_2

            test from: :sos_validate_schedule_cardinality_2

            test from: :validate_organization_siret,
                config: {
                    inputs: {
                        siret_n: { name: :siret_2}
                    }
                }

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