module SasTestKit
    module FluxV3Group
        class V3ValidateURLTest < Inferno::Test
            title "Validation de la valeur de l'élément extension.url"
            description %(
                Ce test a pour objectif de valider la valeur renseignée au niveau de l'élément extension.url de la ressource Appointment.
            )
            id :v3_validate_url

            input :appointment,
                title: 'Ressource FHIR Appointment',
                description: 'La ressource FHIR Appointment à valider pour les tests de remontée des informations de rendez-vous',
                type: :textarea

            run do
                appointment_fhir = FHIR::Appointment.new(JSON.parse(appointment, {:symbolize_names=>true}))
                skip "Aucune ressource Appointment fournie en entrée" if appointment_fhir.nil?

                url = appointment_fhir.extension[0].url
                assert(url == "http://interopsante.org/fhir/StructureDefinition/FrAppointmentOperator",
                "L'url renseigné doit être : http://interopsante.org/fhir/StructureDefinition/FrAppointmentOperator")
            end
        end
    end
end