import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatbotPage extends StatefulWidget {
  @override
  _ChatbotPageState createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  TextEditingController _controller = TextEditingController();
  List<Map> _messages = [];
  bool _isLoading = false;

  // Function to send message to the FastAPI backend and receive response
  Future<void> sendMessage(String userMessage) async {
    setState(() {
      _messages.add(
          {'role': 'user', 'text': userMessage, 'timestamp': DateTime.now()});
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://localhost:5000/chat'), // Replace with your deployed server URL
        headers: {"Content-Type": "application/json; charset=UTF-8"},
        body: json.encode({'message': userMessage}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data['response']);
        print(data['references']); // Debugging to print the references from the response

        // Append the response, references, and additional_references to the messages list
        String botMessage = data['response'];

        if (data['references'] != null) {
          botMessage += "\n\nReferences:\n${data['references'].join('\n')}";
        }

        if (data['additional_references'] != null) {
          botMessage += "\n\nAdditional References:\n${data['additional_references'].join('\n')}";
        }

        setState(() {
          _messages.add({
            'role': 'bot',
            'text': botMessage,
            'timestamp': DateTime.now(),
          });
        });
      } else {
        print('Error ${response.statusCode}: ${response.body}');
        setState(() {
          _messages.add({
            'role': 'bot',
            'text': 'Sorry, I could not process that.',
            'timestamp': DateTime.now(),
          });
        });
      }
    } catch (error) {
      print('Network error: $error');
      setState(() {
        _messages.add({
          'role': 'bot',
          'text': 'Error: Unable to reach the server.',
          'timestamp': DateTime.now(),
        });
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Format messages with bubble style and timestamp
  Widget _buildMessage(Map message) {
    bool isUser = message['role'] == 'user';
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
        isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
            decoration: BoxDecoration(
              color: isUser ? Colors.blueAccent : Colors.grey[300],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
                bottomLeft: Radius.circular(isUser ? 15 : 0),
                bottomRight: Radius.circular(isUser ? 0 : 15),
              ),
            ),
            child: Text(
              message['text'],
              style: TextStyle(color: isUser ? Colors.white : Colors.black87),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              "${message['timestamp'].hour}:${message['timestamp'].minute.toString().padLeft(2, '0')}",
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Biomedical Chatbot"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return _buildMessage(_messages[_messages.length - 1 - index]);
                },
              ),
            ),
            if (_isLoading)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "Ask me anything about health...",
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send, color: Colors.blueAccent),
                    onPressed: () {
                      if (_controller.text.isNotEmpty) {
                        sendMessage(_controller.text);
                        _controller.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
