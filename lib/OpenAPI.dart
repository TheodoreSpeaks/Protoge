import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:gpt_3_dart/gpt_3_dart.dart';
import 'key.dart';

/*

curl https://api.openai.com/v1/engines/davinci/completions \
-H "Content-Type: application/json" \
-H "Authorization: Bearer YOUR_API_KEY" \
-d '{"prompt": "This is a test", "max_tokens": 5}'

*/

// Future<String> openAIComplete(prompt) async {
//   final response = await http.get(Uri.https(authority, unencodedPath));
// }

class Conversation {
  late List<String> convo;
  late Function stateCallback;
  static late OpenAI openAI;
  static String setup =
      "This is a conversation between an AI and a Human.  The AI is learning from the Human.  The AI is curious, sarcastic, and smart\n";

  List<String> getConvo() {
    return convo;
  }

  Future<String> fakeAPI(currentPrompt) => Future.delayed(
        Duration(seconds: 2),
        () => 'completed: ' + currentPrompt,
      );

  Future<String> realAPI(currentPrompt) async {
    return openAI.complete(currentPrompt, 200);
  }

  static void initAI() {
    openAI = new OpenAI(apiKey: OpenAIConfig.key);
  }

  Conversation(this.convo, this.stateCallback);

  String getFullPrompt() {
    var prompt = "";
    for (var i = 0; i < this.convo.length; ++i) {
      var prefix = (i % 2 == 0) ? "AI: " : "Human: ";
      prompt += prefix + this.convo[i] + "\n";
    }
    return setup + prompt;
  }

  Future<String> getCompletion() async {
    print("Full prompt: \n");
    print(getFullPrompt());
    var completion = await this.realAPI(this.getFullPrompt());
    return completion;
  }

  void updateConversation(String studentInput) async {
    this.convo.add(studentInput);
    stateCallback(this.convo);
    String completion = await this.getCompletion();
    print("Completion:\n");
    print(completion);
    this.convo.add(completion);
    stateCallback(this.convo);
  }
}
