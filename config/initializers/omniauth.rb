Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['147507248699725'], ENV['84388faa031550cc015d39191a32f513']
end