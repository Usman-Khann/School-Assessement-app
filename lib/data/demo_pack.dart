/// A tiny SAMPLE question pack so the app can be tried before real textbooks
/// and question banks are added. It is NOT taken from any official Punjab
/// textbook; chapter names are generic and no page numbers are given.
const kDemoBookTitle = 'SAMPLE book (not an official textbook)';

Map<String, dynamic> _mcq(String t, List<String> o, int c, String s, String x,
        [int d = 1]) =>
    {
      'type': 'mcq',
      'text': t,
      'options': o,
      'correctIndex': c,
      'shortExplanation': s,
      'conceptExplanation': x,
      'difficulty': d,
    };

final Map<String, dynamic> kDemoPack = {
  'chapters': [
    {
      'number': 1,
      'title': 'Sample: Whole Numbers',
      'topics': [
        {
          'title': 'Place value',
          'questions': [
            _mcq('What is the place value of 5 in 352?', ['5', '50', '500', '5000'], 1,
                '5 is in the tens place, so its value is 50.',
                'Each digit has a value that depends on its position. From the right the places are ones, tens, hundreds. A digit in the tens place is worth ten times the digit.'),
            _mcq('Which number is the greatest?', ['989', '998', '899', '909'], 1,
                '998 has the largest tens digit among numbers starting with 9.',
                'To compare numbers, start from the leftmost digit. If those are equal, compare the next digit, and so on.'),
            _mcq('7 hundreds + 4 ones is written as:', ['74', '704', '740', '407'], 1,
                'There are no tens, so a 0 holds the tens place: 704.',
                'Zero is used as a place holder when a place has no value, so the other digits stay in their correct positions.', 2),
            _mcq('What is 468 rounded to the nearest ten?', ['460', '470', '400', '500'], 1,
                'The ones digit is 8 (5 or more), so round up to 470.',
                'To round to the nearest ten, look at the ones digit. If it is 5 or more, increase the tens digit by one; otherwise keep it. Then make the ones digit 0.', 2),
          ]
        },
        {
          'title': 'Addition and subtraction',
          'questions': [
            _mcq('245 + 132 = ?', ['367', '377', '387', '477'], 1,
                '5+2=7, 4+3=7, 2+1=3, giving 377.',
                'Add the ones first, then the tens, then the hundreds. Write each result under its own place.'),
            _mcq('500 - 175 = ?', ['325', '335', '425', '375'], 0,
                '500 - 100 = 400, 400 - 75 = 325.',
                'When a digit is too small to subtract from, borrow one from the next place on the left. One hundred equals ten tens.', 2),
            _mcq('Ali had 60 rupees and spent 25. How much is left?',
                ['25', '35', '45', '85'], 1, '60 - 25 = 35 rupees.',
                'Words such as "spent", "left" and "gave away" tell us to subtract the smaller amount from the larger one.'),
            _mcq('Which sum equals 100?', ['45 + 45', '65 + 35', '70 + 20', '55 + 55'], 1,
                '65 + 35 = 100.',
                'Pairs that make 100 are useful to remember: the ones digits add to 10 and the tens digits add to 9.', 2),
          ]
        }
      ]
    },
    {
      'number': 2,
      'title': 'Sample: Fractions',
      'topics': [
        {
          'title': 'Understanding fractions',
          'questions': [
            _mcq('Which fraction shows one half?', ['1/3', '1/2', '2/3', '1/4'], 1,
                'One half means 1 part out of 2 equal parts.',
                'A fraction has a numerator (parts taken) on top and a denominator (total equal parts) below.'),
            _mcq('In the fraction 3/8, the denominator is:', ['3', '8', '11', '5'], 1,
                'The bottom number, 8, is the denominator.',
                'The denominator tells into how many equal parts the whole is divided. The numerator tells how many of those parts we have.'),
            _mcq('Which fraction is equal to 1/2?', ['2/3', '2/4', '3/4', '1/4'], 1,
                '2/4 = 1/2 because 2 is half of 4.',
                'Equivalent fractions name the same amount. Multiply or divide the numerator and denominator by the same number to get one.', 2),
            _mcq('Which is greater: 3/5 or 1/5?', ['1/5', '3/5', 'They are equal', 'Cannot tell'], 1,
                'Same denominator, so the bigger numerator is greater.',
                'When fractions have the same denominator, the parts are the same size, so more parts means a greater fraction.'),
            _mcq('1/4 + 2/4 = ?', ['3/8', '3/4', '2/8', '1/2'], 1,
                'Add the numerators: 1 + 2 = 3, keep the denominator 4.',
                'To add fractions with the same denominator, add only the numerators. The size of the parts (the denominator) does not change.', 2),
            _mcq('A pizza is cut into 8 equal slices. Sara eats 3. What fraction is left?',
                ['3/8', '5/8', '8/3', '5/3'], 1, '8 - 3 = 5 slices remain out of 8.',
                'The whole is 8/8. Subtract the eaten part from the whole: 8/8 - 3/8 = 5/8.', 3),
          ]
        }
      ],
      'questions': [
        {'type': 'fill', 'text': 'In the fraction 5/9, the numerator is ____.', 'answer': '5'},
        {'type': 'fill', 'text': 'Two quarters make one ____.', 'answer': 'half'},
        {'type': 'tf', 'text': '2/4 and 1/2 are equivalent fractions.', 'answer': true},
        {'type': 'tf', 'text': 'In 3/7 the denominator is 3.', 'answer': false},
        {
          'type': 'short',
          'text': 'Define a fraction and give one example.',
          'answer': 'A fraction is a part of a whole divided into equal parts (1 mark). Any correct example, e.g. 1/2 (1 mark).'
        },
        {
          'type': 'short',
          'text': 'Write two fractions equivalent to 1/3.',
          'answer': 'Any two of 2/6, 3/9, 4/12 ... (1 mark each).'
        },
        {
          'type': 'long',
          'text': 'Explain with a drawing how to add 1/5 and 3/5, and write the answer.',
          'answer': 'Correct drawing of a whole in 5 equal parts (2). Shading 1 part and 3 more parts (1). Adding numerators, keeping the denominator (1). Answer 4/5 (1).'
        },
      ]
    }
  ]
};
