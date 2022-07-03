import 'package:flutter/material.dart';
import 'bot.dart';

abstract class Result {
  Widget get();
}

abstract class Module{
  Result? execute(Bot context, List<String> args);
}

