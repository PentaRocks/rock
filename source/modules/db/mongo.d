﻿module modules.db;

import vibe.d;
import config;

class Mongo
{
	public MongoClient client;
	private Config conf;

	this(Config configuration)
	{
		conf = configuration;
	}

	public void connect(){
        import std.format;
        if(conf.get("mongoUser").length){
            client = connectMongoDB( format( "mongodb://%s:%s@%s:%s/", 
                conf.get("mongoUser") ,
                conf.get("mongoPass") ,
                conf.get("mongoHost") ,
                conf.get("mongoPort") 
            ));
        } else  {
            client = connectMongoDB(  format( "mongodb://%s:%s/",             
                conf.get("mongoHost") ,
                conf.get("mongoPort") 
            ));
        }
        //mongodb://<username>:<password>@<hostname>:<port>/
        
	}

	public MongoDatabase getDatabase( string dbName = "")
	{
		if(dbName == ""){
			dbName = conf["mongoDB"];
		}
		return client.getDatabase( dbName );
	}

	public MongoCollection getCollection ( string colName ) 
	{
		if (colName.indexOf('.') == -1)
		{
			colName = conf["mongoDB"] ~ "." ~ colName;
		}
		return client.getCollection(colName);
	}
}

