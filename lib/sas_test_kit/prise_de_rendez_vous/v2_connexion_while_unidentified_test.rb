require_relative 'helper_fluxv2'

module SasTestKit
    class ConnexionWhileUnidentifiedTest < Inferno::Test
        title "Connexion sans être identifié à la platforme SAS"
        id :sso_while_unidentified
        description %()
        run do
            bundle = scratch[:Bundle]
            assert(bundle.present?, 'Bundle not found in scratch')
            
            sso_url = scratch[:sso_url] + "&origin=sas-preprod"
            add_message('info', "URL de SSO : #{sso_url}")
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

                key_word = ['Ministère de la Santé et de la prévention']
                add_message('info', "Page de connexion PSC détectée : #{analysis[:combined_text].include?(key_word.first.downcase)}")

                if analysis[:is_spa]
                    omit "Page JavaScript (SPA) détectée — aucun contenu statique à analyser"
                end

                assert(analysis[:combined_text].include?(key_word.first.downcase), "Pas de redirection vers la page de connexion PSC")
            else
                assert(false, "Réponse non HTML : #{content_type}")
            end
        end
    end
end