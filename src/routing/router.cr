get "/" do |x|
  db = DB::Instance.new
  if !db.readVal("setup_completed",false)
    x.redirect "/setup"
    next
  end
  File.read("./public/index.html")
end

get "/login" do

end
