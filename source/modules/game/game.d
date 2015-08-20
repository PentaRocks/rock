module modules.game.game;

import vibe.data.bson;
import vibe.core.log;

alias PlayerCasts = int[string];

class Game 
{
	private BsonObjectID _id;
	private string _status;
	private string[] _players;
	private PlayerCasts _casts;
	private int _noPlayers = 2;
	private string _result;
	private string _winner;


	public int noPlayers()  @property 
	{
		return _noPlayers;
	}
	
	public void noPlayers(int value) @property
	{
		_noPlayers = value;
	}

	string status()  @property {
		return _status;
	}

	public void status( string value ) @property {
		_status = value;
	}

	@optional
	string winner() const @property {
		return _winner;
	}

	@optional
	public void winner( string value ) @property {
		_winner = value;
	}

	@optional
	string result() const @property {
		return _result;
	}

	@optional
	public void result( string value ) @property {
		_result = value;
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

	public string[] players() @property 
	{
		return _players;
	}

	public void players(string[] value) @property 
	{
		_players = value;
	}
	

	public PlayerCasts casts() @property
	{
		return _casts;
	}

	public void casts(PlayerCasts value) @property
	{
		_casts = value;
	}

	public void setCast(string index, int value)
	{
		_casts[index] = value;			
	}

	/**
	* this assumes 2 players
	*/
	public void score(){
		if( _casts.length < _noPlayers) return;
		auto keys = _casts.keys;
		auto result = calculateWinner(  _casts[ keys[0] ], _casts[ keys[1] ]);
		if( result <2 ){
			_winner = keys[ result ];
		}
	}

	public int calculateWinner( int cast1, int cast2){
		int d =  (5 + cast1 - cast2) % 5;
		if( d == 1 || d == 3 ){
			return 1;
		} else if (  d == 2 || d == 4 ){
			return 0;
		} else {
			return 2;
		}
	}



}
