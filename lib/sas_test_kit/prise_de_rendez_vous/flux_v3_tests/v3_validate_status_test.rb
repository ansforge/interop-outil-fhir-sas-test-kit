module SasTestKit
    module FluxV3Group
        class V3ValidateStatusTest < Inferno::Test
            title "Validation de la valeur de l'élement status"
            description %(
                Ce test a pour objectif de valider la valeur renseignée au niveau de l'élément status de la ressource Appointment.
            )
            id :v3_validate_status

            input :appointment,
                title: 'Ressource FHIR Appointment',
                description: 'La ressource FHIR Appointment à valider pour les tests de remontée des informations de rendez-vous',
                type: :textarea

            input :status

            run do
                appointment_fhir = FHIR::Appointment.new(JSON.parse(appointment, {:symbolize_names=>true}))
                skip "Aucune ressource Appointment fournie en entrée" if status == 'false'

                status = appointment_fhir.status
                VALID_STATUS = ['pending', 'booked', 'fulfilled', 'cancelled', 'noshow']
                assert(VALID_STATUS.include?(status), "status doit être renseigné avec l'une des valeurs suivantes : #{VALID_STATUS}")

                appointment_fhir.participant.each do |p|
                    if p.status == 'needs-action'
                        assert(status == 'pending', "Lorsque au moins un participant est au status 'needs-action' le status du rendez-vous doit être 'pending'")
                    end
                end
            end
        end
    end
end