Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, ENV["GITHUB_CLIENT_ID"], ENV["GITHUB_CLIENT_SECRET"], scope: "user:email"
                  #^has to match .env id name #matches .env secret      #^the provider specifies what we're allowed to ask for
end
