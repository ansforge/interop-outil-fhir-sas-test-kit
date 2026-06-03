module SasTestKit
    module MultiLieux
        class ValidateSchedulePractitionerRef < Inferno::Test
            title 'Vérification de la cohérence des références Schedule -> Practitioner'
            id :validate_schedule_practitioner_ref
            description %(
                ## Description

                Ce test confirme que chaque ressource `Schedule` **référence le Practitioner attendu**.  
                Chaque `Schedule.actor.reference` de type `Practitioner/<id>` doit correspondre exactement au `Practitioner` unique du Bundle.
            )
            verifies_requirements 'agg-psindiv@43'
            run do
                skip %(Les tests **4.5.02** et **4.5.04** doivent être validés pour évaluer ce test) if (!scratch[:practitioner].present? && !scratch[:schedules].present?)
                practitioner = scratch[:practitioner]
                schedules = scratch[:schedules]
                schedules.each do |s|
                    schedule_pract_ref = s['element'].actor.select { |actor| actor.reference.start_with?('Practitioner/') }.map { |actor| actor.reference }
                    assert(schedule_pract_ref.length == 1, "Un Schedule doit référencer exactement un Practitioner")
                    assert(schedule_pract_ref[0] == "Practitioner/#{practitioner[0]['element'].id}", "Le Practitioner référencé par le Schedule doit être le même que celui du Bundle : Practitioner/#{practitioner[0]['element'].id} vs #{schedule_pract_ref[0]}")
                end
            end
        end
    end
end