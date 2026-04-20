require_relative 'setup_test'

module SasTestKit
    class MultiLieuGroupPS < Inferno::TestGroup
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
            title "Vérification de la présence d'une seule ressource Practitioner"
            description %(
                ## Description

                Ce test vérifie que le Bundle de réponse contient **exactement une** ressource *Practitioner*, correspondant au RPPS fourni en entrée.  
                Cette cardinalité est attendue même dans le cas d'un PS exerçant sur plusieurs lieux.
            )
            run do
                scratch[:practitioner] = evaluate_fhirpath(resource: scratch[:Bundle], path: 'entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrPractitionerAgregateur").resource')
                assert(scratch[:practitioner].length == 1, "Le Bundle doit contenir exactement une ressource Practitioner, en a #{scratch[:practitioner].length}")
            end
        end

        test do
            title 'Vérification de la présence de deux ressources PractitionerRole'
            description %(
                ## Description

                Ce test vérifie la présence de **deux ressources PractitionerRole**, chacune représentant un lieu d'exercice différent du même professionnel de santé.  
                Le Bundle doit contenir **exactement deux** ressources *FrPractitionerRoleExerciceAgregateur*.
            )
            run do
                scratch[:practitioner_roles] = evaluate_fhirpath(resource: scratch[:Bundle], path: 'entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrPractitionerRoleExerciceAgregateur").resource')
                assert(scratch[:practitioner_roles].length == 2, "Le Bundle doit contenir exactement deux ressources PractitionerRole, en a #{scratch[:practitioner_roles].length}")
            end
        end

        test do
            title 'Vérification de la présence de deux ressources Schedule'
            description %(
                ## Description

                Ce test confirme que le Bundle contient **exactement deux** ressources `Schedule`, chacune associée à un lieu d'exercice distinct.  
                Cette cardinalité reflète les disponibilités propres à chaque lieu.
            )
            run do
                scratch[:schedules] = evaluate_fhirpath(resource: scratch[:Bundle], path: 'entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrScheduleAgregateur").resource')
                assert(scratch[:schedules].length == 2, "Le Bundle doit contenir exactement deux ressources Schedule, en a #{scratch[:schedules].length}")
            end
        end

        test do
            title 'Vérification de la cohérence des références PractitionerRole -> Practitioner'
            description %(
                # Description

                Ce test vérifie que chacun des deux `PractitionerRole` **référence le Practitioner unique** présent dans le Bundle.  
                Toutes les relations `PractitionerRole.practitioner.reference` doivent pointer vers le même identifiant `Practitioner/<id>`.
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
            title 'Vérification de la cohérence des références Schedule -> PractitionerRole'
            description %(
                ## Description

                Ce test valide que chaque ressource `Schedule` **référence uniquement des PractitionerRole présents** dans le Bundle.  
                Toutes les références `Schedule.actor.reference` de type `PractitionerRole/<id>` doivent correspondre à l'un des PractitionerRole retournés.
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
            title 'Vérification de la cohérence des références Schedule -> Practitioner'
            description %(
                ## Description

                Ce test confirme que chaque ressource `Schedule` **référence le Practitioner attendu**.  
                Chaque `Schedule.actor.reference` de type `Practitioner/<id>` doit correspondre exactement au `Practitioner` unique du Bundle.
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
            title 'Vérification de la cohérence des références PractitionerRole -> Location'
            description %(
                ## Description

                Ce test vérifie la cohérence entre les `PractitionerRole` et leurs `Location` respectives.  
                Chaque `PractitionerRole.location.reference` doit référencer une ressource `Location` contenue (`#<id>`), et chaque Location contenue doit correspondre à l'un des lieux d'exercice du PS.
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