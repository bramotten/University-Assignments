/*
 * CS:APP Data Lab
 *
 * <Please put your name and userid here>
 * Bram Otten, 10992456.
 *
 * bits.c - Source file with your solutions to the Lab.
 *          This is the file you will hand in to your instructor.
 *
 * WARNING: Do not include the <stdio.h> header; it confuses the dlc
 * compiler. You can still use printf for debugging without including
 * <stdio.h>, although you might get a compiler warning. In general,
 * it's not good practice to ignore compiler warnings, but in this
 * case it's OK.
 */

#if 0
/*
 * Instructions to Students:
 *
 * STEP 1: Read the following instructions carefully.
 */

You will provide your solution to the Data Lab by
editing the collection of functions in this source file.

INTEGER CODING RULES:
 
  Replace the "return" statement in each function with one
  or more lines of C code that implements the function. Your code 
  must conform to the following style:
 
  int Funct(arg1, arg2, ...) {
      /* brief description of how your implementation works */
      int var1 = Expr1;
      ...
      int varM = ExprM;

      varJ = ExprJ;
      ...
      varN = ExprN;
      return ExprR;
  }

  Each "Expr" is an expression using ONLY the following:
  1. Integer constants 0 through 255 (0xFF), inclusive. You are
      not allowed to use big constants such as 0xffffffff.
  2. Function arguments and local variables (no global variables).
  3. Unary integer operations ! ~
  4. Binary integer operations & ^ | + << >>
    
  Some of the problems restrict the set of allowed operators even further.
  Each "Expr" may consist of multiple operators. You are not restricted to
  one operator per line.

  You are expressly forbidden to:
  1. Use any control constructs such as if, do, while, for, switch, etc.
  2. Define or use any macros.
  3. Define any additional functions in this file.
  4. Call any functions.
  5. Use any other operations, such as &&, ||, -, or ?:
  6. Use any form of casting.
  7. Use any data type other than int.  This implies that you
     cannot use arrays, structs, or unions.

 
  You may assume that your machine:
  1. Uses 2s complement, 32-bit representations of integers.
  2. Performs right shifts arithmetically.
  3. Has unpredictable behavior when shifting an integer by more
     than the word size.

EXAMPLES OF ACCEPTABLE CODING STYLE:
  /*
   * pow2plus1 - returns 2^x + 1, where 0 <= x <= 31
   */
  int pow2plus1(int x) {
     /* exploit ability of shifts to compute powers of 2 */
     return (1 << x) + 1;
  }

  /*
   * pow2plus4 - returns 2^x + 4, where 0 <= x <= 31
   */
  int pow2plus4(int x) {
     /* exploit ability of shifts to compute powers of 2 */
     int result = (1 << x);
     result += 4;
     return result;
  }

FLOATING POINT CODING RULES

For the problems that require you to implent floating-point operations,
the coding rules are less strict.  You are allowed to use looping and
conditional control.  You are allowed to use both ints and unsigneds.
You can use arbitrary integer and unsigned constants.

You are expressly forbidden to:
  1. Define or use any macros.
  2. Define any additional functions in this file.
  3. Call any functions.
  4. Use any form of casting.
  5. Use any data type other than int or unsigned.  This means that you
     cannot use arrays, structs, or unions.
  6. Use any floating point data types, operations, or constants.


NOTES:
  1. Use the dlc (data lab checker) compiler (described in the handout) to 
     check the legality of your solutions.
  2. Each function has a maximum number of operators (! ~ & ^ | + << >>)
     that you are allowed to use for your implementation of the function. 
     The max operator count is checked by dlc. Note that '=' is not 
     counted; you may use as many of these as you want without penalty.
  3. Use the btest test harness to check your functions for correctness.
  4. Use the BDD checker to formally verify your functions
  5. The maximum number of ops for each function is given in the
     header comment for each function. If there are any inconsistencies 
     between the maximum ops in the writeup and in this file, consider
     this file the authoritative source.

/*
 * STEP 2: Modify the following functions according the coding rules.
 * 
 *   IMPORTANT. TO AVOID GRADING SURPRISES:
 *   1. Use the dlc compiler to check that your solutions conform
 *      to the coding rules.
 *   2. Use the BDD checker to formally verify that your solutions produce 
 *      the correct answers.
 */

#endif

/*
 * CS:APP Data Lab @ Universiteit van Amsterdam
 *
 * Modification to original Data Lab:
 *
 * the collection of puzzles is automatically generated for each
 * programming pair.
 *
 * Augustus 2016: A.Visser@uva.nl
 *
 */

// TODO's start about here
// make && ./dlc bits.c && ./btest

/* Global ID to identify the combination of puzzles */
int lab_id = 107;

/*
 * bitOr - x|y using only ~ and &
 *   Example: bitOr(6, 5) = 7
 *   Legal ops: ~ &
 *   Max ops: 8
 *   Rating: 1
 */
int bitOr(int x, int y) {
  // 6 = 0110
  // 5 = 0101
  // 7 = 0111 = 6 or 5 (it's an inclusive or)
  // Only false when x = 0 and y = 0. Flip that for:
  return ~(~x & ~y);
}

/*
 * upperBits - pads n upper bits with 1's
 *  You may assume 0 <= n <= 32
 *  Example: upperBits(4) = 0xF0000000
 *  Legal ops: ! ~ & ^ | + << >>
 *  Max ops: 10
 *  Rating: 1
 */
int upperBits(int n) {
  // We'll go through the expression in order.
  // We make a bit-vector of 1000 0000 .... (-0xFFFFFFFF)
  // We shift that vector right by n - 1 places.
  // The - 1 is there because of the 1 caused by bitshifting.
  // To make sure upperbits(0) results in 0, not -0xFFFFFFFF,
  // We add 1 if n | 0 equals 0. (True iff n = 0.)
  return ((1 << 31) >> (n + ~0)) + !(n | 0);
}

/*
 * allOddBits - return 1 if all odd-numbered bits in word set to 1
 *   Examples allOddBits(0xFFFFFFFD) = 0, allOddBits(0xAAAAAAAA) = 1
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 12
 *   Rating: 2
 */
int allOddBits(int x) {
  // A 32 bit int with all odd bits set is 0xAAAAAAAA.
  // We can't use that though, so:
  int unevenBits = (0xAA << 24) + (0xAA << 16) + (0xAA << 8) + 0xAA;

  // OR that with x for a result that can be XOR'd with x again.
  // The OR is necessary to make any value for the even bits possible.
  // The result is a number. 0 if the mask matched perfectly.
  return !(x ^ (unevenBits | x));
}

/*
 * isAsciiDigit - return 1 if 0x30 <= x <= 0x39 (ASCII codes for characters '0'
 * to '9')
 *   Example: isAsciiDigit(0x35) = 1.
 *            isAsciiDigit(0x3a) = 0.
 *            isAsciiDigit(0x05) = 0.
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 15
 *   Rating: 3
 */
int isAsciiDigit(int x) {

  // Ints beginning with 110 as first bits and 6 bits long are definitely
  // ASCII digits. x >> 3 == 110 => ASCII digit under eight.
  int uptoSeven = !((x >> 3) ^ 6);

  // Ugly manual checks for eight and nine.
  int eight = !(x ^ 0x38);
  int nine = !(x ^ 0x39);

  // These variables are all 0 if not an ASCII digit.
  // Could wrap in !(!(...)) to force returning a 0/1.
  return uptoSeven ^ eight ^ nine;
}

/*
 * bitCount - returns count of number of 1's in word
 *   Examples: bitCount(5) = 2, bitCount(7) = 3
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 40
 *   Rating: 4
 */
int bitCount(int x) {

  // Variable names are fairly descriptive, what's achieved
  // is creating all possible patterns of enabled bits.
  // (Of course, in concerto with the operations below,
  //  where they are laid over x.)
  int alternating = (0x55 << 24) + (0x55 << 16) + (0x55 << 8) + 0x55;
  int pairs = (0x33 << 24) + (0x33 << 16) + (0x33 << 8) + 0x33;
  int twoBlocks = (0xff << 16) + 0xff;
  int block = twoBlocks ^ (twoBlocks << 4);
  int fourBlocks = (0xff << 8) + 0xff;
  // int fourBlocks = ~upperBits(16);

  x = (x & alternating) + ((x >> 1) & alternating);
  x = (x & pairs) + ((x >> 2) & pairs);
  x = (x & block) + ((x >> 4) & block);
  x = (x & twoBlocks) + ((x >> 8) & twoBlocks);

  return (x & fourBlocks) + ((x >> 16) & fourBlocks);
}

/*
 * float_i2f - Return bit-level equivalent of expression (float) x
 *   Result is returned as unsigned int, but
 *   it is to be interpreted as the bit-level representation of a
 *   single-precision floating point values.
 *   Legal ops: Any integer/unsigned operations incl. ||, &&. also if, while
 *   Max ops: 30
 *   Rating: 4
 */
unsigned float_i2f(int x) { // TODO: alles
  unsigned sign = 0;
  unsigned absoluteX = x; // were int's
  unsigned absoluteXCopy = x;
  unsigned bitSteps = 0;
  unsigned exponent;
  unsigned mantissa;
  unsigned result;
  unsigned resultUp;

  // First, represent x as binary. That's already done by C.
  // Example with x = 5 (0101 or 101.0 0000 ....).
  // Number has to be whole, so the repeating part post-dot is 0000.

  // The sign of the number can just be an if statement. i.e.: 0.
  if (x == 0) {
    return 0;
  } else if (x < 0) {
    sign = 1 << 31;
    absoluteX = absoluteXCopy = -x;
  }

  // The exponent is 8 bits.
  // How many steps from the dot to the most significant bit?
  // In 0101.0000 that's two steps. We get: 1.010 0000 .... (E+2)
  // i.e.: 127 + 2 = 129 = 1000 0001 (bias = 127)
  // TODO: exponent can't be < 127 now.
  while (absoluteX > 1) {
    absoluteX = absoluteX >> 1;
    bitSteps++;
  }
  exponent = (127 + bitSteps) << 23;

  // The mantissa is 23 bits. (Stuff behind the dot.)
  // i.e.: 0100 0000 ....
  // Make that first (ignored) bit of x 0.
  // Then insert pattern, followed by pattern length (= 24 - bitSteps) 0's.

  mantissa = (absoluteXCopy ^ (1 << bitSteps));
  if (bitSteps < 23) {
    mantissa = mantissa << (23 - bitSteps);
  } else {
    mantissa = mantissa >> (bitSteps - 23);
  }

  // TODO: rounding to higher exponent.
  // if mantissa += 1 and exponent += 1 would be better, round up
  // So do the reverse calculation
  result = sign | exponent | mantissa;
  resultUp = sign | ((127 + bitSteps + 1) << 23) | (((mantissa + 1) << 11) >> 11);
  // if (1) { // Shouldn't be true because resultUp is still wrong.
  //   return resultUp;
  // }

  return result;
}