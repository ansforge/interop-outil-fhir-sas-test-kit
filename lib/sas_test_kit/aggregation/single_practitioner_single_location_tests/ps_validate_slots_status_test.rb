require_relative '../../sas_options.rb'

module SasTestKit
    module SinglePractitionerSingleLocation
        class ValidateStatus < Inferno::Test
            title "Vérification de la valeur de l'élément 'status' des ressources Slot"
            id :ps_validate_slots_status
            description %(
                Ce test vérifie que les ressources Slot retournées dans le Bundle possèdent
                un champ `status` correctement renseigné avec la valeur `free`.
            )
            verifies_requirements 'agg-psindiv@10'
            run do
                bundle = scratch[:Bundle]
                skip "Le test d'initialisation doit être validé pour évaluer ce test" unless (bundle.present?)
                
                slot_profile_url = ""
                case config.options[:launch_version]
                when 'ig_launch_1'
                    slot_profile_url = 'http://sas.fr/fhir/StructureDefinition/FrSlotAgregateur'
                when 'ig_launch_2'
                    slot_profile_url = 'https://interop.esante.gouv.fr/ig/fhir/sas/StructureDefinition/sas-cpts-slot-aggregator'
                when 'ig_launch_3'
                    slot_profile_url = 'https://interop.esante.gouv.fr/ig/fhir/sas/StructureDefinition/sas-sos-slot-aggregator'
                end
                SlotsStatus = evaluate_fhirpath(resource: bundle, path: 'entry.where(resource.meta.profile="' + slot_profile_url + '").resource.status')   

                for slot in SlotsStatus
                    add_message('info', "Status du slot: " + slot["element"].to_s)
                    assert((slot["element"] == "free"), "le status des slots retourné doit être égal à free")
                end
            end
        end
    end
end