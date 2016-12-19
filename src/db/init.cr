require "sqlite3"
module DB
  class Instance
    @@dataDir : String = "./data"
    @@filePath : String = @@dataDir + "/main.db"
    def initialize()
      puts "Initializing DB"
      if !File.exists?(@@filePath)
        generateDB
      end

      readDB
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

    def needsSetup

    end

  end
end
