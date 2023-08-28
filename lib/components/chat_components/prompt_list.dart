import 'dart:math';

import 'package:chatXpress/assets/strings/my_strings.dart';
import 'package:chatXpress/components/chat_components/prompt_button.dart';
import 'package:flutter/material.dart';

class PromptsList extends StatefulWidget {
  const PromptsList({super.key});

  @override
  State<PromptsList> createState() => _PromptsListState();
}

class _PromptsListState extends State<PromptsList> {
  List<String> questions = [
    "What is the capital of France?",
    "How does photosynthesis work?",
    "Explain the concept of gravitational waves.",
    "What are the major features of the human nervous system?",
    "Can you describe the process of protein synthesis?",
    "What is the significance of the Mona Lisa painting?",
    "How does the immune system protect the body from diseases?",
    "What are the differences between mitosis and meiosis?",
    "Explain the theory of relativity proposed by Albert Einstein.",
    "How do plants adapt to their environments?",
    "What is the water cycle and its importance?",
    "Describe the structure of DNA.",
    "How do antibiotics work to combat bacterial infections?",
    "What is the concept of supply and demand in economics?",
    "Explain the stages of cellular respiration.",
    "What are renewable and non-renewable energy sources?",
    "Discuss the causes and effects of climate change.",
    "What is the function of the mitochondria in a cell?",
    "Explain the process of natural selection.",
    "How do black holes form and what are their properties?",
    "Describe the history and significance of the Industrial Revolution.",
    "What are the different types of chemical bonds?",
    "Explain the principles behind the Turing test and artificial intelligence.",
    "Discuss the major events of World War II.",
    "How does the human circulatory system work?",
    "Describe the structure of a neuron and how it transmits signals.",
    "What is the importance of biodiversity?",
    "Explain the concept of elasticity in economics.",
    "How do vaccines provide immunity against diseases?",
    "Discuss the differences between a plant and animal cell.",
    "What is the role of enzymes in biochemical reactions?",
    "How do earthquakes occur and how are they measured?",
    "Explain the process of fossil formation and its significance.",
    "What is the Doppler effect and how does it apply to sound and light?",
    "Discuss the pros and cons of nuclear energy.",
    "How does the human respiratory system function?",
    "Describe the stages of human prenatal development.",
    "What is the structure and function of a virus?",
    "Explain the concept of inflation in economics.",
    "How do geysers erupt?",
    "What are the properties of different states of matter?",
    "Discuss the impact of social media on society.",
    "Explain the process of digestion in the human body.",
    "What is the role of neurotransmitters in the brain?",
    "Describe the major functions of the liver.",
    "Discuss the life cycle of a star.",
    "What is the history and significance of the internet?",
    "How do plants reproduce both sexually and asexually?",
    "Explain the principles of evolution according to Charles Darwin.",
    "What are the main types of renewable energy sources?"
  ];
  List<PromptButton> promptButtons = [];
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _addMessages();
    });
  }

  Future<void> _addMessages() async {
    List<String> prompts = [
      getRandomQuestion(questions),
      getRandomQuestion(questions),
      getRandomQuestion(questions),
      getRandomQuestion(questions)
    ];

    for (String prompt in prompts) {
      await Future.delayed(const Duration(milliseconds: 50));
      promptButtons.insert(0, PromptButton(messageSuggestion: prompt));
      listKey.currentState!.insertItem(promptButtons.length - 1);
    }
  }

  String getRandomQuestion(List<String> questionList) {
    Random random = Random();
    int randomIndex = random.nextInt(questionList.length);
    var prompt = questionList[randomIndex];
    questionList.remove(prompt);
    return prompt;
  }

  @override
  Widget build(BuildContext context) {
    Tween<Offset> offset =
        Tween(begin: const Offset(1, 0), end: const Offset(0, 0));

    return Center(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 90.0, bottom: 16.0),
            child: Text(
             MyStrings.appName,
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white24),
            ),
          ),
          Expanded(
            child: AnimatedList(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              key: listKey,
              initialItemCount: 0,
              itemBuilder: (context, index, animation) {
                return SlideTransition(
                  position: animation.drive(offset),
                  child: promptButtons[index],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
