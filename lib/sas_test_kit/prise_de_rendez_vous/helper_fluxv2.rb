require 'nokogiri'
require 'unicode_utils'

module SasTestKit
    module SSOHelper

        def self.spa_page?(doc, full_html)
            return true if doc.at_css('div#app')
            return true if doc.at_css('script[src*="app"]')
            return true if doc.at_css('script[src*="chunk"]')
            return true if doc.at_css('noscript')
            return true if doc.text.strip.empty? && full_html.include?('<script')

            false
        end

        
        def self.to_utf8(str)
            return '' if str.nil?
            str = str.to_s
            str.force_encoding('UTF-8').encode('UTF-8', invalid: :replace, undef: :replace, replace: ' ')
        end


        def self.analyze_html_response(body)
            full_html = body.downcase
            doc = Nokogiri::HTML(body)
            basic_text = doc.text.downcase.strip.gsub(/\s+/, ' ')
            attr_text  = doc.xpath('//@alt | //@title | //@aria-label').map(&:value).join(' ').downcase

            combined_text = [basic_text, attr_text, full_html].map { |s| to_utf8(s) }.join(' ')
            normalized = UnicodeUtils.nfkd(combined_text).downcase

            error_keywords = [
                'erreur', 'probleme', 'incident', 'echec',
                'non autorise', 'acces refuse', 'authentification echouee',
                'page introuvable', 'ressource non trouvee', 'not found', '404',
                'connexion impossible', 'session invalide',
                'desole', 'impossible de', 'oups', 'invalid'
            ]

            login_keywords = [
                'connexion', 'authentification', 'identification', 'login',
                'sign in', 's identifier', 'se connecter', 'authentifiez-vous',
                'mot de passe', 'password', 'username', 'utilisateur', 'email',
                'compte', 'account', 's inscrire', 'register'
            ]

            {
                is_spa: spa_page?(doc, full_html),
                found_error: error_keywords.any? { |kw| normalized.include?(kw) },
                found_login: login_keywords.any? { |kw| normalized.include?(kw) },
                combined_text: combined_text
            }
        end
    end
end