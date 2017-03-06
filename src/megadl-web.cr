require "./megadl-web/*"
require "kemal"
require "./db/init.cr"
require "./setup.cr"
require "./template/template.cr"


module Megadl::Web

  db = DB::Instance.new
  db.readDB


  f = Fetcher.new
  movies = f.fetch

  get "/" do |x|
    db = DB::Instance.new
    if !db.readVal("setup_completed",false)
      x.redirect "/setup"
      next
    end

    rview "src/views/index.ecr"
  end

  get "/login" do |x|
    db = DB::Instance.new
    if !db.readVal("setup_completed",false)
      x.redirect "/setup"
      next
    end
    rview "src/views/login.ecr"
  end

  Kemal.run
end
