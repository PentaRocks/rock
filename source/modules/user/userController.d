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

class UserController : AbstractController
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
        
		router.get("/user/*", &getUser);
		router.get("/users", &getUsers);
		router.post("/user/", &registerUser);
		router.get("/users/populate/:count", &populate);
        router.any("*", &emptyRespose);
	}

	void getUser(HTTPServerRequest req, HTTPServerResponse res)
	{
		prepareResponse(res);
		User user = dao.getUser();		
		res.writeBody( user.serializeToJsonString , "application/json");
	}

	void getUsers(HTTPServerRequest req, HTTPServerResponse res)
	{
		prepareResponse(res);
		User[] users = dao.getUsers();		
		res.writeBody( users.serializeToJsonString , "application/json");
	}

	void populate(HTTPServerRequest req, HTTPServerResponse res)
	{
		int count = req.params["count"].to!int;
		dao.populateDb(count);
		res.redirect("/users");

	}
	
	void registerUser(HTTPServerRequest req,
		HTTPServerResponse res){

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

