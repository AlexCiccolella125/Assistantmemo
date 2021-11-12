import 'package:app1/micpage.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe7ecf0),
      appBar: AppBar(
        backgroundColor: Color(0xff4a7fc1),
        title: Text('Notes'),
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: (){},
              child: Icon(
                Icons.search,
                size:26.0,
                color: Colors.white,

              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: (){},
              child: Icon(
                Icons.settings,
                size:26.0,
                color: Colors.white,

              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20,left: 12,right: 12,bottom: 12),
                    child: GestureDetector(
                      onTap: (){},
                      child: Container(
                        width : MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height/4.5,
                        child: Card(
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left:20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    Text('Hello'),
                                    Text('I am Developer'),
                                    Text('I have 1 Year Experience'),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 35.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Date'),
                                  SizedBox(
                                    width: 360.0,
                                  ),
                                  IconButton(icon: Icon(Icons.delete), onPressed: () {  },)
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20,left: 12,right: 12,bottom: 12),
                    child: GestureDetector(
                      onTap: (){},
                      child: Container(
                        width : MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height/4.5,
                        child: Card(
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left:20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    Text('Hello'),
                                    Text('I am Developer'),
                                    Text('I have 1 Year Experience'),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 35.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Date'),
                                  SizedBox(
                                    width: 360.0,
                                  ),
                                  IconButton(icon: Icon(Icons.delete), onPressed: () {  },)
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 600.0),
                child: FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MicPage()),
                    );
                  },
                    label: const Text('Speak'),
                  icon: Icon(Icons.mic),
                  backgroundColor: Color(0xff4a7fc1),
                ),
              ),
            ],
          ),
        ],
      ),
      );
  }
}
