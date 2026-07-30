module SasTestKit
    module SingleAssociation
        class ValidateLocationName < Inferno::Test
            title "Vérification du champ name des ressources Location"
            id :sos_validate_location_name
            description %(
                Ce test réalise une vérification de la présence du champ name des ressources Location du Bundle de réponse.
            )
                
            run do
                skip "Le test d'initialisation doit être validé pour évaluer ce test" if (!scratch[:Bundle].present?)
                assert(scratch[:locations].length >= 1, "Le Bundle doit contenir au moins une ressource location, il en possède #{scratch[:locations].length}")

                locations = scratch[:locations]

                locations.each do |location|
                    name = location['element'].name
                    add_message('info', "name : #{name}")
                    assert(name != nil && name != "", "Le champ name est nul ou non présent dans la ressource #{location['element'].id}")
                end
            end
        end
    end
end