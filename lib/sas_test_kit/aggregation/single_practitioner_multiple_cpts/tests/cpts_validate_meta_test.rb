module SasTestKit
    module SinglePractitionerMultipleCPTS
        class ValidateMeta < Inferno::Test
            title 'Vérification de la présence du code CPTS dans les Slots'
            id :cpts_validate_meta
            description %(
                Ce test vérifie qu'au moins une ressource Slot du bundle a un champ meta.security.code = CPTS.
            )

            run do
                bundle = scratch[:Bundle]
                skip "Le test d'initialisation doit être validé pour évaluer ce test" if (!bundle.present?)

                list_meta = evaluate_fhirpath(resource: bundle, path: 'entry.where(resource.meta.profile="https://interop.esante.gouv.fr/ig/fhir/sas/StructureDefinition/sas-cpts-slot-aggregator").resource.meta.security.code.distinct()')

                isCpts = false
                list_meta.each_with_index do |type_creneau|
                    isCpts = isCpts || type_creneau["element"].to_s == 'CPTS'
                end

                assert(isCpts, "Aucune ressource slot n'est de type CPTS")
            end
        end
    end
end