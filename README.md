<h1 align="center">Inventory Api</h1>

<p align="center">
  <a href="#project">Project</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
  <a href="#technologies">Technologies</a>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
  <a href="#usage">Usage</a>
</p>

## Project

Project with CRUD operations that simulates inventory operations.

## Technologies

The project was developed with the following technologies:

- [Elixir](https://github.com/elixir-lang/elixir)
- [Ecto](https://github.com/elixir-ecto/ecto)

## Prerequisites

You will need a instance of PostgresSQL (local, remote or using container through  docker), install Elixir and Phoenix before following the instructions below.

## Usage

- Clone the repository with `git clone https://github.com/matheus-schlosser/elixir-admin-api.git`
- Acess the repository with admin-api `cd elixir-admin-api`
- Install dependencies with `mix deps.get`
- Edit the config dev.exs and test.exs file to point to the Postgres instance 
- Create and migrate your database with `mix ecto.setup`
- Start Phoenix endpoint with `mix phx.server`

It will start your server on [`localhost:4000`](http://localhost:4000)

Obs.: To use the project routes, the token got on login must be provided in the requisition header.

- You can run the tests with `mix test or mix test --cover` 