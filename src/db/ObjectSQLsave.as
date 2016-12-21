/** 
 * Class originaly designed by Lucas Paakh (www.particlasm.com)
 * Edited & implemented by Florent Caetta 12-2016
**/
package db {
	
	import flash.data.SQLConnection;
	import flash.data.SQLMode;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	import mx.controls.Alert;
	
	public class ObjectSQLsave {
		
		// -- VARIABLES DECLARATION			
		// Data
		public var dataObject:Object; // Data (variables) will populate this object
		private var _id:int;// the unique ID for each entry
		private var _textID:String="TextID";//
		private var _arrayCollectionData:Array;// _arrayCollectionData[i][0] = Data name; _arrayCollectionData[i][1] = Data value
		private var _nEntries:int;
		// DB
		private var connection:SQLConnection;
		private var statement:SQLStatement;
			
		public function ObjectSQLsave(name:String):void {
			
			dataObject=new Object();
			var file:File;// file for DB
			// Append the .db to the file name if there isn't one
			if (name.substring(name.length - 3) != ".db"){
				name += ".db"
			}
			// Open or create the file
			file = File.documentsDirectory.resolvePath(name);// located in my documents;  For application storage directory use: File.applicationStorageDirectory.resolvePath(name)
			// Connection
			connection = new SQLConnection();	
			// Start the connection
			connection.addEventListener(SQLEvent.OPEN, onOpen);
			connection.open(file, SQLMode.CREATE, false,1024);//if encryption required : connection.open(file, SQLMode.CREATE, false, 1024, encryptionKey);
		}
		
		// Create table (if not exists)
		private function onOpen(e:SQLEvent):void {
			connection.removeEventListener(SQLEvent.OPEN, onOpen);
			statement = new SQLStatement();
			statement.sqlConnection = connection;
			statement.text = "CREATE TABLE IF NOT EXISTS info (id INTEGER PRIMARY KEY AUTOINCREMENT, textID TEXT, data OBJECT)";
			statement.addEventListener(SQLEvent.RESULT, getNEntries);
			statement.execute();
		}	
		
		// Get number of entry
		private function getNEntries(e:SQLEvent):void {
			connection.removeEventListener(SQLEvent.OPEN, onOpen);
			statement = new SQLStatement();
			statement.sqlConnection = connection;
			statement.text = "SELECT count(*) as nRow FROM info";
			statement.execute();
			var result:Array=statement.getResult().data;
			_nEntries=int(result[0].nRow);// get number of row /entries
			
		}
		
		// select data
		private function loadItems(e:SQLEvent):void {
			statement.removeEventListener(SQLEvent.RESULT, loadItems);
			statement = new SQLStatement();
			statement.sqlConnection = connection;
			statement.text = "SELECT data FROM info WHERE id='"+_id+"';";
			statement.addEventListener(SQLEvent.RESULT, onSelected);
			statement.execute();
		}
		
		// once they're selected, populate the variables
		private function onSelected(e:SQLEvent):void {
			statement.removeEventListener(SQLEvent.RESULT, onSelected);	
			var result:SQLResult = SQLStatement(e.target).getResult();
			//trace(ObjectUtil.toString(result))
			_arrayCollectionData = new Array(); 
			if (result.data && result.data.length > 0){
				dataObject = result.data[0].data;
				//Get all the element of an object			
				var i:int=0;
				for (var x:String in dataObject) {
					_arrayCollectionData[i]=[x, dataObject[x]];
					i++;
				}		
			}
			else
			{
				dataObject=null;
				Alert.show("No match found with the requested ID","Error",Alert.OK);
			}
		}	

		// Raplace the "data" object to the database.
		public function flush():void {					
			statement = new SQLStatement();
			statement.sqlConnection = connection;
			statement.text = "SELECT data FROM info WHERE id='"+_id+"';";
			statement.addEventListener(SQLEvent.RESULT, flushHelper);
			statement.execute();			
		}
		
		public function getInfoById(id:int=NaN):void {					
			statement = new SQLStatement();
			statement.sqlConnection = connection;
			statement.text = "SELECT data FROM info WHERE id='"+id+"';";
			statement.addEventListener(SQLEvent.RESULT, onSelected);
			statement.execute();		
		}
		
		public function addNew(textID:String=""):void
		{
			statement = new SQLStatement();
			statement.sqlConnection = connection;
			statement.parameters["@data"] = dataObject;
			statement.text = "INSERT INTO info (textID,data) VALUES ('"+textID+"',@data)";
			statement.execute();
		}
		
		private function flushHelper(e:SQLEvent):void {	
			statement.removeEventListener(SQLEvent.RESULT, flushHelper);	
			var result:SQLResult = SQLStatement(e.target).getResult();		
			statement = new SQLStatement();
			statement.sqlConnection = connection;
			statement.parameters["@data"] = dataObject;	
			// if an entry exists, update it, otherwise add a new one
			if (result.data && result.data.length > 0) {
				statement.text = "UPDATE info SET data=@data WHERE id='"+_id+"';";
			} else {	
				statement.text = "INSERT INTO info (data) VALUES (@data)";
			}	
			statement.execute();
		}
		
		// -- ACCESSORS 
		public function get arrayCollectionData():Array
		{
			return _arrayCollectionData;
		}
		
		public function set arrayCollectionData(value:Array):void
		{
			_arrayCollectionData = value;
		}
		
		public function get id():int
		{
			return _id;
		}
		
		public function set id(value:int):void
		{
			_id = value;
		}
		public function get nEntries():int
		{
			return _nEntries;
		}
		
		public function set nEntries(value:int):void
		{
			_nEntries = value;
		}
			
	} 
	
} 

