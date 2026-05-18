require 'inferno'

# Force UTF-8 encoding on all response bodies to avoid ASCII-8BIT encoding errors
module EncodingFix
  def self.force_utf8(obj)
    case obj
    when String then obj.encode('UTF-8', invalid: :replace, undef: :replace, replace: '?')
    when Hash   then obj.transform_values { |v| force_utf8(v) }
    when Array  then obj.map { |v| force_utf8(v) }
    else obj
    end
  end
end

Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

use Rack::Static,
    urls: Inferno::Utils::StaticAssets.static_assets_map,
    root: Inferno::Utils::StaticAssets.inferno_path

Inferno::Application.finalize!

use Inferno::Utils::Middleware::RequestLogger

run Inferno::Web.app
