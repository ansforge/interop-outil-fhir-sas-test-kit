require_relative 'setup_test'

require_relative 'practitioner_optionnel_tests/ps_validate_idnst_test'
require_relative 'practitioner_optionnel_tests/ps_validate_rpps_test'
require_relative 'practitioner_optionnel_tests/ps_validate_name_test'
require_relative 'practitioner_optionnel_tests/ps_validate_firstname_test'
require_relative 'practitioner_optionnel_tests/ps_validate_phone_test'

module SasTestKit
  module PractitionerOpt
    class PractiOptionelGroupPS < Inferno::TestGroup
      title 'Champs optionnels'
      description 'Contrôles des données optionnelles du PS'
      id :practi_optionnel_group_ps

      input_order :base_url, :mTLS, :practitioner_id

      input :practitioner_id,
              title: 'RPPS',
              description: 'Renseigner le RPPS (préfixé par 8) d\'un PS avec nom, prénom et téléphone'

      test from: :slot_search_setup do
        config(
          inputs: { 
            practitioner_id: { name: :practitioner_id },
          }
        )
      end
      
      test from: :ps_validate_rpps

      test from: :ps_validate_name

      test from: :ps_validate_firstname
    
      test from: :ps_validate_phone

      test from: :ps_validate_idnst
    end
  end
end
