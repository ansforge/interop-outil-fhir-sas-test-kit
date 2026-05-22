require 'uri'
require 'cgi'

module SasTestKit
    module SinglePractitionerSingleLocation
        class BundleUrlEqualUrl < Inferno::Test
            title "Vérification de la correspondance entre Bundle.link.url et l'URL de la requête"
            id :bundle_url_equal_url
            description %(
                ## Description

                Ce test valide que le champ **`Bundle.link.url`** **reflète exactement** l'URL de la requête FHIR ayant produit le Bundle.
            )
            run do
                request_url = scratch[:query]
                bundle = scratch[:Bundle]
                skip "Le test d'initialisation doit être validé pour évaluer ce test" if (!bundle.present?)
                URL = evaluate_fhirpath(
                resource: bundle,
                path: 'link.url'
                )

                assert(URL[0] != nil && URL[0]["element"] != nil, "Le champ link.URL n'est pas présent ou est vide")
                
                link_url = URL[0]["element"].to_s
        
                def normalized_query(url)
                    decoded_url = CGI.unescapeHTML(url)
                    uri = URI.parse(decoded_url)
                    return {} if uri.nil? || uri.query.nil? || uri.query.empty?
                    CGI.parse(uri.query).transform_values(&:sort)
                end

                add_message('info', "champ link.URL: " + link_url)
                add_message('info', "requête FHIR: " + request_url)
                
                request_query = normalized_query(request_url)
                link_query    = normalized_query(link_url)

                assert(request_query == link_query, "Les query ne correspondent pas")
                add_message("warning", "L'URL du bundle et de la requête ne sont pas identiques !") if (link_url != request_url)
            end
        end
    end
end