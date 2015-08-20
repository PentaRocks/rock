module app;

import vibe.d;
import mongotest;
import modules.user.userController;
import modules.user.userDao;
import modules.user.registration;
import modules.game.dao,
	modules.game.controller;
import modules.db;
import config;

shared static this()
{
	auto conf = Config.getInstance();


	auto settings = new HTTPServerSettings;
	settings.bindAddresses = [ conf.get("selfIp") ];
	settings.port =  conf.get("port").to!ushort;

	auto router = new URLRouter;

	// DB
	auto mongoDb= new Mongo(conf);
	mongoDb.connect();

	//just playing around , this should be removed
	router.get("/mongo", &mongoT);

	// USER
	auto userD = new UserDAO(mongoDb);
	auto reg = new Registration(userD);
	auto gameCtrl = new GameController(router, conf, new GameDAO(mongoDb));
	router.registerRestInterface(gameCtrl);
	auto userCtrl = new UserController(router, conf, reg, userD);
	userCtrl.registerRoutes();

	
	listenHTTP(settings, router);
}
