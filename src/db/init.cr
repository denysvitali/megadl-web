require "sqlite3"
module DB
  class Instance
    @@dataDir : String = "./data"
    @@filePath : String = @@dataDir + "/main.db"
    def initialize()
      if !File.exists?(@@filePath)
        generateDB
      end
    end

    def openDB
      DB.open "sqlite3://" + @@filePath do |db|
        yield db
      end
    end

    def generateDB
      puts "Generating DB"
      begin
        if !Dir.exists?(@@dataDir)
          puts "Creating dir..."
          Dir.mkdir(@@dataDir)
        end
      rescue
        puts "okay..."
      end
      File.write(@@filePath, nil)
      self.openDB do |db|
          db.exec "create table settings (key string, value string)"
          db.exec "insert into settings values (?,?)", "gen_date", Time.now

          puts db.scalar "select * from settings"
      end
    end

    def readDB
      self.openDB do |db|
        begin
          puts db.scalar "select value from settings where key='gen_date'"
        rescue
          # It's a bit extreme, I know...
          puts "Unable to load gen_date, recreating database"
          generateDB
        end
      end
    end

    def readVal(@key : String, @defaultValue = false)
      self.openDB do |db|
      begin
        db.scalar "select value from settings where key=?", @key
      rescue
        defaultValue
      end
    end
    end

    def putVal(@key : (String | Nil), @value : Bool)
      self.putVal(@key, @value.to_s)
    end
    def putVal(@key : (String | Nil), @value : String)
      puts "key=" + @key.to_s + ", val=" + @value.to_s
      self.openDB do |db|
        begin
          res = nil
          begin
            db.scalar "select count(value) from settings where key=?", @key
          rescue err
            puts err
            res = nil
          end
          if res == nil || res.to_s == ""
            puts "Inserting..."
            puts "--" + res.to_s + "--"
            db.exec "insert into settings (key,value) values (?,?)", @key, @value
          else
            puts "Updating..."
            db.exec "update settings set value='?' where key='?'", @key, @value
          end
          puts res
        rescue er
          puts er
          false
        end
      end
    end
  end
end
