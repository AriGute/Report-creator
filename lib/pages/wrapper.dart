import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:save_pdf/pages/authenticate/authenticate.dart';
import 'package:save_pdf/pages/models/user.dart';

import 'home/home.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser>(context);
    print(user);
    // if user is logged in(not null) then return Home.
    // else return Authenticate.
    return user == null ? Authenticate() : Home();
  }
}
