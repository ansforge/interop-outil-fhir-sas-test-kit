require_relative '../aggregation/setup_test'
require_relative '../sas_options'

require 'nokogiri'

module SasTestKit
    class FluxV2Group < Inferno::TestGroup
        title "Tests de conformité SAS - Flux V2 (SSO)"
        description %()
        id :flux_v2_group

        http_client do
            url 'https://example.com'
            bearer_token 'abc'
            headers 'X-Custom-Header' => 'def'
        end

        test from: :slot_search_setup do
            config(
                inputs: { 
                practitioner_id: { name: :practitioner_id },
                }
            )
        end

        test do
            title "Connexion sans le paramètre 'origin'"
            id :sso_without_origin
            description %()
            run do
                bundle = scratch[:Bundle]
                assert(bundle.present?, 'Bundle not found in scratch')
                
                ig_version = suite_options[:launch_version]
                structure_definition = case ig_version
                when SASOptions::IG_VERSION_PSINDIV
                    'http://sas.fr/fhir/StructureDefinition/FrSlotAgregateur'
                when SASOptions::IG_VERSION_CPTS
                    'https://interop.esante.gouv.fr/ig/fhir/sas/StructureDefinition/sas-cpts-slot-aggregator'
                end

                slot_comment_urls = evaluate_fhirpath(resource: bundle, path: "entry.where(resource.meta.profile='#{structure_definition}').resource.comment")
                assert(slot_comment_urls.present?, 'Aucun champ comment trouvé dans le Bundle')

                sso_url = slot_comment_urls.first['element']
                add_message('info', "URL de SSO extraite du champ comment : #{sso_url}")
                get(sso_url, client: nil)

                statusKO = response[:status] >= 400 && response[:status] < 600

                add_message('info', "status de la réponse : #{response[:status]}")
                
                response[:headers].find{ |h| h.name.downcase == 'content-type' }&.value&.downcase
   
                content_type_header = response[:headers].find do |header|
                    header.name.downcase == 'content-type'
                end
                content_type = content_type_header&.value&.downcase

                add_message('info', "Content-Type détecté : #{content_type}")

                if content_type.include?("text/html")
                    doc = Nokogiri::HTML(response[:body])
                    assert(doc.at('html'), "Document HTML invalide ou vide")

                    body_text = doc.text.downcase.strip.gsub(/\s+/, ' ')
                    
                    error_keywords = [
                    'erreur', 'problème', 'incident', 'échec',
                    'non autorisé', 'accès refusé', 'authentification échouée',
                    'page introuvable', 'ressource non trouvée', 'not found', '404',
                    'connexion impossible', 'session invalide',
                    'désolé', 'impossible de', 'oups'
                    ]

                    connection_page_keywords = [
                    'connexion', 'authentification', 'identification', 'login']

                    found_error = error_keywords.any? { |kw| body_text.include?(kw) }
                    found_connection_page = connection_page_keywords.any? { |kw| body_text.include?(kw) }
                    add_message('info', "Mots-clés d'erreur détectés dans la page : #{found_error}")
                    add_message('info', "Mots-clés de page de connexion détectés dans la page : #{found_connection_page}")
                    assert(found_error || found_connection_page, "Aucun message d'erreur détecté dans la page HTML retournée, ce n'est pas non plus une page de connexion")
                end

            end
        end
    end
end