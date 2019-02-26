import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

const String _name = "Your name";
final GlobalKey _key = GlobalKey();


class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.animationController});
  final String text;
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    var key = GlobalKey();
    return new SizeTransition(
      sizeFactor: new CurvedAnimation(parent: animationController, curve: Curves.easeOut),
      axisAlignment: 0.0,
      child: InkWell(
        key: key,
        onTap: () {
          RenderBox renderBox = key.currentContext.findRenderObject();
          print("${renderBox.localToGlobal(Offset.zero, ancestor: _key.currentContext.findRenderObject())}");
        },
        child: new Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Container(
                margin: const EdgeInsets.only(right: 16.0),
                child: new CircleAvatar(child: new Text(_name[0])),
              ),
              new Expanded(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(_name, style: Theme.of(context).textTheme.subhead,),
                    new Container(
                      margin: const EdgeInsets.only(top: 5.0),
                      child: new Text(text),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {

  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = new TextEditingController();
  bool _isComposing = false;

  void _handleSubmitted(String text) {
    _textController.clear();
    setState(() {
      _isComposing = false;
    });
    ChatMessage message = new ChatMessage(
      text: text,
      animationController: new AnimationController(
          vsync: this,
          duration: new Duration(milliseconds: 700)
      ),
    );
    setState(() {
      _messages.insert(0, message);
    });
    message.animationController.forward();
  }

  Widget _buildTextComposer() {
    return new IconTheme(
        data: new IconThemeData(color: Theme.of(context).accentColor),
        child: new Container(
          margin: const EdgeInsets.symmetric(
              horizontal: 8.0
          ),
          child: new Row(
            children: <Widget>[
              new Flexible(
                  child: new TextField(
                    autofocus: true,
                    controller: _textController,
                    onEditingComplete: () {
                      print("111");
                    },
                    onSubmitted: (String txt) {
                      print("222");
                      _handleSubmitted(txt);
                    },
//                    textInputAction: TextInputAction.done,
                    onChanged: (String text) {
                      setState(() {
                        _isComposing = text.length > 0;
                      });
                    },
                    decoration: new InputDecoration.collapsed(hintText: "Send a message"),
                  )
              ),
              new Container(
                margin: new EdgeInsets.symmetric(horizontal: 4.0),
                child: Theme.of(context).platform == TargetPlatform.iOS ?
                new CupertinoButton(
                    child: new Text('Send'),
                    onPressed: () => _isComposing ? _handleSubmitted(_textController.text) : null
                ) :
                new IconButton(
                    icon: new Icon(Icons.send),
                    onPressed: () => _isComposing ? _handleSubmitted(_textController.text) : null
                ),
              )
            ],
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Friendlychat"),
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
      ),
      body: new Container(
        child: new Column(
          children: <Widget>[
            new Flexible(
                child: new ListView.builder(
                  key: _key,
                  padding: new EdgeInsets.all(8.0),
                  reverse: true,
                  itemBuilder: (_, int index) => _messages[index],
                  itemCount: _messages.length,
                )
            ),
            new Divider(height: 1.0,),
            new Container(
              decoration: new BoxDecoration(
                color: Theme.of(context).cardColor,
              ),
              child: _buildTextComposer(),
            )
          ],
        ),
        decoration: Theme.of(context).platform == TargetPlatform.iOS ? new BoxDecoration(
            border: new Border(
                top: new BorderSide(color: Colors.grey[200])
            )
        ) : null,
      ),
    );
  }

  @override
  void dispose() {
    for (var message in _messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }
}

class ChatScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new ChatScreenState();

}

class FriendlychatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: "Friendlychat",
        home: new ChatScreen()
    );
  }
}