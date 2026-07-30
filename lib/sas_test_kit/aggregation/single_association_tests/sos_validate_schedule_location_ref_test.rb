module SasTestKit
    module SingleAssociation
        class ValidateScheduleLocationRef < Inferno::Test
            title "Vérification de la référence à une location dans les ressource Schedule"
            id :validate_schedule_location_ref
            description %(
                Ce test réalise une vérification de la **présence d'une référence à une ressource Location existante** dans les ressource Schedule du Bundle de réponse.
            )
                
            run do
                skip "Le test d'initialisation doit être validé pour évaluer ce test" if (!scratch[:Bundle].present?)
                assert(scratch[:locations].length >= 1, "Le Bundle doit contenir au moins une ressource Location, il en possède #{scratch[:locations].length}")
                assert(scratch[:schedules].length >= 1, "Le Bundle doit contenir au moins une ressource Schedule, il en possède #{scratch[:schedules].length}")

                schedules = scratch[:schedules]
                locations = scratch[:locations]

                location_ids = []
                locations.each do |location|
                    location_ids << "Location/#{location['element'].id}"
                end

                schedules.each do |schedule|
                    schedule = schedule['element']
                    assert(schedule.actor.present?, "La ressource Schedule #{schedule.id} ne contient pas de référence")

                    reference = schedule.actor.first.reference
                    assert(location_ids.include?(reference), "La ressource Schedule #{schedule.id} référence une location qui n'existe pas dans le Bundle")
                end
            end
        end
    end
end