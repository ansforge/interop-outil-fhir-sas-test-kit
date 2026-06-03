require_relative 'setup_test'
require_relative '../sas_options.rb'

require_relative 'single_practitioner_single_location_tests/cpts_validate_id_test'
require_relative 'single_practitioner_single_location_tests/cpts_validate_cardinality_test'
require_relative 'single_practitioner_single_location_tests/cpts_validate_ref_test'
require_relative 'single_practitioner_single_location_tests/ps_slot_has_url_test'
require_relative 'single_practitioner_single_location_tests/ps_bundle_url_equal_url_test'
require_relative 'single_practitioner_single_location_tests/ps_validate_location_test'
require_relative 'single_practitioner_single_location_tests/ps_validate_dates_test'
require_relative 'single_practitioner_single_location_tests/ps_validate_rpps_test'
require_relative 'single_practitioner_single_location_tests/ps_validate_cardinality_test'
require_relative 'single_practitioner_single_location_tests/ps_validate_ref_test.rb'
require_relative 'single_practitioner_single_location_tests/ps_validate_slots_status_test.rb'
require_relative 'single_practitioner_single_location_tests/ps_validate_appointmentType_test.rb'



module SasTestKit
  module SinglePractitionerSingleLocation
    class SinglePractitionerSingleLocation < Inferno::TestGroup
      title "PS avec un seul lieu de consultation"
      description %(
        ## Description

        Ce groupe vérifie la conformité du **Bundle de réponse** renvoyé par le **flux Agrégateur - recherche de créneaux** pour un **professionnel de santé (PS) disposant d'un seul lieu de consultation**.  
        Les contrôles portent sur la **présence**, la **cardinalité**, la **cohérence des références inter-ressources** et la **validité des données clés** attendues par les profils SAS.

        Plus précisément, les tests valident :
        - la présence et le nombre des ressources principales du Bundle (*FrPractitionerAgregateur*, *FrPractitionerRoleExerciceAgregateur*, *FrScheduleAgregateur*, *FrSlotAgregateur*) pour un RPPS donné (un seul Practitioner, un seul PractitionerRole, un seul Schedule, un seul Location) ;
        - le **format du RPPS** (préfixe « 8 » + 11 chiffres) et l'égalité entre le RPPS demandé et celui retrouvé
        - la **cohérence des dates de Slot** (pas de créneau antérieur à 'maintenant'), existence des dates de fin, et vérification `start < end`
        - la **cohérence des références** entre Practitioner, PractitionerRole, Schedule (et Location contenue), selon les profils SAS
        - la **présence de l'adresse** (ligne, ville, code postal à 5 chiffres) pour le lieu unique du PS
        - la conformité du champ `Bundle.link.url` avec l'URL de requête
        - la **présence d'une URL de prise de RDV** (champ `Slot.comment`) sur chaque créneau retourné.

        Ces contrôles s'appuient sur les profils et règles publiés dans le **Guide d'implémentation SAS** et la page **Spécifications fonctionnelles** concernant la **recherche de créneaux via l'agrégateur**. Ils visent à garantir que la réponse fournie par l'éditeur est exploitable par la plateforme SAS conformément aux attentes officielles.
      )
      id :single_practitioner_single_location
      verifies_requirements 'agg-psindiv@4', 'agg-psindiv@5', 'agg-psindiv@6', 'agg-psindiv@7','agg-psindiv@10', 'agg-psindiv@11', 'agg-psindiv@15', 'agg-psindiv@19', 
                            'agg-psindiv@21', 'agg-psindiv@22', 'agg-psindiv@26', 'agg-psindiv@27', 'agg-psindiv@28', 'agg-psindiv@29', 'agg-psindiv@30', 'agg-psindiv@37',
                            'agg-psindiv@38', 'agg-psindiv@39', 'agg-psindiv@40', 'agg-psindiv@45', 'agg-psindiv@49'

      input :practitioner_id,
            title: 'RPPS',
            description: 'Renseigner le RPPS (préfixé par 8) d\'un PS ne possédant qu\'un lieu'
      
      input_order :base_url, :mTLS, :practitioner_id
      
      run_as_group
      
      test from: :slot_search_setup do
        config(
          inputs: { 
            practitioner_id: { name: :practitioner_id },
          }
        )
      end

      test from: :validate_cardinality

      test from: :validate_rpps

      test from: :validate_dates

      test from: :validate_ref

      test from: :validate_location

      test from: :bundle_url_equal_url

      test from: :slot_has_url

      test from: :ps_validate_slots_status

      test from: :ps_validate_appointmentType

      test from: :validate_cardinality_cpts,
        required_suite_options: SASOptions::IG_REQUIREMENT_CPTS

      test from: :validate_ref_cpts,
        required_suite_options: SASOptions::IG_REQUIREMENT_CPTS

      test from: :validate_cpts_id,
        required_suite_options: SASOptions::IG_REQUIREMENT_CPTS
    end
  end
end
