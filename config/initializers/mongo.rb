# MongoMapper.connection = Mongo::Connection.new('localhost', 27017)
# MongoMapper.database = "fts"
$db = Mongo::Connection.new('localhost', 27017).db("fts")