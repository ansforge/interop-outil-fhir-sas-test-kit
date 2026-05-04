module SasTestKit
    module MultiLieux
        class ValidateSchedulePractitionerRoleRef < Inferno::Test
            title 'Vérification de la cohérence des références Schedule -> PractitionerRole'
            id :validate_schedule_practitionerrole_ref
            description %(
                ## Description

                Ce test valide que chaque ressource `Schedule` **référence uniquement des PractitionerRole présents** dans le Bundle.  
                Toutes les références `Schedule.actor.reference` de type `PractitionerRole/<id>` doivent correspondre à l'un des PractitionerRole retournés.
            )
            run do
                skip %(Les tests **4.5.03** et **4.5.04** doivent être validés pour évaluer ce test) if (!scratch[:practitioner_roles].present? && !scratch[:schedules].present?)
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
    end
end