 import 'package:flutter/material.dart';
 import 'details.dart';
 import 'package:http/http.dart' as http;
 import 'package:html/parser.dart' as parser;
 import 'package:html/dom.dart' as dom;



 class Webscrapping extends StatefulWidget {
   const Webscrapping({Key? key}) : super(key: key);

   @override
   State<Webscrapping> createState() => _WebscrappingState();
 }

 class _WebscrappingState extends State<Webscrapping> {
   TextStyle texts=TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold);
   List<String> categories=["love","inspirational","life","humor"];
   List quotes=[];
   List authors=[];
   bool isData=false;

   getQuotes()async{
     String url="https://quotes.toscrape.com/";
     Uri uri=Uri.parse(url);
     http.Response response=await http.get(uri);
     dom.Document document=parser.parse(response.body);
     final quotesclass=document.getElementsByClassName("quote");
     quotes=quotesclass.map((element)=>element.getElementsByClassName('text')[0].innerHtml).toList();
     authors=quotesclass.map((element)=>element.getElementsByClassName('author')[0].innerHtml).toList();
     print(quotes);
print(authors);
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
       body: SingleChildScrollView(
         physics: ScrollPhysics(),
         child: Column(
           children: [

             Padding(
               padding: const EdgeInsets.only(top: 40),
               child: Text("Quotes App",
                 style: TextStyle(color: Colors.black,
                     fontWeight: FontWeight.bold,fontSize: 30),),
             ),
             GridView.count(
                 shrinkWrap: true,
                 physics: NeverScrollableScrollPhysics(),
               crossAxisCount: 2,
                   mainAxisSpacing: 10,
                   crossAxisSpacing: 10,
               children:categories.map((category) {
                 return
                   InkWell(
                     onTap: () {
                       Navigator.push(context, MaterialPageRoute(
                           builder: (context) => Quotespage(category)));
                     },
                     child: Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Container(
                         height: 50,
                         width: 50,

                         decoration: BoxDecoration(
                           color: Colors.pink,
                           borderRadius: BorderRadius.circular(20),
                         ),
                         child: Center(child: Text(
                           category.toUpperCase(), style: texts,)),


                       ),
                     ),
                   );
               }).toList(),
             ),

             SizedBox(height: 20,),
             isData == false? Center(child: CircularProgressIndicator(),): ListView.builder(
                 shrinkWrap: true,
                 itemCount: quotes.length,
                 physics: NeverScrollableScrollPhysics(),
                 itemBuilder: (context,index){
                   String qs=quotes[index];
                   print("QU${qs}");
                   return Card(
                     elevation: 4,

                     child: Container(
                         height: 180,
                         child: Column(
                           children: [
                             Padding(
                               padding: const EdgeInsets.all( 10),
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
                   );
                 })

           ],
         ),
       ),

     );
   }
 }


