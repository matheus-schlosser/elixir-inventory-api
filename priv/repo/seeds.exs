# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     AdminApi.Repo.insert!(%AdminApi.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

# alias AdminApi.{Repo, User}

# AdminApi.Repo.insert!(%AdminApi.Clients{
#   usr_name: "Matheus Schlösser",
#   usr_email: "matheus@gmail.com",
#   usr_password: "admin"
# })

# AdminApi.Accounts.create_user(%{
#   name: "Matheus Schlösser",
#   email: "matheus@gmail.com",
#   password: "admin"
# })

# AdminApi.Accounts.create_client(%{
#   name: "Company 1",
#   description: "Short description ...",
#   tag: "IT, Software")
# })

# AdminApi.Accounts.create_category(%{
#   name: "Company 1",
#   description: "Short description ...",
#   tag: "IT, Software")
# })


#Other Example
# Repo.insert! %Business{name: "Company 1", description: "Short description ...", tag: "IT, Software"}
