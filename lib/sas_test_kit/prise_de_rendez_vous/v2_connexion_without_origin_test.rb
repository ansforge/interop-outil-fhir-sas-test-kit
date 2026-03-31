require_relative 'helper_fluxv2'

module SasTestKit
    class ConnexionWithoutOriginTest < Inferno::Test
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
                analysis = SSOHelper.analyze_html_response(response[:body])

                add_message('info', "Page SPA détectée : #{analysis[:is_spa]}")
                add_message('info', "Erreur détectée : #{analysis[:found_error]}")
                add_message('info', "Page de connexion détectée : #{analysis[:found_login]}")

                if analysis[:is_spa] && !analysis[:found_error] && !analysis[:found_login]
                    omit "Page JavaScript (SPA) détectée — aucun contenu statique à analyser"
                end

                assert(
                    analysis[:found_error] || analysis[:found_login],
                    "Aucun message d'erreur ou page de connexion détectée"
                )
            else
                assert(false, "Réponse non HTML : #{content_type}")
            end
        end
    end
end