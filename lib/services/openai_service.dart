import 'package:dio/dio.dart';

class OpenAiService {
  OpenAiService();

  //// "prompt":
  //     "Human: Hello, who are you?\nBob: I am an Bob created by OpenAI. How can I help you today?\nHuman: what are you doing?",

  // prompt will come from the repository and will be passed as a parameter
  Future<String> create({required String prompt}) async {
    final dio = Dio();
    final response = await dio.post('https://api.openai.com/v1/completions',
        options: Options(contentType: 'application/json', headers: {
          'Authorization': '',
        }),
        data: {
          "model": "text-davinci-002",
          "prompt": prompt,
          "max_tokens": 150,
          "temperature": 0.9,
          "top_p": 1,
          "stop": [" Human:", " Buddy:"]
        });

    final text = response.data['choices'][0]['text'];
    return text;
  }
}
