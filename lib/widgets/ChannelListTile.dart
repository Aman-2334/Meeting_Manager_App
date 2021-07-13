import 'package:flutter/material.dart';

class ChannelListTile extends StatefulWidget {
  final String title;
  final Function _deleteItem;
  final int index;
  const ChannelListTile(this.title,this._deleteItem,this.index);

  @override
  State<ChannelListTile> createState() => _ChannelListTileState();
}

class _ChannelListTileState extends State<ChannelListTile> {

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Icon(Icons.account_circle),
      ),
      title: Text(widget.title),
      trailing: IconButton(
        icon: Icon(Icons.delete_outline,color: Theme.of(context).colorScheme.error,),
        onPressed: () => showModalBottomSheet(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
          ),
          context: context,
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 3,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.black38,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      child: Text(
                        'This action is irreversible, Confirm delete.',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('Cancel'),
                        ),
                        SizedBox(width: 10),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            widget._deleteItem(widget.index);
                          },
                          child: Text(
                            'Delete',
                            style: TextStyle(color: Theme.of(context).colorScheme.error),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
