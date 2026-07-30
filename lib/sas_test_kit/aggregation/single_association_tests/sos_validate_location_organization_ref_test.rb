module SasTestKit
    module SingleAssociation
        class ValidateLocationOrganizationRef < Inferno::Test
            title "Vérification de la référence à une organisation dans la ressource Location"
            id :validate_location_organization_ref
            description %(
                Ce test réalise une vérification de la **présence d'une référence à une ressource Organization existante** dans les ressources Location du Bundle de réponse.
            )
                
            run do
                skip "Le test d'initialisation doit être validé pour évaluer ce test" if (!scratch[:Bundle].present?)
                assert(scratch[:locations].length >= 1, "Le Bundle doit contenir au moins une ressource Location, il en possède #{scratch[:locations].length}")
                assert(scratch[:organizations].length >= 1, "Le Bundle doit contenir au moins une ressource Organization, il en possède #{scratch[:organizations].length}")

                locations = scratch[:locations]
                organizations = scratch[:organizations]

                organization_ids = []
                organizations.each do |organization|
                    organization_ids << "Organization/#{organization['element'].id}"
                end

                locations.each do |location|
                    location = location['element']
                    assert(location.managingOrganization.present?, "La ressource Location #{location.id} ne contient pas de référence à une ressource Organization")

                    reference = location.managingOrganization.reference
                    assert(organization_ids.include?(reference), "La ressource Location #{location.id} référence une organization qui n'existe pas dans le Bundle.")
                end
            end
        end
    end
end