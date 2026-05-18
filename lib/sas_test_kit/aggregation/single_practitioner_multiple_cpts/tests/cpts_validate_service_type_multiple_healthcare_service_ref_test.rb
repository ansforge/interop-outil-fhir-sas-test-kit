module SasTestKit
    module SinglePractitionerMultipleCPTS
        class ValidateServiceTypeMultipleHealthcareServiceRef < Inferno::Test
            title 'Vérification de la cohérence des références serviceType -> HealthcareService'
            id :cpts_validate_service_type_multiple_healthcare_service_ref
            description %(
                Ce test vérifie que chaque ressource Slot possède deux champ
                serviceType.extension.valueReference.reference pointant vers deux ressources HealthcareService présente dans le Bundle.
            )

            run do
                bundle = scratch[:Bundle]
                skip "Le test d'initialisation doit être validé pour évaluer ce test" unless bundle.present?

                slots = evaluate_fhirpath(
                    resource: bundle,
                    path: 'entry.where(resource.meta.profile="https://interop.esante.gouv.fr/ig/fhir/sas/StructureDefinition/sas-cpts-slot-aggregator").resource'
                )

                healthcareServices = evaluate_fhirpath(
                    resource: bundle,
                    path: 'entry.where(resource.meta.profile="https://interop.esante.gouv.fr/ig/fhir/sas/StructureDefinition/sas-cpts-healthcareservice-aggregator").resource'
                )

                healthcareServiceRefs = healthcareServices.map do |hs|
                    "HealthcareService/#{hs['element'].id}"
                end

                valid_slot_found = false
                debug_slots = []

                slots.each do |slot|
                    service_types = slot['element'].serviceType || []

                    refs = service_types.flat_map do |st|
                    extensions = st.extension || st['extension'] || []

                    extensions.map do |ext|
                        if ext.url == "http://hl7.org/fhir/5.0/StructureDefinition/extension-Slot.serviceType"
                        ext.valueReference&.reference
                        end
                    end
                    end.compact

                    distinct_refs = refs.uniq

                    debug_slots << {
                    slot_id: slot['element'].id,
                    refs: refs,
                    distinct: distinct_refs
                    }

                    if distinct_refs.length >= 2 &&
                    refs.all? { |r| healthcareServiceRefs.include?(r) }
                    valid_slot_found = true
                    end
                end
              
                formatted_slots = debug_slots.map do |slot|
                "   - **Slot** #{slot[:slot_id]}\r" +
                "**Références trouvées** : #{slot[:refs].empty? ? "Aucune" : slot[:refs].join(', ')}\r" +
                "**Références distinctes** : #{slot[:distinct].join(', ')}"
                end.join("\r\r")

                error_message = %(
                    Aucun Slot ne référence au moins deux HealthcareService distincts

                    - **HealthcareService attendus** :
                    #{healthcareServiceRefs}

                    - **Analyse par Slot** : 
                    #{formatted_slots}

                    - **Problème** :
                    Aucun Slot ne contient au moins 2 références distinctes vers des HealthcareService valides.
                )

                assert(valid_slot_found, error_message)
            end
        end
    end
end