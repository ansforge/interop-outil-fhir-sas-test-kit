module SasTestKit
    class ValidateCPTSId < Inferno::Test
        title 'Vérification Identifiant CPTS'
        id :validate_cpts_id
        description %(
            Ce test valide le format et la valeur de l'identifiant CTPS retourné.
        )

        run do
            bundle = scratch[:Bundle]
            skip "Le test d'initialisation doit être validé pour évaluer ce test" if (!bundle.present?)
            IDNST = scratch[:IDNST]
        
            IDNSTrecupere = evaluate_fhirpath(resource: bundle, path: 'entry.where(resource.meta.profile="https://interop.esante.gouv.fr/ig/fhir/sas/StructureDefinition/sas-cpts-organization-aggregator").resource.identifier.value')
            assert(IDNSTrecupere.length > 0, "Impossible d'accèder au champ identifier.value d'une ressource Organization dans le Bundle")

            add_message('info', "Identifiant de la CPTS: " + IDNSTrecupere[0]["element"].to_s) 
            assert ((IDNSTrecupere[0]["element"]) == IDNST), "l\'identifiant retourné doit être égal à l'identifiant indiqué dans les paramètres"
            assert (IDNSTrecupere[0]["element"].to_s =~ /\A1[0-9]{9}\z/) , "L\'identifiant retourné doit comporter 9 chiffres préfixés par 1"
        end
    end
end