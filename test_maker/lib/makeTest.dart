import 'dart:math';
import 'jsonControl.dart';
import 'language.dart';
import 'package:flutter/material.dart';

class CategorySelection extends StatefulWidget {
  @override
  _CategorySelectionState createState() => _CategorySelectionState();
}

class _CategorySelectionState extends State<CategorySelection> {
  String? selectedCategory;
  var questionCount = TextEditingController();
  Map<String, dynamic> data = {};
  var _ = Language.translate;

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  void loadCategories() async {
    data = await get();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_("Select Category")),
      ),
      body: data.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_("Select a category")),
                for (String category in data.keys)
                  RadioListTile<String>(
                    title: Text(category),
                    value: category,
                    groupValue: selectedCategory,
                    onChanged: (String? value) {
                      setState(() {
                        selectedCategory = value;
                      });
                    },
                  ),

                    TextFormField(controller:questionCount ,decoration: InputDecoration(labelText: _("number of questions :")),keyboardType: TextInputType.number,onChanged:(var text){
                      setState(() {
                        
                      });
                    } ,),
                    
                ElevatedButton(
                  onPressed:selectedCategory == null||questionCount.text==""
                  ?null
                   :() {
                    if (selectedCategory != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TestScreen(
                            category: selectedCategory!,
                            count: int.parse(questionCount.text),
                            data: data,
                          ),
                        ),
                      );
                    }
                  },
                  child: Text(_("Start")),
                ),
              ],
            ),
    );
  }
}
class TestScreen extends StatefulWidget {
  final String category;
  final int count;
  final Map<String, dynamic> data;

  TestScreen({required this.category, required this.count, required this.data});

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  List<String> answers=[];
  String currentQuestion = "";
  String trueAnswer = "";
  int type = 0;
  int trueCount = 0;
  int falseCount = 0;
  int doneCount = 0;
  TextEditingController completeController = TextEditingController();
  String? selectedAnswer;
  var _ = Language.translate;

  @override
  void initState() {
    super.initState();
    onNext();
  }

  void onSubmit() async{
    bool isCorrect = false;
    if (type == 0) {
      isCorrect = selectedAnswer == trueAnswer;
    } else {
      isCorrect = completeController.text == trueAnswer;
    }

    if (isCorrect) {
      trueCount++;
    } else {
      falseCount++;
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(_("Error")),
          content: Text(_("Your answer is wrong. The correct answer is ") + trueAnswer),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(_("OK")),
            ),
          ],
        ),
      );
    }

    doneCount++;
    if (doneCount == widget.count) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(_("Congratulations")),
          content: Text(_("You finished the test. You got ") +
              "$trueCount " +
              _("out of ") +
              "${widget.count}"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text(_("OK")),
            ),
          ],
        ),
      );
    } else {
      onNext();
    }
  }

  void onNext() {
    var randomKey = widget.data[widget.category].keys.elementAt(Random().nextInt(widget.data[widget.category].length));
    var questionData = widget.data[widget.category][randomKey];

    setState(() {
      currentQuestion = randomKey;
      trueAnswer = questionData["answer"];
      type = questionData["type"];
      if (type == 0) {
        selectedAnswer = null;
        answers = questionData["otherAnswers"].split(',');
        answers.add(trueAnswer);
        answers.shuffle();
      }
      completeController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_("Test")),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _("Question"),
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text(
              currentQuestion,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            if (type == 0)
              Column(
                children: [
                  for (var answer in answers)
                     RadioListTile<String>(
                          title: Text(answer),
                          value: answer,
                          groupValue: selectedAnswer,
                          onChanged: (String? value) {
                            setState(() {
                              selectedAnswer = value;
                            });
                          },)
        ])
            else
              TextField(
                controller: completeController,
                decoration: InputDecoration(labelText: _("Complete the answer")),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: onSubmit,
              child: Text(_("Submit")),
            ),
          ],
        ),
      ),
    );
  }
}

