import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;
class Quotespage extends StatefulWidget {
 final String categname;


Quotespage(this.categname);

  @override
  State<Quotespage> createState() => _QuotespageState();
}

class _QuotespageState extends State<Quotespage> {
  TextStyle texts=TextStyle(color: Colors.black,fontSize: 10,fontWeight: FontWeight.bold);
  List quotes=[];
  List authors=[];
  bool isData=false;

  getQuotes() async {
    String url="https://quotes.toscrape.com/tag/${widget.categname}/";
    Uri uri=Uri.parse(url);
    http.Response response=await http.get(uri);
    dom.Document document=parser.parse(response.body);
    final quotesclass=document.getElementsByClassName("quote");
    quotes=quotesclass.map((element)=>element.getElementsByClassName('text')[0].innerHtml).toList();
    authors=quotesclass.map((element)=>element.getElementsByClassName('author')[0].innerHtml).toList();

    print(quotes);
    setState(() {
       isData=true;

    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getQuotes();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(


      body:isData==false?Center(child: CircularProgressIndicator(),):SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 50),
              child: Text(
                "${widget.categname} quotes".toUpperCase(),
                style:TextStyle(color: Colors.pink,fontSize: 20,fontWeight: FontWeight.bold),
              ),
            ),

            ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: quotes.length,
                itemBuilder: (context,index){
                  return Card(
                    elevation: 4,

                    child: Expanded(

                      child: Container(

                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(quotes[index],
                                  style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 40),
                                child: Text(authors[index],
                                  style: TextStyle(color:Colors.grey,fontSize: 20,fontWeight: FontWeight.w600),),
                              ),
                            ],
                          )


                      ),
                    ),
                  );
                })
          ],
        ),
      )
    );
  }
}