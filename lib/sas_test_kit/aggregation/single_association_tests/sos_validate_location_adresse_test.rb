module SasTestKit
    module SingleAssociation
        class ValidateLocationAdresse < Inferno::Test
            title "Vérification du champ address des ressources Location"
            id :validate_location_adresse
            description %(
                Ce test réalise une vérification du contenu du champ address des ressources Location du Bundle de réponse.
            )
                
            run do
                skip "Le test d'initialisation doit être validé pour évaluer ce test" if (!scratch[:Bundle].present?)
                assert(scratch[:locations].length >= 1, "Le Bundle doit contenir au moins une ressource Location, il en possède #{scratch[:locations].length}")

                locations = scratch[:locations]

                locations.each do |location|
                    address = location['element'].address
                    add_message('info', "Adresse : #{address.line.join(', ')}")
                    add_message('info', "Ville : #{address.city}")
                    add_message('info', "CodePostal : #{address.postalCode}")
                    assert(address.postalCode.match?(/\A[0-9]{5}\z/), "Le champs postalCode de la ressource Location #{location['element'].id} ne respecte pas le format attendu (5 chiffres)")
                end
            end
        end
    end
end