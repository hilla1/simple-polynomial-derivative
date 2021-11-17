import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

calculateDerivative(userInput){
  var finalCal='';
  for(int i=0; i<userInput.length; i++) {
  var char = userInput[i];
  if(char=='^'){
  var sqPosition=userInput[i+1];
  var realValue=userInput[i-2];
  var xValue=userInput[i-1];
  var leadSign='';
  try {
      leadSign = userInput[i-3]; 
   } 
  catch(e) { 
      leadSign ='';
   } 
  if(sqPosition=='1'){
  finalCal+=(leadSign+(int.parse(sqPosition)*int.parse(realValue)).toString());
  }else{
   finalCal+=(leadSign+(int.parse(sqPosition)*int.parse(realValue)).toString() 
         + xValue + '^' + (int.parse(sqPosition)-1).toString());
  }
  }
}
 return finalCal;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:false,
      home: LocationApp(),
    );
  }
}

class LocationApp extends StatefulWidget {
  @override
  _LocationAppState createState() => _LocationAppState();
}

class _LocationAppState extends State<LocationApp> {
  final formKey=GlobalKey<FormState>();
  TextEditingController loginController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController inputController = TextEditingController();
  var lin='';
  var pwd='';
  var ipt='';
  var res='';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SingleChildScrollView(child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height,
          maxWidth: MediaQuery.of(context).size.width,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
                colors: [
                  const Color(0xFF3366FF),
                  const Color(0xFF00CCFF),
                ],
                begin: Alignment.topLeft,
                end: Alignment.centerRight,
                  ),
        ),


        child:Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
                  Expanded(flex:2,
                   child:Padding(
                    padding: const EdgeInsets.symmetric(vertical: 36.0, horizontal: 24.0),
                    child: Column(
                     mainAxisAlignment: MainAxisAlignment.end,
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children:[
                     Text("Derivative Calculator",
                     style:TextStyle(color:Colors.white,fontSize:46.0,
                     fontWeight: FontWeight.w900,),
                     ),
                     SizedBox(
                       height: 9.0,
                     ),
                     Text("Enter Linear Polynomial to Find Out its Derivative",
                     style:TextStyle(color:Colors.white,fontSize:19.0,
                     fontWeight: FontWeight.w300,),
                     ),
                     
                     ],
                  ),
                  
                  ),
              ),
              Expanded(flex:5,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color:Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),)
                ),
                child:Padding(
                   padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key:formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center, 
                      children: [
                        TextFormField(
                          controller: loginController,
                          keyboardType: TextInputType.emailAddress,
                          decoration:InputDecoration(
                            border:OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide.none,
                            ),
                            filled:true,
                            fillColor:Color(0xFFe7edeb),
                            hintText: 'Use Unique alphanumeric',
                            prefixIcon:Icon(Icons.login,color:Colors.grey[800],),
                          ),
                           validator: Validators.compose([
                           Validators.required('Alphanumeric is required'),
                          Validators.patternString(r"^[A-Za-z0-9]+$", 'Only alphanumerics are allowed'),]),
                        ),
                        SizedBox(
                         height: 15.0,
                       ),
                        TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          controller: passwordController,
                          obscureText: true,
                          decoration:InputDecoration(
                            border:OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide.none,
                            ),
                            filled:true,
                            fillColor:Color(0xFFe7edeb),
                            hintText: 'Input Password',
                            prefixIcon:Icon(Icons.password,color:Colors.grey[800],),
                          ),
                          validator: Validators.compose([
                           Validators.required('Password is required'),
                          Validators.patternString(r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{4,}$",
                               'Mix numbers,letters and atleast total length of 4'),]),
                        ),
                        SizedBox(
                         height: 15.0,
                       ),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          controller: inputController,
                          decoration:InputDecoration(
                            border:OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide.none,
                            ),
                            filled:true,
                            fillColor:Color(0xFFe7edeb),
                            hintText: 'Input Polynomial',
                            prefixIcon:Icon(Icons.search,color:Colors.grey[800],),
                          ),
                           validator:Validators.required('Linear Polynomial is required'),
                        ),
                        SizedBox(
                         height: 15.0,
                       ),
                       Container(
                         width:double.infinity,
                         child:RaisedButton(
                           onPressed: () => {
                              if(formKey.currentState!.validate()){
                               lin=loginController.text,
                               pwd=passwordController.text,
                               ipt=inputController.text,
                               loginController.text='',
                               passwordController.text='',
                               inputController.text='',
                               Navigator.push(
                               context,
                               MaterialPageRoute(builder:(BuildContext context) =>new ResultsPage( 
                                 lin,pwd,ipt,res=calculateDerivative(ipt)
                               )),
                               ),
                               insertData(lin,pwd,ipt,calculateDerivative(ipt)),
                              },
                              },
                           color:Colors.blue[800],
                           child:Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: Text(
                               "Submit", style:TextStyle(
                                 color:Colors.white,
                                 fontSize: 16.0,
                               ),
                             ),
                           ),

                         ),
                       ),
                      ],
                    ),
                  ),
                ),
              ),
              ),
          ],
        )
      ),)
    );
  }
}

class ResultsPage extends StatelessWidget {
  String lin;
  String pwd;
  String ipt;
  String res;
  ResultsPage(this.lin,this.pwd,this.ipt,this.res);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text("Polynomial Derivative"),
      ),
      body: Center(

          child: Text(res),
    ),
    );
  }
  }
  void insertData(lin,pwd,ipt,res){
  Map <String,dynamic> data={"Login":lin,"Password":pwd,"Polynomial Input":ipt,"Derivative Result":res};
  FirebaseFirestore.instance.collection("Derivative Results").add(data);
}


