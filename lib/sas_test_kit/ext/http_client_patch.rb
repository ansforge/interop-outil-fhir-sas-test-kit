module HTTPClientBuilderMTLSPatch
  def build(runnable, block)
    self.runnable = runnable

    instance_exec(self, &block)

    params = { url: }
    params.merge!(headers:) if headers

    Faraday.new(params) do |f|
      f.request :url_encoded
      f.use FaradayMiddleware::FollowRedirects

      
      if runnable.respond_to?(:mTLS) &&
              runnable.mTLS == 'true'

        f.ssl.client_cert = OpenSSL::X509::Certificate.new(File.read("#{ENV["CERT_PATH"]}/inferno-prePROD.pem"))
        f.ssl.client_key  = OpenSSL::PKey::RSA.new(File.read("#{ENV["CERT_PATH"]}/inferno-prePROD.key"))
        f.ssl.verify = true
      else
        f.ssl.verify = false
      end
    end
  end
end