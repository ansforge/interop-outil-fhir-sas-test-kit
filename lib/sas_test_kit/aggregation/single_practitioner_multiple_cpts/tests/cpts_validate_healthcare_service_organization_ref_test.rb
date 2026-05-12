module SasTestKit
    module SinglePractitionerMultipleCPTS
        class ValidateHealthcareServiceOrganizationRef < Inferno::Test
            title 'Vérification de la cohérence des références HealthcareService -> Organization'
            id :cpts_validate_healthcare_service_organization_ref
            description %(
                Ce test vérifie que chaque ressource HealthcareService possède un champ
                providedBy.reference pointant vers une Organization présente dans le Bundle.
            )

            run do
                bundle = scratch[:Bundle]
                skip "Le test d'initialisation doit être validé pour évaluer ce test" if (!bundle.present?)

                healthcareServices = scratch[:healthcareServices]
                assert(!healthcareServices.empty?, "Aucune ressource HealthcareService trouvé dans le Bundle")

                organizations = scratch[:organization]
                assert(!organizations.empty?, "Aucune ressource Organization trouvé dans le Bundle")

                organization_refs = organizations.map do |org|
                    "Organization/#{org['element'].id}"
                end

                all_refs_found = []
                validity = healthcareServices.all? do |hs|
                    resource = hs['element']

                    ref = resource.providedBy&.reference
                    all_refs_found << ref if ref

                    organization_refs.include?(ref)
                end
  
                distinct_refs = all_refs_found.compact.uniq
                has_two_distinct_orgs = distinct_refs.length >= 2
                
                error_message = %(
                    Certaines ressources HealthcareService ne référencent pas correctement une Organization

                    - **Organizations attendues (présentes dans le Bundle)** :
                        #{organization_refs}

                    - **Références trouvées dans HealthcareService.providedBy** :
                        #{all_refs_found.empty? ? "Aucune" : all_refs_found}
                    
                    - **Références distinctes** :
                        #{distinct_refs}

                    - **Problème détecté** :
                        -   Références distinctes >= 2 : #{has_two_distinct_orgs} 
                        -   Toutes les références existent : #{validity}
                )
                assert(validity && has_two_distinct_orgs, error_message)
            end
        end
    end
end