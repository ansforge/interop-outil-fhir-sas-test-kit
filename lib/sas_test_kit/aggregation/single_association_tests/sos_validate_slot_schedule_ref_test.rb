module SasTestKit
    module SingleAssociation
        class ValidateSlotScheduleRef < Inferno::Test
            title "Vérification de la référence à un Schedule dans les ressources Slot"
            id :validate_slot_schedule_ref
            description %(
                Ce test réalise une vérification de la **présence d'une référence à une ressource Schedule existante** dans les ressources Slot du Bundle de réponse.
            )
                
            run do
                skip "Le test d'initialisation doit être validé pour évaluer ce test" if (!scratch[:Bundle].present?)

                schedules = scratch[:schedules]
                slots = evaluate_fhirpath(resource: scratch[:Bundle], path: 'entry.where(resource.meta.profile="https://interop.esante.gouv.fr/ig/fhir/sas/StructureDefinition/sas-sos-slot-aggregator").resource')

                assert(schedules.length >= 1, "Le Bundle doit contenir au moins une ressource Schedule, il en possède #{scratch[:locations].length}")

                schedule_ids = []
                schedules.each do |schedule|
                    schedule_ids << "Schedule/#{schedule['element'].id}"
                end

                slots.each do |slot|
                    slot = slot['element']
                    assert(slot.schedule.present?, "La ressource Slot #{slot.id} ne contient pas de référence")

                    reference = slot.schedule.reference
                    assert(schedule_ids.include?(reference), "La ressource Slot #{slot.id} référence un Schedule qui n'existe pas dans le Bundle")
                end
            end
        end
    end
end