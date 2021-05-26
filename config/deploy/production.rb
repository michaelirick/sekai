set :stage, :production
# server-based syntax
# ======================
# Defines a single server with a list of roles and multiple properties.
# You can define all roles on a single server, or split them:

# server "example.com", user: "deploy", roles: %w{app db web}, my_property: :my_value
# server "example.com", user: "deploy", roles: %w{app web}, other_property: :other_value
server "yuusekai.michaelirick.com", user: "ubuntu", roles: %w{app web db}



# role-based syntax
# ==================

# Defines a role with one or multiple servers. The primary server in each
# group is considered to be the first unless any hosts have the primary
# property set. Specify the username and a domain or IP for the server.
# Don't use `:all`, it's a meta role.

role :app, %w{ubuntu@yuusekai.michaelirick.com}
role :web, %w{ubuntu@yuusekai.michaelirick.com}
role :db, %w{ubuntu@yuusekai.michaelirick.com}

