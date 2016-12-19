require "./megadl-web/*"
require "kemal"
require "./routing/router.cr"
require "./db/init.cr"
require "./setup.cr"

module Megadl::Web
  db = DB::Instance.new
  db.readDB
  Kemal.run
end
