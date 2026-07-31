module SasTestKit
    module SingleAssociation
        class ValidateOrganizationName < Inferno::Test
            title "Vérification du champ name des ressources Organization"
            id :sos_validate_organization_name
            description %(
                Ce test réalise une vérification de la présence du champ name des ressources Organisation du Bundle de réponse.
            )
                
            run do
                skip "Le test d'initialisation doit être validé pour évaluer ce test" if (!scratch[:Bundle].present?)
                assert(scratch[:organizations].length >= 1, "Le Bundle doit contenir au moins une ressource Organization, il en possède #{scratch[:organizations].length}")

                organizations = scratch[:organizations]

                organizations.each do |organization|
                    name = organization['element'].name
                    add_message('info', "name : #{name}")
                    assert(name != nil && name != "", "Le champ name est nul ou non présent dans la ressource #{organization['element'].id}")
                end
            end
        end
    end
end