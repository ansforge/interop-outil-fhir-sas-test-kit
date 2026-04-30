module SasTestKit
    class ValidateCardinalityCPTS < Inferno::Test
        title 'Vérification de la présence et des cardinalités des ressources CPTS du Bundle'
        id :validate_cardinality_cpts
        description %(
            ## Description

            Ce test vérifie la **présence** et les **cardinalités attendues** des ressources spécifiques au cas d'usage CPTS du Bundle de réponse (cas PS avec un **seul lieu**).  
            Il contrôle :
            - Organization
            - Healthcare_Service
        )
        run do
            bundle = scratch[:Bundle]
            skip "Le test d'initialisation doit être validé pour évaluer ce test" if (!bundle.present?)

            NbRessourcesHealthcareService =  evaluate_fhirpath(resource: bundle, path: 'entry.where(resource.meta.profile="https://interop.esante.gouv.fr/ig/fhir/sas/StructureDefinition/sas-cpts-healthcareservice-aggregator").count()')
            add_message('info', "Nombre de ressources HealthcareService dans le message : " + NbRessourcesHealthcareService[0]["element"].to_s)

            NbRessourcesOrganization =  evaluate_fhirpath(resource: bundle, path: 'entry.where(resource.meta.profile="https://interop.esante.gouv.fr/ig/fhir/sas/StructureDefinition/sas-cpts-organization-aggregator").count()')
            add_message('info', "Nombre de ressources Organization dans le message : " + NbRessourcesOrganization[0]["element"].to_s)
            
            assert(NbRessourcesHealthcareService[0]["element"] > 0, "Il n'y a pas de ressources Healthcare_Service dans le bundle.")
            assert(NbRessourcesOrganization[0]["element"] > 0, "Il n'y a pas de ressources Organization dans le bundle.")
            assert(NbRessourcesHealthcareService[0]["element"] == NbRessourcesOrganization[0]["element"], "Il y a #{NbRessourcesHealthcareService[0]["element"]} healthcare services pour 
                #{NbRessourcesOrganization[0]["element"]} organization")
        end
    end
end