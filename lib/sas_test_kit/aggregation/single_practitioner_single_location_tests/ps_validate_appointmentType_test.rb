module SasTestKit
    module SinglePractitionerSingleLocation
        class ValidateAppointmentType < Inferno::Test
            title 'Vérification de l\'appointmentType des créneaux'
            id :ps_validate_appointmentType
            description %(
                Ce test vérifie que les ressources Slot retournées dans le Bundle possèdent
                un champ `appointmentType` correctement renseigné avec un code conforme.
            )
            verifies_requirements 'agg-psindiv@49'

            run do
                bundle = scratch[:Bundle]
                skip "Le test d'initialisation doit être validé pour évaluer ce test" if (!bundle.present?)
                SLOT_PROFILE_URL = suite_options[:launch_version] == 'ig_launch_1' ? 'http://sas.fr/fhir/StructureDefinition/FrSlotAgregateur' : 'https://interop.esante.gouv.fr/ig/fhir/sas/StructureDefinition/sas-cpts-slot-aggregator'

                appointmentType = evaluate_fhirpath(resource: bundle, path: "entry.where(resource.meta.profile='#{SLOT_PROFILE_URL}').resource.appointmentType.coding.code.distinct()")   
                add_message('info', "appointmentType des créneaux retournés: " + appointmentType.to_s) 
            
                for appointmentTypeCode in appointmentType
                    assert((appointmentTypeCode["element"] == "ROUTINE" || appointmentTypeCode["element"] == "WALKIN"), "Le code de l'appointmentType doit être égal à l'une des valeurs suivantes : ROUTINE ou WALKIN")
                end
            end
        end
    end
end