module SasTestKit
    module SingleAssociation
        class ValidateMeta < Inferno::Test
            title 'Vérification du champ meta.security des créneaux'
            id :sos_validate_meta
            description %(
                Ce test vérifie que les ressources Slot retournées dans le Bundle possèdent
                un champ `meta.security` non vide.
            )
            verifies_requirements 'agg-psindiv@49'

            run do
                bundle = scratch[:Bundle]
                skip "Le test d'initialisation doit être validé pour évaluer ce test" if (!bundle.present?)

                slot_profile_url = 'https://interop.esante.gouv.fr/ig/fhir/sas/StructureDefinition/sas-sos-slot-aggregator'

                codes = evaluate_fhirpath(resource: bundle, path: "entry.where(resource.meta.profile='#{slot_profile_url}').resource.meta.security.code.distinct()")   
                assert(codes.length >= 1)
            end
        end
    end
end