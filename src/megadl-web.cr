require "./megadl-web/*"
require "kemal"
require "./routing/router.cr"
require "./db/init.cr"
require "./setup.cr"
require "./plugins/cyrose/cyrose.cr"
require "./plugins/reddit/reddit.cr"

module Megadl::Web
  db = DB::Instance.new
  db.readDB

  cyrose = Cyrose.new
  #cyrose.fetch

  reddit = Reddit.new
  #reddit.fetch

  Kemal.run
end
