module SasTestKit
    module SinglePractitionerMultipleCPTS
        class ValidateServiceType < Inferno::Test
            title 'Validation du serviceType des Slots'
            id :cpts_validate_service_type
            description %(
                Ce test vérifie que chaque ressource Slot possède un champ
                serviceType.coding contenant : 
                -   system : https://mos.esante.gouv.fr/NOS/TRE_R66-CategorieEtablissement/FHIR/TRE-R66-CategorieEtablissement
                -   code   : 604
            )

            run do
                bundle = scratch[:Bundle]
                skip "Le test d'initialisation doit être validé pour évaluer ce test" if (!bundle.present?)

                serviceType = evaluate_fhirpath(resource: bundle, path: 'entry.where(resource.meta.profile="https://interop.esante.gouv.fr/ig/fhir/sas/StructureDefinition/sas-cpts-slot-aggregator").resource.serviceType')
                scratch[:serviceType] = serviceType

                assert(serviceType.length > 0, "Aucun champ serviceType n'est présent dans les slots du bundle")
                valid_service_type = serviceType.any? do |st|
                    codings = st['element'].coding || []

                    codings.any? do |c|
                        c.system == 'https://mos.esante.gouv.fr/NOS/TRE_R66-CategorieEtablissement/FHIR/TRE-R66-CategorieEtablissement' &&
                        c.code == '604'
                    end
                end

                all_codings = serviceType.flat_map do |st|
                    st['element'].coding || []
                end
 
                system_error = %(
                Lecture du champ serviceType.coding :

                - **Résultat attendu** :
                    - system : https://mos.esante.gouv.fr/NOS/TRE_R66-CategorieEtablissement/FHIR/TRE-R66-CategorieEtablissement
                    - code : 604

                - **Résultat obtenu** :
                    #{all_codings.map { |c| "{system: #{c.system}, code: #{c.code}}" }}
                )

                assert(valid_service_type, system_error)
            end
        end
    end
end