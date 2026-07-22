module SasTestKit
    module SingleAssociation
        class ValidateOrganizationSiret < Inferno::Test
            title "Vérification du SIRET de l'organisation"
            id :validate_organization_siret
            description %(
                ## Description

                Il est attendu que la recherche retourne **exactement une** ressource *Organization* correspondant au SIRET renseigné en entrée.
            )

            run do
                skip "Le test d'initialisation doit être validé pour évaluer ce test" if (!scratch[:Bundle].present?)
                organization = scratch[:organizations].first['element']
                assert(organization.identifier.first.value == siret, "Le SIRET de l'organisation retournée (#{organization.identifier.first.value}) ne correspond pas au SIRET demandé (#{siret})")
            end
        end
    end
end