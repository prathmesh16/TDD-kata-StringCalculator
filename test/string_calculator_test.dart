

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Given empty string, when add operation is done, then 0 is returned', () {

    StringCalculator stringCalculator = StringCalculator();

    expect(stringCalculator.add(''),0);

  });

  test('Given single number String, when add operation is done, then number is returned',() {

    StringCalculator stringCalculator = StringCalculator();

    expect(stringCalculator.add('1'),1);

  });

  test('Given multiple number String, when add operation is done, then sum is returned',() {
    
    StringCalculator stringCalculator = StringCalculator();

    expect(stringCalculator.add('1,2'),3);

  });

  test('Given multiple number String with \n and , as delimeters , when add operation is done, then sum is returned',() {
    
    StringCalculator stringCalculator = StringCalculator();

    expect(stringCalculator.add('1\n2,3'),6);

  });
  test('Given Formatted number String with custom delimeter, when add operation is done, then sum is returned',() {
    
    StringCalculator stringCalculator = StringCalculator();

    expect(stringCalculator.add('//,\n1,2,3'),6);

  });
  test('Given number String with negative numbers, when add operation is done, then Exception is throwed',() {
    
    StringCalculator stringCalculator = StringCalculator();

    expect(() => stringCalculator.add('//,\n1,-2,-3'),throwsA(isA<Exception>()));

  });
  test('Given number String with values greater than 1000, when add operation is done, then only sum of numbers which is less than 1001 is returned',() {
    
    StringCalculator stringCalculator = StringCalculator();

    expect(stringCalculator.add('//,\n1,2000,1001,1000'),1001);

  });
  test('Given number String with delimeter of any length, when add operation is done, then sum is returned',() {
    
    StringCalculator stringCalculator = StringCalculator();

    expect(stringCalculator.add('//[***]\n1***2***3'),6);

  });

  test('Given number String with multiple delimeter, when add operation is done, then sum is returned',() {
    
    StringCalculator stringCalculator = StringCalculator();

    expect(stringCalculator.add('//[*][%]\n1*2%3'),6);

  });
    test('Given number String with multiple delimeters with length longer than one char, when add operation is done, then sum is returned',() {
    
    StringCalculator stringCalculator = StringCalculator();

    expect(stringCalculator.add('//[**][abc][%#]\n1**2abc3%#4'),10);

  });

}

class StringCalculator {
  int add(String numbers) {
    if(numbers.isEmpty) {
      return 0;
    }

    if(numbers.length >= 2 && numbers.substring(0,2) != "//") {
      List<String> nos = numbers.split(RegExp(r',|\n'));
      return getSum(nos);
    }

    return getSumWithCustomDelimeter(numbers);
  }

  void checkNegatives(List<String> numbers) {
    String negativeNumbers = "";
    numbers.forEach((number) { 
      int no = 0;
      try {
        no = int.parse(number);
      } catch(e) {
        no = 0;
      }
      if( no < 0) {
        negativeNumbers+=' '+number;
      }
    });
    if(negativeNumbers.length > 0) {
      throw new Exception('Negatives not allowed'+negativeNumbers);
    }
  }

  int getSum(List<String> numbers) {
    int sum = 0;
    checkNegatives(numbers);
    int no;
    numbers.forEach((number) { 
       try {
        no = int.parse(number);
      } catch(e) {
        no = 0;
      }
      if(no <= 1000) {
        sum+=no;
      }
    });
    return sum;
  }

  int getSumWithCustomDelimeter(String input) {

    List<String> data = input.split('\n');
    List<String> numbers;
    List<String> delimeters = [];

    if(data.length == 2) {
      if(data[0][2] == '[') {
        //multiple delimeters with []
        int i=2,j=2;
        while(j < data[0].length) {
          if(data[0][j] == ']') {
            delimeters.add(data[0].substring(i,j+1));
            i=j+1;
            j+=2;
          }
          j++;
        }
        String pattern = "";
        delimeters.forEach((delimeter) {
          pattern += delimeter+'|';
        });
        numbers = data[1].split(RegExp(r''+pattern.substring(0,pattern.length-1)));
      }
      else {
        //single delimeter without []
        delimeters.add(data[0].substring(2));
        numbers = data[1].split(delimeters[0]);
      }
    }
    else {
      //single number
      numbers = data;
    }
    checkNegatives(numbers);
    int sum = getSum(numbers);
    return sum;
  }
}