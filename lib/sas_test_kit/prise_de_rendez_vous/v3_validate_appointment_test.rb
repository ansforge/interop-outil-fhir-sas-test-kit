module SasTestKit
    class V3ValidateAppointmentTest < Inferno::Test
        title "Validation de la ressource FHIR Appointment"
        description %(
            Ce test a pour objectif de valider la conformité d'une ressource FHIR Appointment aux spécifications attendues pour la remontée des informations de rendez-vous dans le cadre du flux V3.
        )
        id :v3_validate_appointment

        input :appointment,
            title: 'Ressource FHIR Appointment',
            description: 'La ressource FHIR Appointment à valider pour les tests de remontée des informations de rendez-vous'

        run do
            appointment_fhir = FHIR::Appointment.new(JSON.parse(appointment, {:symbolize_names=>true}))
            skip "Aucune ressource Appointment fournie en entrée" if appointment_fhir.nil?

            assert_resource_type('Appointment', resource: appointment_fhir)
            assert_valid_resource(resource: appointment_fhir, validator: :validator_sas)
        end
    end
end