module SasTestKit
    module SingleAssociation
        class ValidateLocationIDNST < Inferno::Test
            title "Vérification du champ identifier.value des ressources Location"
            id :sos_validate_location_idnst
            description %(
                Ce test réalise une vérification du contenu du champ identifier.value des ressources Location du Bundle de réponse.
            )
                
            run do
                skip "Le test d'initialisation doit être validé pour évaluer ce test" if (!scratch[:Bundle].present?)
                assert(scratch[:locations].length >= 1, "Le Bundle doit contenir au moins une ressource Location, il en possède #{scratch[:locations].length}")

                locations = scratch[:locations]
                PATTERNS_ANY = [
                    /\A1[0-9]{9}\z/,  # FINESS
                    /\A3[0-9]{14}\z/, # SIRET
                    /\A4[0-9]{14}\z/  # RPPSRANG
                ]

                locations.each do |location|
                    idnst = location['element'].identifier[0].value
                    code = location['element'].identifier[0].type.coding[0].code
                    
                    if code != 'INTRN'
                        assert((matches_any = PATTERNS_ANY.any? { |rx| rx.match?(idnst) }), "L'IDNST doit être au bon format")
                    end 
                end
            end
        end
    end
end