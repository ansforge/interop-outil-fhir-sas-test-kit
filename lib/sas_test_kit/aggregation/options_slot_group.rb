require_relative 'setup_test'
require_relative '../sas_options.rb'


require_relative 'options_slots_tests/ps_validate_slot_type_test'
require_relative 'options_slots_tests/ps_validate_motif_type_test'
require_relative 'options_slots_tests/cpts_validate_slot_type_test'

module SasTestKit
  class OptionSlotGroupPS < Inferno::TestGroup
    title 'Cohérence type de créneaux / consultations'
    description %(
      ## Description

      Ce groupe de tests vise à vérifier la cohérence entre les types de créneaux et
      les types de consultations déclarés comme disponibles par la solution, et ceux
      effectivement retournés dans les ressources Slot exposées par le serveur.

      Les contrôles portent sur des données optionnelles des créneaux, mais essentielles
      pour garantir la bonne interprétation fonctionnelle de l'offre de rendez-vous
      par les consommateurs de l'API.

      ## Consignes d'utilisation

      Ce groupe de test s'appuie sur une phase préalable de recherche de créneaux afin
      de constituer un Bundle de référence. Il est donc impératif que le professionnel
      de santé (PS) utilisé pour l'exécution des tests dispose d'un ensemble de créneaux
      suffisamment riche et représentatif.

      Lors du lancement du groupe de test, l'utilisateur doit renseigner :
      - les types de créneaux proposés par la solution ;
      - les types de consultations associés aux créneaux.

      Ces informations servent de base de comparaison avec les données effectivement
      retournées par le serveur.

      ## Types de créneaux attendus

      Le PS sélectionné pour les tests devrait idéalement exposer un maximum de types
      de créneaux, parmi lesquels :
      - créneaux grand public
      - créneaux réservés aux professionnels
      - créneaux typés SNP
      - créneaux privés

      La présence de plusieurs types permet de vérifier la cohérence et l'exhaustivité
      des informations retournées.

      ## Types de consultation attendus

      Les créneaux retournés peuvent être associés à différents types de consultations,
      notamment :
      - consultations au cabinet
      - téléconsultations
      - visites à domicile

      Il est recommandé d'utiliser un PS proposant plusieurs types de consultation afin
      d'assurer une couverture fonctionnelle maximale du test group.
    )

    id :optionslots_group

    input_order :base_url, :mTLS, :practitioner_id

    test from: :slot_search_setup do
      config(
        inputs: {
          practitioner_id: { name: :practitioner_id },
        }
      )
    end

    test from: :cpts_validate_slot_type,
      required_suite_options: SASOptions::IG_REQUIREMENT_CPTS

    test from: :ps_validate_slot_type,
      required_suite_options: SASOptions::IG_REQUIREMENT_PSINDIV

    test from: :ps_validate_motif_type
  end
end
