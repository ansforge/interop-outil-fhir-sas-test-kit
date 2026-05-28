module SasTestKit
    module PractitionerOpt
        class ValidateIDNST < Inferno::Test
            title 'Vérification IDNST'
            id :ps_validate_idnst
            description %(
            Présence et format IDNST
            )
            verifies_requirements 'agg-psindiv@20'

            run do
                bundle = scratch[:Bundle]
                skip "Le test d'initialisation doit être validé pour évaluer ce test" unless (bundle.present?)
            
                IDNST = evaluate_fhirpath(resource: bundle, path: 'entry.where(resource.meta.profile="http://sas.fr/fhir/StructureDefinition/FrPractitionerRoleExerciceAgregateur").resource.organization.identifier.value')   
                valueIDNST = IDNST&.dig(0, "element").to_s
                add_message('info', "IDNST: " + valueIDNST)

                assert(valueIDNST && !valueIDNST.empty?, "L'identifiant de structure est manquant")
                
                PATTERNS_ANY = [
                /\A1[0-9]{9}\z/,  # FINESS
                /\A3[0-9]{14}\z/, # SIRET
                /\A4[0-9]{14}\z/  # RPPSRANG
                ]

                assert((matches_any = PATTERNS_ANY.any? { |rx| rx.match?(valueIDNST) }), "L'IDNST doit être au bon format")
            end
        end
    end
end