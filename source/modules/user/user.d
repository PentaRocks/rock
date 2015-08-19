module modules.user.user;

import vibe.data.bson;
import vibe.core.log;
class User
{

	private BsonObjectID _id;
	private string _username;
	private string _email;
	private string _password;
	private string _status;

	string username() const @property {
		return _username;
	}

	public void username( string value ) @property {
		_username = value;
	}

	
	string email() const @property {
		return _email;
	}
	
	public void email( string value ) @property {
		_email = value ;
	}

	string password() const @property {
		return _password;
	}

	public void password( string value ) @property {
		_password = value;
	}
	string status() const @property {
		return _status;
	}

	public void status( string value ) @property {
		_status = value;
	}
	  
	@name("_id") @optional
	public BsonObjectID id() @property {
		if( !_id.valid ) 
			_id = BsonObjectID.generate;
		return _id;
	}
	@name("_id") @optional
	public void id(BsonObjectID value)  @property {
		_id = value;
	}


	public void update(Json userFields) {
		import std.stdio;
		
		//writeln("status type", userFields["status"].type)		;
		//writeln("status ",userFields["status"]);
		//writeln("equals undefined", userFields["status"] == Json.undefined);
		//writeln("is undefined", userFields["status"] is Json.undefined);
		//writeln("type is undefined", userFields["status"].type is Json.undefined.type);
		//writeln("type eqals undefined", userFields["status"].type == Json.undefined);


		if(userFields["email"].type !is Json.undefined.type ){
			email =userFields["email"].get!string;
		}
		if(userFields["username"].type !is Json.undefined.type ){
			username = userFields["username"].get!string;
		}
		if(userFields["password"].type !is Json.undefined.type ){
			password = userFields["password"].get!string;
		}
		if(userFields["status"].type !is Json.undefined.type ){
			status = userFields["status"].get!string;
		}

	}

	


	this()
	{
		// Constructor code
	}


}

