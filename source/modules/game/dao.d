module modules.game.dao;

import modules.db;
import modules.game.game;
import vibe.d;


class GameDAO {

	private Mongo db;
	private MongoCollection collection;
	enum collectionName = "games";

	this(Mongo client)
	{
		db = client;
		collection = db.getCollection(collectionName);
	}


	public void insert(Game game) 
	{
		collection.insert(game);
	}

	public void save(Game game)
	{
	   
		collection.update(["_id": game.id ], game);
	}

	public Game getGame( Json query= Json.emptyObject) {

		auto data = collection.findOne( query );		
		Game game = data.deserializeBson!Game;
		return game;

	}

	public Game getGame(Bson query) {
		 
		auto data = collection.findOne(query);
		Game game = data.deserializeBson!Game;
		return game;
	}

	public Game[] getGames( Json query = Json.emptyObject )
	{
		auto cursor = collection.find( query );		
		Game[] games;
		foreach( data; cursor){
			games ~= data.deserializeBson!Game;
		}

		return games;
	}

	



}


