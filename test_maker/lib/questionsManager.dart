import 'jsonControl.dart';
import 'language.dart';
import 'package:flutter/material.dart';

class questionsManager extends StatefulWidget {
  final String category;

  questionsManager({Key? key, required this.category}) : super(key: key);

  @override
  State<questionsManager> createState() => _questionsManagerState();
}

class _questionsManagerState extends State<questionsManager> {
  TextEditingController _question = TextEditingController();
  var _ = Language.translate;
  Map<String, dynamic> data = {};

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    data = await get();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_("questions manager")),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (context) {
                    return AddQuestionDialog(
                      category: widget.category,
                      onSave: (question, answer, type, otherAnswers) async {
                        data[widget.category][question] = {
                          "answer": answer,
                          "type": type,
                          "otherAnswers": otherAnswers,
                        };
                        await save(data);
                        setState(() {});
                      },
                    );
                  },
                );
              },
              child: Text(_("add")),
            ),
            for (var question in data[widget.category].keys.toList())
              ListTile(
                title: Text(question.toString()),
                onLongPress: () async {
                  data[widget.category].remove(question);
                  await save(data);
                  setState(() {});
                },
              ),
          ],
        ),
      ),
    );
  }
}

class AddQuestionDialog extends StatefulWidget {
  final String category;
  final Function(String, String, int, String) onSave;

  AddQuestionDialog({required this.category, required this.onSave});

  @override
  _AddQuestionDialogState createState() => _AddQuestionDialogState();
}

class _AddQuestionDialogState extends State<AddQuestionDialog> {
  TextEditingController _question = TextEditingController();
  TextEditingController _trueAnswer = TextEditingController();
  TextEditingController _otherAnswers = TextEditingController();
  int _type = 0;
  var _ = Language.translate;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _question,
              decoration: InputDecoration(labelText: _("question")),
            ),
            RadioListTile(
              value: 0,
              groupValue: _type,
              onChanged: (int? value) {
                setState(() {
                  _type = value ?? 0;
                });
              },
              title: Text(_("choose")),
            ),
            RadioListTile(
              value: 1,
              groupValue: _type,
              onChanged: (int? value) {
                setState(() {
                  _type = value ?? 0;
                });
              },
              title: Text(_("complete")),
            ),
            TextFormField(
              controller: _trueAnswer,
              decoration: InputDecoration(labelText: _("answer")),
            ),
            if (_type == 0)
              TextFormField(
                controller: _otherAnswers,
                decoration: InputDecoration(labelText: _("other answers")),
              ),
            ElevatedButton(
              onPressed: () {
                widget.onSave(
                  _question.text,
                  _trueAnswer.text,
                  _type,
                  _otherAnswers.text,
                );
                Navigator.pop(context);
              },
              child: Text(_("add")),
            ),
          ],
        ),
      ),
    );
  }
}
