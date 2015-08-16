﻿module config;

class Config
{

	protected static string[string] data;

	protected static enum defaults = 
	[
		"allowCrossDomain" : "http://localhost:8383",
		"port" : "8080",
		"selfIp" : "127.0.0.1",
		"mongoHost":"127.0.0.1",
        	"mongoPort":"27017",
		"mongoUser": "",
        	"mongoPass": "",
		"mongoDB":"drock"
	];

	protected static enum envMap = [
		"OPENSHIFT_DIY_IP" : "selfIp",
		"OPENSHIFT_DIY_PORT": "port",
	        "OPENSHIFT_MONGODB_DB_HOST": "mongoHost",
	        "OPENSHIFT_MONGODB_DB_PORT": "mongoPort",
	        "OPENSHIFT_MONGODB_DB_USERNAME": "mongoUser",
	        "OPENSHIFT_MONGODB_DB_PASSWORD": "mongoPass"
	];
	/*
   Root User:     admin
   Root Password: 9Z2QrZYnuTYP
   Database Name: drock
    */

	static Config _instance;
	public static getInstance() 
	{
		if(_instance is null )
		{
			_instance = new Config;
			_instance.init();
		}
		return _instance;
	}

	/**
	 * init the config map,
	 * read defaults, 
	 * apply environment vars if set
	 * apply environment mappings ( used for openshift deployments )
	 * 
	 */
	protected void init()
	{
		import std.process;
	
		foreach( key, val; defaults)
		{
			data[key] = environment.get(key, val);
		}
		foreach(envKey, key; envMap) {
			data[key] = environment.get(envKey, data[key]);
		}
	
	}

	public string get(string key) 
	{
		if (key !in data)
            return "";
        
		return data[key];
	}

	public void set(string key, string val)
	{
		data[key] = val;
	}

    
    string opIndex(string key){
        return get(key);
    }
}

