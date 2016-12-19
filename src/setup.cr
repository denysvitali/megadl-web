db = DB::Instance.new
if !db.readVal("setup_completed",false)
  get "/setup" do |x|
    "Setup..."
    db.putVal("setup_completed", true)
  end
end
