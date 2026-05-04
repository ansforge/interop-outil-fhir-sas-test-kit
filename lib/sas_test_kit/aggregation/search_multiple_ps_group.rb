require_relative 'setup_test'

require_relative 'search_multiple_ps_tests/ps_validate_practitioner_cardinality_test'
require_relative 'search_multiple_ps_tests/ps_validate_practitionerrole_cardinality_test'
require_relative 'search_multiple_ps_tests/ps_validate_schedule_cardinality_test'

module SasTestKit
    module SearchMultiplePs
        class SearchMultiplePs < Inferno::TestGroup
            title 'Recherche multi-PS'
            description %(
                Ce groupe réalise une série de vérifications sur le **Bundle de réponse** renvoyé par le **flux Agrégateur - recherche de créneaux**, dans le cas où **plusieurs professionnels de santé** peuvent être retournés pour une même requête.  
                Ces contrôles visent à garantir la conformité des données fournies selon les profils et règles définis dans les spécifications SAS.

                Les tests de ce groupe portent notamment sur :
                - la **présence attendue de plusieurs Practitioner**, chacun correspondant à un RPPS distinct fourni en entrée ;
                - la **présence d'au moins deux PractitionerRole**, reflétant les rôles d'exercice des PS remontés ;
                - la présence d'**au moins deux Schedule**, conformément au retour de disponibilités associées à chacun des PS.

                Ce groupe complète les contrôles réalisés pour le cas « PS avec un seul lieu », en s'assurant que le serveur gère correctement les **scénarios multi-correspondances** dans le flux Agrégateur.
            )
            id :search_multiple_ps_group
            input :practitioner_id3,
                title: 'RPPS',
                description: "Renseigner le RPPS (préfixé par 8) d'un PS pouvant être remonté dans une même recherche que celui ci-dessous"

            input :practitioner_id4,
                title: 'RPPS',
                description: "Renseigner le RPPS (préfixé par 8) d'un PS pouvant être remonté dans une même recherche que celui ci-dessus"
            
            test from: :slot_search_setup do
                config(
                    inputs: { 
                        practitioner_id: { name:  :practitioner_id3},
                        practitioner_id_opt: { name: :practitioner_id4, hidden: false }
                    }
                )
            end

            test from: :validate_practitioner_cardinality_2

            test from: :validate_practitionerrole_cardinality_2

            test from: :validate_schedule_cardinality_2
        end
    end
end
