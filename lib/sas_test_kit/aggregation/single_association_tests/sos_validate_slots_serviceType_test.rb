module SasTestKit
    module SingleAssociation
        class ValidateServiceType < Inferno::Test
            title 'Vérification du serviceType des créneaux'
            id :sos_validate_serviceType
            description %(
                Ce test vérifie que les ressources Slot retournées dans le Bundle possèdent
                un champ `serviceType` correctement renseigné avec un code conforme.
            )
            verifies_requirements 'agg-psindiv@49'

            run do
                bundle = scratch[:Bundle]
                skip "Le test d'initialisation doit être validé pour évaluer ce test" if (!bundle.present?)

                slot_profile_url = 'https://interop.esante.gouv.fr/ig/fhir/sas/StructureDefinition/sas-sos-slot-aggregator'

                serviceType = evaluate_fhirpath(resource: bundle, path: "entry.where(resource.meta.profile='#{slot_profile_url}').resource.serviceType.coding.code.distinct()")   
                add_message('info', "serviceType des créneaux retournés: " + serviceType.to_s) 
            
                for serviceTypeCode in serviceType
                    assert((serviceTypeCode["element"] == "AMB" || serviceTypeCode["element"] == "VR"), "Le code du  serviceType doit être égal à l'une des valeurs suivantes : AMB ou VR")
                end
            end
        end
    end
end