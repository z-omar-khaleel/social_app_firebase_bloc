import 'package:flutter/material.dart';

pushNav(context, Widget page) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
}

pushNavAndReplace(context, Widget page) {
  Navigator.of(context)
      .pushReplacement(MaterialPageRoute(builder: (context) => page));
}
