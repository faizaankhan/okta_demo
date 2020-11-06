#
# A SAML service provider controller
#

class SamlController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:acs]
  skip_before_action :require_authentication
  skip_before_action :require_authorization

  #
  # GET /saml/login
  #
  # SP initiated login action. Redirects to IdP.
  # acts as the SAML entry point for your application
  # where a valid SAML request is created and redirected to your Okta IDP.
  #
  def login
    request = OneLogin::RubySaml::Authrequest.new
    redirect_to(request.create(saml_settings))
  end

  #
  # POST /saml/acs
  #
  # Assertion Consumer Service URL. The endpoint that the IdP posts to.
  # it acts as your SAML response consume endpoint
  # for your application where the response is validated against your metadata.
  #
  def acs
    response = OneLogin::RubySaml::Response.new(params[:SAMLResponse], settings: saml_settings)
    reset_session

    session[:email] = response.nameid
    redirect_to root_url
  end

  #
  # POST /saml/logout
  #
  def logout
    reset_session
    render plain: 'Logged Out'
  end

  private

  def saml_settings
    @settings ||= begin
      if ENV['IDP_METADATA_URL']&.present?
        OneLogin::RubySaml::IdpMetadataParser.new.parse_remote(ENV['IDP_METADATA_URL'])
      else
        raise StandardError, 'The environment variable IDP_METADATA_URL is not set.'
      end
    end
  end
end
