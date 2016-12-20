require "../template/template.cr"
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
