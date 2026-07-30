module SasTestKit
    module SingleAssociation
        class ValidateLocationPhone < Inferno::Test
            title "Vérification du champ telecom des ressources Location"
            id :validate_location_phone
            description %(
                Ce test réalise une vérification du contenu du champ telecom des ressources Location du Bundle de réponse.
            )
                
            run do
                skip "Le test d'initialisation doit être validé pour évaluer ce test" if (!scratch[:Bundle].present?)
                assert(scratch[:locations].length >= 1, "Le Bundle doit contenir au moins une ressource Location, il en possède #{scratch[:locations].length}")

                locations = scratch[:locations]
                FormatsTel = [
                                /^\+33\d{9}$/,
                                /^\+262\d{9}$/,
                                /^\+590\d{9}$/,
                                /^\+596\d{9}$/,
                                /^\+594\d{9}$/
                                ]

                locations.each do |location|
                    telecom = location['element'].telecom[0]
                    assert(telecom.system == 'phone')
                    assert((Regexp.union(FormatsTel).match?(telecom.value)), "le numéro de téléphone doit être au bon format")  
                end
            end
        end
    end
end