get "/setup" do |x|
  db = DB::Instance.new
  if !db.readVal("setup_completed",false)
    db.putVal("setup_completed", true)
    "Setup..."
  else
    x.redirect "/"
  end
end

get "/reset" do |x|
  db = DB::Instance.new
  if db.readVal("setup_completed",false)
    db.reset
    "Reset"
  else
    x.redirect "/"
  end
end
