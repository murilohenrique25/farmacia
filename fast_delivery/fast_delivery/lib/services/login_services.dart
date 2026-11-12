import 'dart:convert';

import 'package:fast_delivery/models/login.dart';
import 'package:http/http.dart';

class ApiServicesLogin {
  Future<Login> realizarLogin(
      String caminhoFinal, String user, String pass) async {
    final Response response = await get(Uri.parse(
        '$caminhoFinal/api/app/v1/login?user_id=$user&password=$pass'));
    if (response.statusCode == 200 || response.statusCode == 201) {
       Map<String,dynamic> body = jsonDecode(response.body);

        Login login = Login.fromJson(body);

    return login;
    } else {
      Login login = Login();
      login.erro = "ERRO";
      List<Login> ent = [];
      ent.add(login);
      return login;
    }
  }
}

