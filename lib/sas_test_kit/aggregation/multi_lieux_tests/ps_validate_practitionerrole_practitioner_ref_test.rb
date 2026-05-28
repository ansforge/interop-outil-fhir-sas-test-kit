module SasTestKit
    module MultiLieux
        class ValidatePractitionerRolePractitionerRef < Inferno::Test
            title 'Vérification de la cohérence des références PractitionerRole -> Practitioner'
            id :validate_practitionerrole_practitioner_ref
            description %(
                # Description

                Ce test vérifie que chacun des deux `PractitionerRole` **référence le Practitioner unique** présent dans le Bundle.  
                Toutes les relations `PractitionerRole.practitioner.reference` doivent pointer vers le même identifiant `Practitioner/<id>`.
            )
            verifies_requirements 'agg-psindiv@21'
            
            run do
                skip %(Les tests **4.5.02** et **4.5.03** doivent être validés pour évaluer ce test) if (!scratch[:practitioner].present? && !scratch[:practitioner_roles].present?)
                practitioner = scratch[:practitioner]
                practitioner_roles = scratch[:practitioner_roles]
                practitioner_roles.each do |pr|
                    assert(pr['element'].practitioner.reference == "Practitioner/#{practitioner[0]['element'].id}", "Le PractitionerRole doit référencer le Practitioner présent dans le Bundle : #{pr['element'].practitioner.reference} vs Practitioner/#{practitioner[0]['element'].id}")
                end
            end
        end
    end
end