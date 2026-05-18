module SasTestKit
    module SinglePractitionerMultipleCPTS
        class ValidateServiceTypeHealthcareServiceRef < Inferno::Test
            title 'Vérification de la cohérence des références serviceType -> HealthcareService'
            id :cpts_validate_service_type_healthcare_service_ref
            description %(
                Ce test vérifie que chaque ressource Slot possède un champ
                serviceType.extension.valueReference.reference pointant vers une ressource HealthcareService présente dans le Bundle.
            )

            run do
                bundle = scratch[:Bundle]
                skip "Le test d'initialisation doit être validé pour évaluer ce test" if (!bundle.present?)

                serviceType = scratch[:serviceType]
                assert(!serviceType.empty?, "Aucun champ serviceType trouvé dans les Slots du Bundle")

                healthcareServices = scratch[:healthcareServices]
                assert(!healthcareServices.empty?, "Aucune ressource HealthcareService trouvé dans le Bundle")

                healthcareServiceRefs = healthcareServices.map do |hs|
                    "HealthcareService/#{hs['element'].id}"
                end
             
                valid_service_type = serviceType.any? do |st|
                    codable = st['element']

                    extensions = codable.extension || []

                    extensions.any? do |ext|
                    url = ext.url
                    ref = ext.valueReference&.reference

                    url&.strip == "http://hl7.org/fhir/5.0/StructureDefinition/extension-Slot.serviceType" &&
                    healthcareServiceRefs.include?(ref)
                    end
                end
                
                all_extensions = serviceType.flat_map do |st|
                    codable = st['element']

                    (codable.extension || []).map do |ext|
                    {
                        url: (ext.url || ext['url']),
                        reference: ext.valueReference&.reference
                    }
                    end
                end
                
                error_message = %(
                    Aucune extension serviceType valide trouvée

                    - **URL attendue** :
                    http://hl7.org/fhir/5.0/StructureDefinition/extension-Slot.serviceType

                    - **Références HealthcareService attendues** :
                    #{healthcareServiceRefs}

                    - **Extensions trouvées dans les serviceType** :
                    #{all_extensions.empty? ? "Aucune extension présente" : all_extensions}

                    - **Problème** :
                    #{all_extensions.empty? ?
                        "Aucune extension n'est présente dans les serviceType." :
                        "Les extensions présentes ne contiennent pas de référence valide vers un HealthcareService du Bundle."}
                )

                assert(valid_service_type, error_message)
            end
        end
    end
end