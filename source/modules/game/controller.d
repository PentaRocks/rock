module modules.game.controller;

import controlers;
import vibe.d;
import config;
import modules.game.dao;
import modules.game.game;

interface GameAPI
{
	@before!parseQuerystring("query")
	Game[] getGames(Json query);
	void putCast(string gameId, string userId, int choice);
	
}

class GameController : AbstractController, GameAPI
{
	
	protected GameDAO dao;

	this(URLRouter router, Config configuration, GameDAO dao)
	{
		super(router, configuration);
		this.dao = dao;
	}

	override
	public Game[] getGames(Json query) 
	{
		return dao.getGames(query);							
	}
	override
	public void putCast(string gameId, string userId, int choice) 
	{
		Bson query = Bson.emptyObject;
		query["_id"] = BsonObjectID.fromString(gameId);
		auto game = dao.getGame(query);
		game.setCast( userId, choice );
		dao.save(game);
	}

}