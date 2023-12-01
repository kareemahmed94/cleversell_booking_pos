import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:get/get.dart';

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
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {

      await setBaseUrl();
      print(Uri.parse(url + path));

      return await http.get(Uri.parse(url + path));
    } else {
      Get.snackbar(
          "Internet", "There's a problem with your internet connection!",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
  }

  post(path, body, {baseUrl = ''}) async {
    bool result = await InternetConnectionChecker().hasConnection;
    print('result');
    print(result);
    if (result == true) {
      if (baseUrl == '') {
        await setBaseUrl();
      } else {
        url = baseUrl;
      }
      if (url == 'https://api.cleversell.io/') {
        return await http.post(Uri.parse(url + path), body: body);
      } else {
        return await http.post(Uri.parse(url + path),
            body: body, headers: {"Content-Type": "application/json"});
      }
    } else {
      Get.snackbar(
          "Internet", "There's a problem with your internet connection!",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
  }

  put(path, body, {baseUrl = ''}) async {
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      if (baseUrl == '') {
        await setBaseUrl();
      } else {
        url = baseUrl;
      }
      if (url == 'https://api.cleversell.io/') {
        return await http.put(Uri.parse(url + path), body: body);
      } else {
        print(url + path);
        final res = await http.put(Uri.parse(url + path),
            body: body, headers: {"Content-Type": "application/json"});
        print(res.reasonPhrase);
        return res;
      }
    } else {
      Get.snackbar(
          "Internet", "There's a problem with your internet connection!",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
  }
}
