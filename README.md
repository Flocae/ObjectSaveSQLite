# ObjectSaveSQLite

Sample Adobe Air application (made with Apache Flex framework - http://flex.apache.org) which save objects into an SQLite database.

This is a flexible and simply way I use to store data on the same db table. I mean, let you imagine an application which initially store two variables, e.g. age & gender. These data will be stored in an Objet (DataObject.age,DataObject.gender). Next time, you can easily add an extra variable simply by adding to your object this new variable (DataObject.age,DataObject.gender,DataObject.myExtraVariable). Currently, structure of the table is as follows: [ID][TextID][DataObject], 

[ID] = unique ID which is auto-incremented,
[TextID] = whatever you want; e.g. person’s name,
[DataObject] = an Object, that contain all the variables you want,

You can directly install the application to test it (ObjectSave.air; adobe air runtime required : https://get.adobe.com/fr/air/)

////////////////////////////////////////////////////////////////////////////

USAGE :
 
#First create an instance: 
var _myDB:ObjectSQLsave=new _myDB:ObjectSQLsave("DATABASE_NAME");

#Add new variables:
_myDB.dataObject= new Object(); 
_myDB.dataObject.stringVar = "Hello";
_myDB.dataObject.intVar=2;
_myDB.dataObject.numberVar=34.890;
_myDB.addNew(stringIdentifier); //stringIdentifier, e.g. a person’s name
  
#Replace data
_myDB.id=id; // Need an ID to select data
_myDB.dataObject.stringVar = "Hello again";
_myDB.dataObject.intVar=2;
_myDB.dataObject.numberVar=34.890;
_myDB.flush();// like sharedObject
 
#Get DATA
_myDB.getInfoById(id); // This method populate an ArrayCollection with data name
—> _myDB.arrayCollectionData[i][0], and values —> arrayCollectionData[i][1];

////////////////////////////////////////////////////////////////////////////

The ObjectSQLsave class is an edition of the SQLsave class originally made by Lucas Paakh (www.particlasm.com)

Florent Caetta 20016-12
