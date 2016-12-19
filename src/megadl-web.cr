require "./megadl-web/*"
require "kemal"
require "./routing/router.cr"
require "./db/init.cr"

module Megadl::Web
  db = DB::Instance.new
  Kemal.run
end
