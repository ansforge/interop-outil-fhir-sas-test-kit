require_relative 'setup_test'

require_relative 'multi_lieux_tests/ps_validate_practitioner_cardinality_test'
require_relative 'multi_lieux_tests/ps_validate_practitionerrole_cardinality_test'
require_relative 'multi_lieux_tests/ps_validate_schedule_cardinality_test'
require_relative 'multi_lieux_tests/ps_validate_practitionerrole_practitioner_ref_test'
require_relative 'multi_lieux_tests/ps_validate_schedule_practitionerrole_ref_test'
require_relative 'multi_lieux_tests/ps_validate_schedule_practitioner_ref_test'
require_relative 'multi_lieux_tests/ps_validate_practitionerrole_location_ref_test'

module SasTestKit
    module MultiLieu
        class MultiLieu < Inferno::TestGroup
            title 'PS avec deux lieux de consultation'
            description %(
                ## Description

                Ce groupe réalise une série de vérifications sur le **Bundle de réponse** renvoyé par le **flux Agrégateur - recherche de créneaux**, dans le cas où un professionnel de santé (PS) possède **deux lieux d'exercice**.  
                L'objectif est de confirmer que le serveur respecte les profils SAS et les règles de cohérence attendues pour ce cas particulier.

                Les contrôles portent notamment sur :
                - la présence d'un **unique Practitioner** correspondant au RPPS demandé ;
                - la présence de **deux PractitionerRole**, chacun associé à l'un des lieux d'exercice ;
                - la présence de **deux Schedule**, reflétant les disponibilités distinctes des deux lieux ;
                - la **cohérence des références** entre Practitioner, PractitionerRole, Schedule et Location ;
                - la conformité des liens entre les PractitionerRole et leurs **Locations contenues**.

                Ces tests permettent de valider que le serveur gère correctement les PS multi-lieux dans le flux Agrégateur.
            )
            id :multi_lieux_group

            verifies_requirements   'agg-psindiv@4', 'agg-psindiv@21', 'agg-psindiv@22', 'agg-psindiv@26', 'agg-psindiv@27', 'agg-psindiv@28',
                                    'agg-psindiv@29', 'agg-psindiv@30'

            input :practitioner_id2,
                title: 'RPPS',
                description: 'Renseigner le RPPS (préfixé par 8) d\'un PS possédant deux lieux d\'exercice'

            input_order :base_url, :mTLS, :practitioner_id2
            
            test from: :slot_search_setup do
                config(
                    inputs: { 
                        practitioner_id: { name: :practitioner_id2 },
                    }
                )
            end

            test from: :validate_practitioner_cardinality_1

            test from: :validate_practitionerrole_cardinality_1

            test from: :validate_schedule_cardinality_1

            test from: :validate_practitionerrole_practitioner_ref
                    
            test from: :validate_schedule_practitionerrole_ref

            test from: :validate_schedule_practitioner_ref

            test from: :validate_practitionerrole_location_ref
        end
    end
end