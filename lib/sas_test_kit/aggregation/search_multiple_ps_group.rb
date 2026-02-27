require_relative 'setup_test'

module MyTestKit
    class SearchMultiplePsGroup < Inferno::TestGroup
        title 'Recherche multiple - PS'
        description 'Contrôles sur le Bundle de réponse - champs obligatoires'
        id :search_multiple_ps_group
        input :practitioner_id3,
            title: 'RPPS',
            description: "Renseigner les RPPS (préfixé par 8) d'un PS pouvant être remonté dans une même recherche que celui ci-dessous"

        input :practitioner_id4,
            title: 'RPPS',
            description: 'Renseigner les RPPS (préfixé par 8) un PS pouvant être remonté dans une même recherche que celui ci-dessus'
        
        test from: :slot_search_setup do
            config(
                inputs: { 
                    practitioner_id: { name:  :practitioner_id3},
                    practitioner_id_opt: { name: :practitioner_id4, hidden: false }
                }
            )
        end

        test do
            title 'Vérification présence de deux Practitioner'
            description %(
             Le Bundle de réponse doit contenir deux ressources Practitioner
            )
            run do
                scratch[:practitioners] = evaluate_fhirpath(resource: scratch[:Bundle], path: 'entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrPractitionerAgregateur").resource')
                assert(scratch[:practitioners].length == 2, "Le Bundle doit contenir exactement deux ressources Practitioner, en a #{scratch[:practitioners].length}")
            end
        end

        test do
            title 'Vérification présence de au moins deux PractitionerRole'
            description %(
             Le Bundle de réponse doit contenir au moins deux ressources PractitionerRole
            )
            run do
                scratch[:practitioner_roles] = evaluate_fhirpath(resource: scratch[:Bundle], path: 'entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrPractitionerRoleExerciceAgregateur").resource')
                assert(scratch[:practitioner_roles].length >= 2, "Le Bundle doit contenir au moins deux ressources PractitionerRole, en a #{scratch[:practitioner_roles].length}")
            end
        end

        test do
            title 'Vérification présence de au moins deux Schedule'
            description %(
             Le Bundle de réponse doit contenir au moins deux ressources Schedule
            )
            run do
                scratch[:schedules] = evaluate_fhirpath(resource: scratch[:Bundle], path: 'entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrScheduleAgregateur").resource')
                assert(scratch[:schedules].length >= 2, "Le Bundle doit contenir au moins deux ressources Schedule, en a #{scratch[:schedules].length}")
            end
        end
    end
end
