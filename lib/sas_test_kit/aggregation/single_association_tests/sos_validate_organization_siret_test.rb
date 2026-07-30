module SasTestKit
    module SingleAssociation
        class ValidateOrganizationSiret < Inferno::Test
            title "Vérification du SIRET de l'organisation"
            id :validate_organization_siret
            description %(
                ## Description

                Il est attendu que la recherche retourne **exactement une** ressource *Organization* correspondant au SIRET renseigné en entrée.
                Le format du SIRET est contrôlé par la regex suivante : /^3\d{14}$/
            )

            input :siret_n, 
                    title: "SIRET de l'association",
                    type: 'text',
                    optional: true,
                    hidden: true

            run do
                skip "Le test d'initialisation doit être validé pour évaluer ce test" if (!scratch[:Bundle].present?)
                organization = scratch[:organizations].first['element']
                assert(organization.identifier.first.value == siret_n, "Le SIRET de l'organisation retournée (#{organization.identifier.first.value}) ne correspond pas au SIRET demandé (#{siret_n})")
                assert(siret_n.match(/^3\d{14}$/), "Le SIRET #{siret_n} doit être composé de 15 chiffres et commencer par 3.")
            end
        end
    end
end