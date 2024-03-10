import 'package:flutter/material.dart';

import 'CallsPage.dart';
import 'ChatsPage.dart';

class InboxPage extends StatefulWidget{
  const InboxPage({super.key});

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2 , vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Tab> tabs = <Tab>[
      const Tab(
        text: "Chats",
      ),
      const Tab(
        text: "Calls",
      )
    ];

    return Padding(
      padding: const EdgeInsets.only(top:50 ,bottom:0 ,left:16,right:16 ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(
                height: 0,
                width: 35,
              ),
              const Text(
                "Inbox",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.w600
                ),
              ),
              IconButton(
                  onPressed: (){},
                  icon: const ImageIcon(
                    AssetImage("assets/images/search_icon.png"),
                    color: Color(0xFF6F30C0),
                    size:22,
                  ),
              )
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 12),
            child: TabBar(
              tabs: tabs,
              controller: _tabController,
              unselectedLabelColor: const Color(0xFFD1D1D1),
              labelColor: const Color(0xFF6F30C0),
              indicatorColor:const Color(0xFF6F30C0),
              indicatorPadding: const EdgeInsets.symmetric(horizontal: 15),
              labelStyle: const TextStyle(
                  color: Color(0xFF6F30C0),
                  fontWeight: FontWeight.w600,
                  fontSize: 16
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
                controller: _tabController,
                children: const [
                  ChatsPage(),
                  CallsPage()
                ]
            ),
          )
        ],
      ),
    );
  }
}