module SasTestKit
    class ValidateRefCPTS < Inferno::Test
        title 'Vérification de la cohérence des références entre Practitioner, PractitionerRole, Schedule et Location'
        id :validate_ref_cpts
        description %(
            ## Description

            Ce test valide la **cohérence des références** entre les ressources du Bundle :  
            - `PractitionerRole.practitioner.reference` pointe vers l'**ID du Practitioner** présent dans le Bundle ;
            - `Schedule.actor.reference` inclut les **références vers Practitioner et PractitionerRole** ;
            - la `Location` **contenue** dans `PractitionerRole` est référencée via un **lien local** (`#<id>`).
        )
        run do
            bundle = scratch[:Bundle]
            skip "Le test d'initialisation doit être validé pour évaluer ce test" if (!bundle.present?)

            reference_organization = evaluate_fhirpath(
                resource: bundle,
                path: 'entry.where(resource.meta.profile="https://interop.esante.gouv.fr/ig/fhir/sas/StructureDefinition/sas-cpts-healthcareservice-aggregator").resource.providedBy.reference'
            )

            organization_id = evaluate_fhirpath(
                resource: bundle,
                path: 'entry.where(resource.meta.profile="https://interop.esante.gouv.fr/ig/fhir/sas/StructureDefinition/sas-cpts-organization-aggregator").resource.id'
            )

            lst_references_healthcareservice = evaluate_fhirpath(
                resource: bundle,
                path: 'entry.resource.where(meta.profile = "https://interop.esante.gouv.fr/ig/fhir/sas/StructureDefinition/sas-cpts-slot-aggregator").serviceType.where(coding.code = "604").extension.where(url = "http://hl7.org/fhir/5.0/StructureDefinition/extension-Slot.serviceType" and value is Reference).value.reference'
            )

            healthcareserviceid = evaluate_fhirpath(
                resource: bundle,
                path: 'entry.where(resource.meta.profile = "https://interop.esante.gouv.fr/ig/fhir/sas/StructureDefinition/sas-cpts-healthcareservice-aggregator").resource.id'
            )

            assert(reference_organization.length > 0, "Impossible d'accèder au champ providedBy.reference d'une ressource Healthcare_Service dans le Bundle")
            assert(organization_id.length > 0, "Impossible d'accèder au champ id d'une ressource Organization dans le Bundle")
            assert(lst_references_healthcareservice.length > 0)
            assert(healthcareserviceid.length > 0, "Impossible d'accèder au champ id d'une resource Healthcare_Service dans le Bundle")

            add_message('info', "Reference Organization: " + reference_organization[0]["element"].to_s)  
            assert(reference_organization[0]["element"].to_s == "Organization/" + organization_id[0]["element"].to_s, "Il est attendu que l'identifiant de l'organization #{organization_id} matche la reference #{reference_organization}")

            liste =  lst_references_healthcareservice.map { |item| item['element'].to_s }
            liste_concat = liste.join(', ')
            add_message('info', "References Healthcare Service : " + liste_concat)

            lst_references_healthcareservice.each_with_index do |reference, int|
                lst_references_healthcareservice = reference["element"].to_s
                assert(lst_references_healthcareservice == "HealthcareService/" + healthcareserviceid[0]["element"].to_s, "La référence dans la ressource Slot doit être égale à l'identifiant de la ressource HealthcareService: #{healthcareserviceid[0]["element"].to_s}")
            end
        end
    end
end