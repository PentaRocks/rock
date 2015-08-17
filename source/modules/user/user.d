module modules.user.user;

class User
{
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



	this()
	{
		// Constructor code
	}


}

