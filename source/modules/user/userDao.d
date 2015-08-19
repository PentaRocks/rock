module modules.user.userDao;

import modules.db;
import modules.user.user;
import vibe.d;
import vibe.data.serialization;


class UserDAO
{
	private Mongo db;
	private MongoCollection collection;
	enum collectionName = "users";

	this(Mongo client)
	{
		db = client;
		collection = db.getCollection(collectionName);
	}

	void insert(Json user){
		User dbUser = user.deserializeJson!User	;
		collection.insert(dbUser);
	}

	void insert(User user){
		collection.insert(user);
	}

	void save(User user){
		collection.update(["_id": user.id ], user);
	}


	void save(BsonObjectID id, Json userFields){

		auto userData = collection.findOne(["_id": id ]);
		if(userData == Bson.emptyObject ) return;
		User user = userData.deserializeBson!User;
		user.update(userFields);
		save(user);
		
	}

	User getUser(Json userQuery= Json.emptyObject) {

		auto data = collection.findOne( userQuery );		
		User user = data.deserializeBson!User;
		return user;
	}





	User[] getUsers(Json userQuery= Json.emptyObject) 
	{
		auto cursor = collection.find( userQuery );		
		User[] users;
		foreach( data; cursor){
			users ~= data.deserializeBson!User;
		}

		return users;
	}

	/**
	* cannot read the file in openshift, remove this
	*/
	void populateDb(int count){
		import std.file;
		import std.array;
		import std.random;
		auto contents = readText("random_names.txt").split;
		auto randomList = randomCover(contents);
		for(int i =0; i< count; i++){
			auto user = new User;
			string p1, p2, p3, p4;
			p1 = randomList.front(); randomList.popFront();
			p2 = randomList.front(); randomList.popFront();
			p3 = randomList.front(); randomList.popFront();
			p4 = randomList.front(); randomList.popFront();
			user.username = toLower(p1 ~ "_" ~p2);
			user.email = toLower(p1 ~"-"~ p2 ~"@" ~ p3 ~".com");
			user.password = p4;
			user.status = "active";
			collection.insert(user);

		}
	}
	
}

