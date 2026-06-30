module SasTestKit
    module FluxV3Group
        class V3ValidateCodeTest < Inferno::Test
            title "Validation de la valeur de l'élément identifier.type.coding.code"
            description %(
                Ce test a pour objectif de valider la valeur renseignée au niveau de l'élément identifier.type.coding.code de la ressource Appointment.
            )
            id :v3_validate_code

            input :appointment,
                title: 'Ressource FHIR Appointment',
                description: 'La ressource FHIR Appointment à valider pour les tests de remontée des informations de rendez-vous',
                type: :textarea

            input :status

            run do
                appointment_fhir = FHIR::Appointment.new(JSON.parse(appointment, {:symbolize_names=>true}))
                skip "Aucune ressource Appointment fournie en entrée" if status == 'false'

                sys = appointment_fhir.extension[0].valueReference.identifier.system
                code = appointment_fhir.extension[0].valueReference.identifier.type.coding[0].code
                assert((code == 'IDNPS' && sys = 'urn:oid:1.2.250.1.71.4.2.1') || (code == 'INTRN' && sys = 'urn:oid:1.2.250.1.213.3.6'), "identifier.type.coding.code doit être une des valeurs suivantes : IDNPS, INTRN\n Et doit être cohérent avec le champ system")
            end
        end
    end
end