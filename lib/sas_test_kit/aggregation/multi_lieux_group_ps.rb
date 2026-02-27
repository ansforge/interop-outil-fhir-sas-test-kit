require_relative 'setup_test'

module MyTestKit
    class MultiLieuGroupPS < Inferno::TestGroup
        title 'Contrôles Bundle - PS avec deux lieux de consultation'
        description 'Contrôles sur le Bundle de réponse - champs obligatoires'
        id :multiLieu_group_ps

        input :practitioner_id2,
            title: 'RPPS',
            description: 'Renseigner le RPPS (préfixé par 8) d\'un PS possédant deux lieux d\'exercice',
            default: '810001678357'
        
        test from: :slot_search_setup do
            config(
                inputs: { 
                    practitioner_id: { name: :practitioner_id2 },
                }
            )
        end

        test do
            title 'Vérification présence de Practitioner'
            description %(
             Le Bundle de réponse doit contenir une ressource Practitioner
            )
            run do
                scratch[:practitioner] = evaluate_fhirpath(resource: scratch[:Bundle], path: 'entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrPractitionerAgregateur").resource')
                assert(scratch[:practitioner].length == 1, "Le Bundle doit contenir exactement une ressource Practitioner, en a #{scratch[:practitioner].length}")
            end
        end

        test do
            title 'Vérification présence de deux PractitionerRole'
            description %(
             Le Bundle de réponse doit contenir deux ressources PractitionerRole
            )
            run do
                scratch[:practitioner_roles] = evaluate_fhirpath(resource: scratch[:Bundle], path: 'entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrPractitionerRoleExerciceAgregateur").resource')
                assert(scratch[:practitioner_roles].length == 2, "Le Bundle doit contenir exactement deux ressources PractitionerRole, en a #{scratch[:practitioner_roles].length}")
            end
        end

        test do
            title 'Vérification présence de deux Schedule'
            description %(
             Le Bundle de réponse doit contenir deux ressources Schedule
            )
            run do
                scratch[:schedules] = evaluate_fhirpath(resource: scratch[:Bundle], path: 'entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrScheduleAgregateur").resource')
                assert(scratch[:schedules].length == 2, "Le Bundle doit contenir exactement deux ressources Schedule, en a #{scratch[:schedules].length}")
            end
        end

        test do
            title 'Vérification cohérence des références entre Practitioner et PractitionerRole'
            description %(
             Les deux ressources PractitionerRole doivent référencer le practitioner du Bundle.
             )
            run do
                practitioner = scratch[:practitioner]
                practitioner_roles = scratch[:practitioner_roles]
                practitioner_roles.each do |pr|
                    assert(pr['element'].practitioner.reference == "Practitioner/#{practitioner[0]['element'].id}", "Le PractitionerRole doit référencer le Practitioner présent dans le Bundle : #{pr['element'].practitioner.reference} vs Practitioner/#{practitioner[0]['element'].id}")
                end
            end
        end
                
        test do
            title 'Vérification cohérence des références entre PractitionerRole et Schedule'
            description %(
             Les ressources Schedule doivent référencer des PractitionerRole présents dans le Bundle.
             )
            run do
                practitioner_roles = scratch[:practitioner_roles]
                schedules = scratch[:schedules]
                schedules.each do |s|
                    schedule_refs = s['element'].actor.select { |actor| actor.reference.start_with?('PractitionerRole/') }.map { |actor| actor.reference }
                    schedule_refs.each do |schedule_ref|
                        assert(practitioner_roles.any? { |pr| pr['element'].id == schedule_ref.split('/').last }, "Chaque PractitionerRole référencé par un Schedule doit être présent dans le Bundle")
                    end
                end
            end
        end

        test do
            title 'Vérification cohérence des références entre Practitioner et Schedule'
            description %(
             Le Practitioner référencé par un Schedule doit être le même que celui du Bundle.
             )
            run do
                practitioner = scratch[:practitioner]
                schedules = scratch[:schedules]
                schedules.each do |s|
                    schedule_pract_ref = s['element'].actor.select { |actor| actor.reference.start_with?('Practitioner/') }.map { |actor| actor.reference }
                    assert(schedule_pract_ref.length == 1, "Un Schedule doit référencer exactement un Practitioner")
                    assert(schedule_pract_ref[0] == "Practitioner/#{practitioner[0]['element'].id}", "Le Practitioner référencé par le Schedule doit être le même que celui du Bundle : Practitioner/#{practitioner[0]['element'].id} vs #{schedule_pract_ref[0]}")
                end
            end
        end

        test do
            title 'Vérification cohérence des références entre PractitionerRole et Location'
            description %(
             Les deux ressources PractitionerRole doivent référencer leurs lieux d'exercices.
             )
            run do
                practitioner_roles = scratch[:practitioner_roles]
                locations = practitioner_roles.map { |pr| pr['element'].location.map { |loc| loc.reference } }.flatten
                location_ids = practitioner_roles.map { |pr| pr['element'].contained.select { |res| res.resourceType == 'Location' }.map { |loc| loc.id } }.flatten
                add_message('info', "Lieux référencés : #{locations} / Lieux contenus : #{location_ids}")
                locations.each_with_index do |loc_ref, i|
                    assert('#' + location_ids[i] == loc_ref, "Le lieu d'exercice référencé par le PractitionerRole doit correspondre à la ressource Location contenue dans contained")
                end
            end
        end
    end
end