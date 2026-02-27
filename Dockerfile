FROM ruby:3.3.6

ENV INSTALL_PATH=/opt/inferno/
ENV APP_ENV=production
RUN mkdir -p $INSTALL_PATH

WORKDIR $INSTALL_PATH

ADD lib/sas_test_kit/version.rb $INSTALL_PATH/lib/sas_test_kit/version.rb
ADD *.gemspec $INSTALL_PATH
ADD Gemfile* $INSTALL_PATH
RUN gem install bundler
# The below RUN line is commented out for development purposes, because any change to the
# required gems will break the dockerfile build process.
# If you want to run in Deploy mode, just run `bundle install` locally to update
# Gemfile.lock, and uncomment the following line.
# RUN bundle config set --local deployment 'true'
RUN bundle install

ADD . $INSTALL_PATH

# Fix gems to manage mTLS
COPY gems_to_update/inferno_core-0.6.17/lib/inferno/dsl/fhir_client_builder.rb /usr/local/bundle/gems/inferno_core-0.6.17/lib/inferno/dsl/fhir_client_builder.rb
COPY gems_to_update/inferno_core-0.6.17/lib/inferno/entities/input.rb /usr/local/bundle/gems/inferno_core-0.6.17/lib/inferno/entities/input.rb
COPY gems_to_update/fhir_client-6.0.0/lib/fhir_client/client.rb /usr/local/bundle/gems/fhir_client-6.0.0/lib/fhir_client/client.rb
COPY gems_to_update/rest-client-2.1.0/lib/restclient.rb /usr/local/bundle/gems/rest-client-2.1.0/lib/restclient.rb

EXPOSE 4567
CMD ["bundle", "exec", "puma"]
