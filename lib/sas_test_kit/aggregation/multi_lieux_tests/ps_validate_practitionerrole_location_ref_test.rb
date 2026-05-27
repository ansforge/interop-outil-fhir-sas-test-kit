module SasTestKit
    module MultiLieux
        class ValidatePractitionerRoleLocationRef < Inferno::Test
            title 'Vérification de la cohérence des références PractitionerRole -> Location'
            id :validate_practitionerrole_location_ref
            description %(
                ## Description

                Ce test vérifie la cohérence entre les `PractitionerRole` et leurs `Location` respectives.  
                Chaque `PractitionerRole.location.reference` doit référencer une ressource `Location` contenue (`#<id>`), et chaque Location contenue doit correspondre à l'un des lieux d'exercice du PS.
            )
            verifies_requirements 'agg-psindiv@22'
            
            run do
                skip %(Le test **4.5.03** doit être validé pour évaluer ce test) if (!scratch[:practitioner_roles].present?)
                practitioner_roles = scratch[:practitioner_roles]
                locations = practitioner_roles.map { |pr| pr['element'].location.map { |loc| loc.reference } }.flatten
                location_ids = practitioner_roles.map { |pr| pr['element'].contained.select { |res| res.resourceType == 'Location' }.map { |loc| loc.id } }.flatten
                locations.each_with_index do |loc_ref, i|
                    assert('#' + location_ids[i] == loc_ref, "Le lieu d'exercice référencé par le PractitionerRole doit correspondre à la ressource Location contenue dans contained")
                end
            end
        end
    end
end