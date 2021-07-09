import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/date_time_patterns.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class itemlist extends StatefulWidget {
  const itemlist({Key key}) : super(key: key);

  @override
  _itemlistState createState() => _itemlistState();
}

class _itemlistState extends State<itemlist> {
  var firestoredb = Firestore.instance.collection("itemslist").snapshots();
  TextEditingController ItemNameController = new TextEditingController();
  TextEditingController ItemDescriptionController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ItemsList'),
      ),
      body: StreamBuilder(
        stream: firestoredb,
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, int index) {
                return customcardlistview(
                  snapshot: snapshot.data,
                  index: index,
                );
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  _showDialog(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              contentPadding: EdgeInsets.all(10),
              content: Column(
                children: [
                  Text("Add Items"),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: TextField(
                      autofocus: false,
                      decoration: InputDecoration(labelText: "Item Name"),
                      controller: ItemNameController,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: TextField(
                      maxLines: 6,
                      autofocus: false,
                      decoration: InputDecoration(labelText: "Description"),
                      controller: ItemDescriptionController,
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    ItemDescriptionController.clear();
                    ItemNameController.clear();
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                    onPressed: () {
                      Firestore.instance.collection('itemslist').add({
                        "itemname": ItemNameController.text,
                        "description": ItemDescriptionController.text,
                        "timestamp": new DateTime.now(),
                      }).then((value) {
                        print(value.documentID);
                        ItemDescriptionController.clear();
                        ItemNameController.clear();
                      }).catchError((error) => print(error));
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Add',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ))
              ],
            ));
  }
}

class customcardlistview extends StatelessWidget {
  final QuerySnapshot snapshot;
  final int index;
  const customcardlistview({Key key, this.snapshot, this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var snapshotData = snapshot.documents[index].data;
    var docID= snapshot.documents[index].documentID;
    TextEditingController ItemNameController = new TextEditingController(text: snapshotData['itemname']);
    TextEditingController ItemDescriptionController = new TextEditingController(text: snapshotData['description']);
    var timetodate = new DateTime.fromMillisecondsSinceEpoch(snapshot.documents[index].data['timestamp'].seconds * 1000);
    var dateFormatted = new DateFormat("EEEE, MMM d").format(timetodate);
    return Container(
      height: MediaQuery.of(context).size.height * 0.21,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    snapshot.documents[index].data['itemname'],
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(snapshot.documents[index].data['description']),
                  leading: CircleAvatar(
                    radius: 30,
                    child: Icon(Icons.safety_divider),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                  Container(
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () async {
                            await showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                              contentPadding: EdgeInsets.all(10),
                              content: Column(
                                children: [
                                  Text("Add Items"),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: TextField(
                                      autofocus: false,
                                      decoration: InputDecoration(labelText: "Item Name"),
                                      controller: ItemNameController,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: TextField(
                                      maxLines: 6,
                                      autofocus: false,
                                      decoration: InputDecoration(labelText: "Description"),
                                      controller: ItemDescriptionController,
                                    ),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                    onPressed: () {
                                      if(ItemNameController.text.isNotEmpty&&ItemDescriptionController.text.isNotEmpty)
                                        {
                                          Firestore.instance.collection("itemslist").document(docID).updateData(
                                              {"itemname": ItemNameController.text,
                                                "description" : ItemDescriptionController.text,

                                              }
                                              ).then((value) => {Navigator.pop(context)}
                                              );

                                        }
                                    },
                                    child: Text('Edit',))
                              ],
                            ));

                          },
                          icon: Icon(
                            Icons.edit,
                            size: 18,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            var ColloctionReference = Firestore.instance.collection("itemslist");
                            await ColloctionReference.document(docID).delete();
                          },
                          icon: Icon(
                            Icons.delete,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                  ),



                    Container(
                      child: Text(dateFormatted),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,

                  children: [

                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
