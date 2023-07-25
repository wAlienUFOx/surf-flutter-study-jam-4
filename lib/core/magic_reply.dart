import 'dart:convert';

import 'package:http/http.dart' as http;

class MagicReply{
  final String reply;

  const MagicReply({
    required this.reply
  });

  factory MagicReply.fromJson(Map<String, dynamic> json) {
    return MagicReply(reply: json['reading']);
  }
}

Future<MagicReply> fetchMagicReply() async {
  final response = await http.get(Uri.parse('https://eightballapi.com/api'));
  if(response.statusCode == 200) {
    return MagicReply.fromJson(jsonDecode(response.body));
  }
  return const MagicReply(reply: '');
}