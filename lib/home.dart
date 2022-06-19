import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class home extends StatefulWidget {
  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  // final CategoriesScroller categoriesScroller = CategoriesScroller();

  ScrollController controller = ScrollController();

  bool closeTopContainer = false;

  double topContainer = 0;

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      double value = controller.offset /300;
      setState(() {
        topContainer = value;
        closeTopContainer = controller.offset > 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final double categoryHeight = MediaQuery.of(context).size.height *0.48;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFBCD51C),
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget>[
              AnimatedOpacity(
                duration: const Duration(milliseconds: 120),
                opacity: closeTopContainer ? 0 : 1,
                child: AnimatedContainer(
                    duration: const Duration(milliseconds: 1000),
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.topCenter,
                    height: closeTopContainer ? 0 : categoryHeight,
                    child: Container(
                      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05),
                      color: Color(0xFFBCD51C),
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height*0.1,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                              child: Text("Hi Cartez,",style: TextStyle(fontSize: 28),)
                          ),
                          Container(
                              alignment: Alignment.centerLeft,
                              child:Text("Welcome back",style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold),),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text("Available balance",style: TextStyle(fontSize: 14),),
                          SizedBox(
                            height: 18,
                          ),
                          Text("\$3,100,",style: TextStyle(fontSize: 45,fontWeight: FontWeight.bold),),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 3,
                                width: 3,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                width: 7,
                              ),
                              Container(
                                height: 5,
                                width: 5,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                width: 7,
                              ),
                              Container(
                                height: 3,
                                width: 3,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height*0.05,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    height: 55,
                                    width: 55,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black,
                                    ),
                                    child:Icon(Icons.add_box_rounded, color: Colors.white,size: 32,),
                                    alignment: Alignment.center,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text("Top Up",style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),),
                                ],
                              ),
                              Column(
                                children: [
                                  Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black,
                                    ),
                                    child: Icon(Icons.send_outlined, color: Colors.white,size: 32,),
                                    alignment: Alignment.center,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text("Send",style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),),
                                ],
                              ),
                              Column(
                                children: [
                                  Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black,
                                    ),
                                    child: Icon(Icons.call_received_outlined, color: Colors.white,size: 32,),
                                    alignment: Alignment.center,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text("Request",style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft:  Radius.circular(20),topRight:  Radius.circular(20)),
                ),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height*0.055,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width*0.08, MediaQuery.of(context).size.height*0.01, 0,0),
                  child: Text("Last Transaction",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                ),
              ),
              Expanded(
                  child: Container(
                    color: Colors.white,
                    child: ListView.builder(
                        controller: controller,
                        itemCount: 50,
                        itemBuilder: (context, index) {
                          double scale = 1.0;
                          if (topContainer >0.5) {
                            scale = index + 0.5 - topContainer;
                            if (scale < 0) {
                              scale = 0;
                            } else if (scale > 1) {
                              scale = 1;
                            }
                          }
                          return Opacity(
                            opacity: scale,
                            child: Align(
                                alignment: Alignment.topCenter,
                                child: Container(
                                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.053),
                                    height: MediaQuery.of(context).size.height *0.1,
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 46,
                                          width: 46,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xFFEDEDE6),
                                          ),
                                          child: Icon(Icons.shopping_bag_outlined, color: Colors.black,),
                                          alignment: Alignment.center,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 20,top: 20),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("Gold",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w900),),
                                              Text("Transaction ID $index",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                )
                            ),
                          );
                        }),
                  )),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
          selectedItemColor: Colors.black,
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          onTap: (int index) {

          },
            items:[
              BottomNavigationBarItem(
                icon: Icon(Icons.home_filled, color: Colors.black,),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_balance_wallet_outlined, color: Colors.black,),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.qr_code_scanner, color: Colors.black,),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart, color: Colors.black,),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.perm_identity, color: Colors.black,),
                label: '',
              ),
            ],
        ),
      ),
    );
  }
}

