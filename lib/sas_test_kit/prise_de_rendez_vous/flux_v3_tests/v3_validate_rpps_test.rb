module SasTestKit
    module FluxV3Group
        class V3ValidateRPPSTest < Inferno::Test
            title "Validation de la valeur de l'élément actor.identifier.value"
            description %(
                Ce test a pour objectif de valider la valeur renseignée au niveau de l'élément actor.identifier.value de la ressource Appointment.
                La valeur doit correspondre à un RPPS valide.
            )
            id :v3_validate_rpps

            input :appointment,
                title: 'Ressource FHIR Appointment',
                description: 'La ressource FHIR Appointment à valider pour les tests de remontée des informations de rendez-vous',
                type: :textarea

            input :status

            run do
                appointment_fhir = FHIR::Appointment.new(JSON.parse(appointment, {:symbolize_names=>true}))
                skip "Aucune ressource Appointment fournie en entrée" if status == 'false'

                rpps = appointment_fhir.participant[0].actor.identifier.value
                assert(rpps =~ /\A8[0-9]{11}\z/ , "le RPPS retourné doit comporter 11 chiffres préfixés par 8")
            end
        end
    end
end