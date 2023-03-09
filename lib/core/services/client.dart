import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

import '../constants/urls.dart';

class Client {
  var url = '';
  SharedPreferences? prefs;

  setBaseUrl() async {
    prefs = await SharedPreferences.getInstance();
    var env = prefs?.getString('env');
    if (env != null) {
      if (env == 'prod') {
        url = liveApiUrl;
      } else if (env == 'dev') {
        url = testApiUrl;
      } else {
        var serverIp = prefs?.getString('server_ip');
        url = serverIp!;
      }
    }
  }

  get(path) async {
    await setBaseUrl();
    print(Uri.parse(url+path));
    return await http.get(Uri.parse(url+path));
  }


  post(path,body, {baseUrl= ''}) async {
    if (baseUrl == '') {
      await setBaseUrl();
    } else {
      url = baseUrl;
    }
    if (url == 'https://api.cleversell.io/') {
      return await http.post(Uri.parse(url+path),body: body);
    } else {
      return await http.post(Uri.parse(url+path),body: body,headers: {"Content-Type":"application/json"});
    }
  }
  put(path,body, {baseUrl= ''}) async {
    if (baseUrl == '') {
      await setBaseUrl();
    } else {
      url = baseUrl;
    }
    if (url == 'https://api.cleversell.io/') {
      return await http.put(Uri.parse(url+path),body: body);
    } else {
      return await http.put(Uri.parse(url+path),body: body,headers: {"Content-Type":"application/json"});
    }
  }
}
