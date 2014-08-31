require "sinatra"
require "sinatra/reloader"
require "pg"
require "pry"


############################# METHODS ######################################
def db_connection
  begin
    connection = PG.connect(dbname: 'recipes')

    yield(connection)

  ensure
    connection.close
  end
end


############################# ROUTES ######################################

get "/" do
  query = 'SELECT recipes.name, recipes.id FROM recipes ORDER BY recipes.name LIMIT 20'
  db_connection do |conn|
    @recipes = conn.exec(query)
  end
  erb :index
end

get "/recipes/:id" do
  id = params[:id]
  query = 'SELECT recipes.name, recipes.id, recipes.description, recipes.instructions, ingredients.name FROM recipes JOIN recipes.id ON ingredients.recipe_id'

  db_connection do |conn|
    @recipe = conn.exec(query, [id])
  end

  erb :show
end
