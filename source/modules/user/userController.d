module modules.user.userController;

import controlers;
import vibe.d;
import config;
import std.stdio;
import std.utf;

import modules.user.userDao,
	modules.user.user,
	modules.user.registration;

import std.encoding;


/**
*
*/
interface UserAPI 
{

	Json getUser(string email);

	@before!parseQuerystring("query")
	Json getUsers(Json query);
	void postUser(User user);
	void putUser(User user);
	void patchUser(string userId, Json userFields);
	//void updateUser(string id );	
}


Json parseQuerystring(HTTPServerRequest req, HTTPServerResponse res)
{
	Json queryJson = Json.emptyObject;
	foreach(key, value; req.query){
		queryJson[ key ] = value;
	}
	return queryJson;
}

class UserController : AbstractController  , UserAPI
{
	Registration registrationService;
	UserDAO dao;

	this(URLRouter router, Config configuration, Registration reg, UserDAO dao)
	{
		super(router, configuration);
		this.dao = dao;
		registrationService = reg;
	}

	
	public override void registerRoutes(){
        registerRestInterface(router, this);

		// replaced by restInterfaceGenerator
		//router.get("/user/*", &getUser);  
		//router.get("/users", &getUsers);
		//router.post("/user/", &registerUser);
		router.get("/users/populate/:count", &populate);
        router.any("*", &emptyRespose);
	}

	
	
	override Json getUser(string userId)
	{
		Json query = Json.emptyObject;
		query["email"] = userId;
		return dao.getUser( query ).serializeToJson;	
	}

	// old function
	//void getUser(HTTPServerRequest req, HTTPServerResponse res)
	//{
	//    prepareResponse(res);
	//    
	//    User user = dao.getUser();		
	//    
	//    res.writeBody( user.serializeToJsonString , "application/json");
	//}

	override Json getUsers(Json query)
	{
		return dao.getUsers( query ).serializeToJson;		
	}

	void postUser(User user){
		dao.insert(user);
	}

	void putUser(User user){
		dao.save(user);
	}

	void patchUser(string userId, Json userFields)
	{
		dao.save( BsonObjectID.fromString(userId), userFields);
	}
	void populate(HTTPServerRequest req, HTTPServerResponse res)
	{
		int count = req.params["count"].to!int;
		dao.populateDb(count);

	}
	
	void registerUser(HTTPServerRequest req, HTTPServerResponse res)
	{

		try{
			
			registrationService.register(req.json);

			prepareResponse(res);
			res.writeBody(req.json.toString, "application/json");

		}
		catch (Exception e){
			logInfo(e.msg);
		}
	}
}

