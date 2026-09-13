A sleek, minimal-but-powerful notepad calculator which evaluates expressions as you type. It combines the flexibility of a text editor with the power of a scientific calculator.

Why Numara?
Traditional calculators slow you down with buttons, modes, and rigid workflows. Numara takes a different approach: it treats math like writing. By combining a simple text-entry interface with real-time evaluation, Numara offers a faster, more natural way to calculate.
Whether you're jotting down quick arithmetic, testing formulas, or mixing notes with numbers, Numara keeps you in the flow.

📝 Notepad-Style Interface

Write expressions as plain text, minimal interface with no buttons or rigid UI to slow you down.
Mix notes and calculations freely, perfect for jotting down ideas alongside math.
Change a value and the result updates instantly.
⚡ Real-Time Evaluation

Results appear as you type, no equals button needed.
Automatically recalculates when expressions change.
Enables quick experimentation and iterative problem-solving.
🔢 Advanced Math with Math.js, giving you a wide range of capabilities:

Scientific functions (trig, logs, exponentials, statistics, etc.).
Unit handling and conversions (5 cm + 2 in, 1 hour to minutes, etc.).
Complex and symbolic expressions including percentage operations (10% of 20, 40 + 5%, etc)
Currency handling using symbols like $, €, £.
Built-in constants and rich numerical operations.
And much more...
📈 Function Plotting

Plot mathematical functions directly within Numara.
Useful for visualizing equations, exploring parameter changes, or checking how expressions behave.
🔓 Open Source

MIT-licensed.
Unlimited and free to use.

In addition to all [constants](https://mathjs.org/docs/reference/constants.html), [functions](https://mathjs.org/docs/reference/functions.html), and [units](https://mathjs.org/docs/datatypes/units.html) provided by Math.js, following functionalities are provided:

### Shortcut keywords

`ans` Returns the answer from the previous line

`total` Total all numeric values up to this keyword.

`subtotal` Total numeric values within a calculation block after a blank line.

`avg` Average all numeric values up to this keyword

`lineX` Return answer from a specific line, where X is the line number. Ex. `line4` would return the answer from line 4.

`today` Return today's date

`now` Return todays's date and time

### Simple date calculations

Numara allows you to do simple date additions/substractions such as `today + 3 weeks` and `now + 36 hours`. You can also do a date plus/minus a duration such as `7/31/2023 + 4 days` where the date provided must be in user's locale format. If the date is not followed by an operator, the expession is evaluated as 7 divided by 31 divided by 2023.

### Function plotting

When an expression is entered as a function such as `f(x) = 2x^2 + 3x - 5`, Numara will output a link to plot the function and clicking the link will display the plot in a dialog.

### Currency calculations

When enabled, Numara imports currency rates from floatrates.com as units and these units can then be used to do currency calculations such as `1 usd to eur` and `25 hours * 50 usd/hr` (1250 usd)

### Commenting

Any text starting with `//` or `#` will be treated as a comment. You can comment an entire line:

    // This is a comment line
    # So is this

Or, comments can be added to the end of an expression:

    1 + 2 // Add 1 and 2          | 3
    1 + 2 # Add 1 and 2           | 3

### User defined functions and units

#### Functions

Custom functions can be defined to be used in the calculator. Each custom function must be a typed as an object (name: function | value) and separated by a comma `,`

    xyz: (x, y, z) => {
      return x+y+z
    },
    test: 123,

Above examples can be then used in Numara where `xyz(1, 2, 3)` outputs `6` and `test` outputs `123`

#### Units

Custom units can be defined to be used in the calculator. Each custom unit must be a typed as an object (name: unit | unit object) and separated by a comma `,`.

    xunit: '12 foot',

Above examples can be then used in Numara where `5 xunit to ft` outputs `60 ft`

More information on creating units can be found here: [Math.js User-Defined Units](https://mathjs.org/docs/datatypes/units.html#userdefined-units)

## Settings

### Appearance

`Theme` System (Default) | Light | Dark
- Set the app theme.

`Font size` Tiny | Small | Normal (Default) | Large | X-Large
- Set the font size of the calculation text.

`Font weight` Light | Thin | Normal (Default) | Semi Bold | Bold
- Set the font weight of the calculation text.

`Line height` Tiny | Small | Normal (Default) | Large | X-Large
- Set the height of each calculation line.

`Always on top` On | Off (Default)
- Keep Numara on top off all others on the screen.

### Editor

`Syntax highlighting` On (Default) | Off
- Enable syntax highlighting for typed expressions.

`Keyword tooltips` On (Default) | Off
- Display tooltips where available when hovered over keywords such as function names, units, and constants.

`Highlight matching brackets` On (Default) | Off
- When cursor is next to a bracket, highlight the matching bracket.

`Autocomplete hints` On (Default) | Off
- Show autocompletion hints as a list while typing an expression.

`Close matching brackets` On (Default) | Off
- Auto-close brackets and quotes when typed.

`Line numbers` On (Default) | Off
- Show line numbers for each line on the input panel.

`Wrap lines (input only)` On (Default) | Off
- This is setting applies to the input panel only. Allows the overflown text to wrap to the next line. Answers on the output panel will always be displayed on a single line.

`Rulers` On | Off (Default)
- Show rulers to visually separate each line.

`Start with blank page` On | Off (Default)
- Starts the app with a new blank page instead of the last used page.

### Calculator

`Answer position` Left (with divider) (Default) | Right (no divider) | Below expression
- Sets where the answer should be shown in the app.

`Numeric output` Number (Default) | BigNumber | Fraction
- The type of numeric output for functions which cannot determine the numeric type from the inputs. For most functions though, the type of output is determined from the the input: a number as input will return a number as output, a BigNumber as input returns a BigNumber as output.

  For example the functions '2+3', parse('2+3'), range('1:10'), and unit('5cm') use the number configuration setting. But sqrt(4) will always return the number 2 regardless of the number configuration, because the input is a number.

  BigNumbers have higher precision than the default numbers of JavaScript, and Fractions store values in terms of a numerator and denominator.

`Notation` Auto (Default) | Engineering | Exponential | Fixed | Bin | Hex | Oct
- Numeric output type for answers.

  'Auto' (default) Regular number notation for numbers having an absolute value between lower and upper bounds, and uses exponential notation elsewhere. Lower bound is included, upper bound is excluded. For example '123.4' and '1.4e7'.

  'Exponential' - Always use exponential notation. For example '1.234e+2' and '1.4e+7'

  'Engineering' - Always use engineering notation: always have exponential notation, and select the exponent to be a multiple of 3. For example '123.4e+0' and '14.0e+6'

  'Fixed' - Always use regular number notation regardless of the exponential limits.

  'Bin', 'Oct', or 'Hex' - Format the number using binary, octal, or hexadecimal notation. For example '0b1101' and '0x10fe'.

`Precision` (0 - 16) Default 4
- Number of decimal points to display for the answer.

`Upper exponent limit` (0 - 16) Default 12
- Number determining the upper boundary for formatting a value with an exponent.

`Lower exponent limit` (-12 - 0) Default -12
- Number determining the lower boundary for formatting a value with an exponent.

`Matrix type` Matrix (Default) | Array
- The default type of matrix output for functions. Where possible, the type of matrix output from functions is determined from the function input: An array as input will return an Array, a Matrix as input will return a Matrix. In case of no matrix as input, the type of output is determined by the option matrix. In case of mixed matrix inputs, a matrix will be returned always.

`Predictable output` On | Off (Default)
- When On, output type depends only on the input types. When Off (default), output type can vary depending on input values. For example math.sqrt(-4) returns complex('2i') when predictable is Off, and returns NaN when On. Predictable output can be needed when programmatically handling the result of a calculation, but can be inconvenient for users when evaluating dynamic equations.

`Continue previous line` On (Default) | Off
- Choose whether the calculation on a new line should continue from the previous line.

`Line errors` On (Default) | Off
- Show 'Error' in the output panel if a calculation error occurs. User can then click the Error link to see details about the error. This will also highlight the line number red where the error is present.

### Locale

`User Locale` System (Default) | Chinese (PRC) | English (Canada) | English (UK) | English (US) | French (France) | German (Germany) | Italian (Italy) | Japanese (Japan) | Portuguese (Brazil) | Russian (Russia) | Spanish (Mexico) | Spanish (Spain) | Turkish (Turkey)
- Set the locale of the calculator. The type of decimal place and thousands separator, as well as the display of dates, will match the chosen locale. Choosing `System` will use the user's operating system locale.

`Enable for input` On | Off (Default)
- Enable locale-specific number formatting for input values (e.g., decimal and thousands separators).

`Thousand separator` On (Default) | Off
- Choose whether to use thousand separators for numbers grater than 999.

  - `Copy with answer` On | Off (Default)
    Choose whether to include the thousand separator with the copied answer.

  - `Paste with separator` On | Off (Default)
    Enable thousands separator when pasting numbers into the calculator.

`Show day with date` On | Off (Default)
- If 'On', the day of the week will be prepended to the date output when performing date calculations and using keywords such as 'today' and 'now'.

### Notifications

`Location` Top Left | Top Center | Top Right | Bottom Left | Bottom Center (Default) | Bottom Right
- Set the location of the notification pop up on the screen

`Duration (seconds)` 1 | 3 | 5 (Default) | 10 | 30 | Close manually
- Set the duration of the notification pop up on the screen or set to close it manually.

### Currency Conversion

`Enabled` On (Default) | Off
- Enable currency conversions. Currency rates are provided by floatrates.com and updates daily (once in 12 hours at 12 AM/PM)

`Rate update interval` On start (Default) | 1 hour | 3 hour | 6 hour | 12 hour
- Set how often the currency exchange rates are updated.

## 3rd Party Library Integration
### Formula.js
- Numara can process limited number of Excel functions based on the [formulajs](https://github.com/formulajs/formulajs) library. For more information about available functions, please visit [https://formulajs.info](https://formulajs.info)
  
  Example:
  ```javscript
  formulajs.ABS(-2)    // 2
  ```

### Nerdamer
- Numara can process [Nerdamer](https://nerdamer.com/) functions for added symbolic math expression evaluation support.  For more information about Nerdamer, please visit [https://nerdamer.com/](https://nerdamer.com/)
  
  Example:
  ```javscript
  nerdamer.solve("x^3-10x^2+31x-30", "x")    // [3,5,2]
  ```

### Algebra
#### derivative
Takes the derivative of an expression expressed in parser Nodes. The derivative will be taken over the supplied variable in the second parameter. If there are multiple variables in the expression, it will return a partial derivative.

Syntax: `derivative(expr, variable)` `derivative(expr, variable, {simplify: boolean})`

	derivative("2x^3", "x")
	derivative("2x^3", "x", {simplify: false})
	derivative("2x^2 + 3x + 4", "x")
	derivative("sin(2x)", "x")
	f = parse("x^2 + x")
	x = parse("x")
	df = derivative(f, x)
	df.evaluate({x: 3})

Also see: [simplify](#simplify), [parse](#parse), [evaluate](#evaluate)

#### leafCount
Computes the number of leaves in the parse tree of the given expression

Syntax: `leafCount(expr)`

	leafCount("e^(i*pi)-1")
	leafCount(parse("{a: 22/7, b: 10^(1/2)}"))

Also see: [simplify](#simplify)

#### lsolve
Finds one solution of the linear system L * x = b where L is an [n x n] lower triangular matrix and b is a [n] column vector.

Syntax: `x=lsolve(L, b)`

	a = [-2, 3; 2, 1]
	b = [11, 9]
	x = lsolve(a, b)

Also see: [lsolveAll](#lsolveall), [lup](#lup), [lusolve](#lusolve), [usolve](#usolve), [matrix](#matrix), [sparse](#sparse)

#### lsolveAll
Finds all solutions of the linear system L * x = b where L is an [n x n] lower triangular matrix and b is a [n] column vector.

Syntax: `x=lsolveAll(L, b)`

	a = [-2, 3; 2, 1]
	b = [11, 9]
	x = lsolve(a, b)

Also see: [lsolve](#lsolve), [lup](#lup), [lusolve](#lusolve), [usolve](#usolve), [matrix](#matrix), [sparse](#sparse)

#### lup
Calculate the Matrix LU decomposition with partial pivoting. Matrix A is decomposed in three matrices (L, U, P) where P * A = L * U

Syntax: `lup(m)`

	lup([[2, 1], [1, 4]])
	lup(matrix([[2, 1], [1, 4]]))
	lup(sparse([[2, 1], [1, 4]]))

Also see: [lusolve](#lusolve), [lsolve](#lsolve), [usolve](#usolve), [matrix](#matrix), [sparse](#sparse), [slu](#slu), [qr](#qr)

#### lusolve
Solves the linear system A * x = b where A is an [n x n] matrix and b is a [n] column vector.

Syntax: `x=lusolve(A, b)` `x=lusolve(lu, b)`

	a = [-2, 3; 2, 1]
	b = [11, 9]
	x = lusolve(a, b)

Also see: [lup](#lup), [slu](#slu), [lsolve](#lsolve), [usolve](#usolve), [matrix](#matrix), [sparse](#sparse)

#### lyap
Solves the Continuous-time Lyapunov equation AP+PA'+Q=0 for P

Syntax: `lyap(A,Q)`

	lyap([[-2, 0], [1, -4]], [[3, 1], [1, 3]])
	A = [[-2, 0], [1, -4]]
	Q = [[3, 1], [1, 3]]
	lyap(A,Q)

Also see: [schur](#schur), [sylvester](#sylvester)

#### polynomialRoot
Finds the roots of a univariate polynomial given by its coefficients starting from constant, linear, and so on, increasing in degree.

Syntax: `x=polynomialRoot(-6, 3)` `x=polynomialRoot(4, -4, 1)` `x=polynomialRoot(-8, 12, -6, 1)`

	a = polynomialRoot(-6, 11, -6, 1)

Also see: [cbrt](#cbrt), [sqrt](#sqrt)

#### qr
Calculates the Matrix QR decomposition. Matrix `A` is decomposed in two matrices (`Q`, `R`) where `Q` is an orthogonal matrix and `R` is an upper triangular matrix.

Syntax: `qr(A)`

	qr([[1, -1,  4], [1,  4, -2], [1,  4,  2], [1,  -1, 0]])

Also see: [lup](#lup), [slu](#slu), [matrix](#matrix)

#### rationalize
Transform a rationalizable expression in a rational fraction. If rational fraction is one variable polynomial then converts the numerator and denominator in canonical form, with decreasing exponents, returning the coefficients of numerator.

Syntax: `rationalize(expr)` `rationalize(expr, scope)` `rationalize(expr, scope, detailed)`

	rationalize("2x/y - y/(x+1)")
	rationalize("2x/y - y/(x+1)", true)

Also see: [simplify](#simplify)

#### resolve
Recursively substitute variables in an expression tree.

Syntax: `resolve(node, scope)`

	resolve(parse("1 + x"), { x: 7 })
	resolve(parse("size(text)"), { text: "Hello World" })
	resolve(parse("x + y"), { x: parse("3z") })
	resolve(parse("3x"), { x: parse("y+z"), z: parse("w^y") })

Also see: [simplify](#simplify), [evaluate](#evaluate)

#### schur
Performs a real Schur decomposition of the real matrix A = UTU'

Syntax: `schur(A)`

	schur([[1, 0], [-4, 3]])
	A = [[1, 0], [-4, 3]]
	schur(A)

Also see: [lyap](#lyap), [sylvester](#sylvester)

#### simplify
Simplify an expression tree.

Syntax: `simplify(expr)` `simplify(expr, rules)`

	simplify("3 + 2 / 4")
	simplify("2x + x")
	f = parse("x * (x + 2 + x)")
	simplified = simplify(f)
	simplified.evaluate({x: 2})

Also see: [simplifyCore](#simplifycore), [derivative](#derivative), [evaluate](#evaluate), [parse](#parse), [rationalize](#rationalize), [resolve](#resolve)

#### simplifyConstant
Replace constant subexpressions of node with their values.

Syntax: `simplifyConstant(expr)` `simplifyConstant(expr, options)`

	simplifyConstant("(3-3)*x")
	simplifyConstant(parse("z-cos(tau/8)"))

Also see: [simplify](#simplify), [simplifyCore](#simplifycore), [evaluate](#evaluate)

#### simplifyCore
Perform simple one-pass simplifications on an expression tree.

Syntax: `simplifyCore(node)`

	simplifyCore(parse("0*x"))
	simplifyCore(parse("(x+0)*2"))

Also see: [simplify](#simplify), [simplifyConstant](#simplifyconstant), [evaluate](#evaluate)

#### slu
Calculate the Matrix LU decomposition with full pivoting. Matrix A is decomposed in two matrices (L, U) and two permutation vectors (pinv, q) where P * A * Q = L * U

Syntax: `slu(A, order, threshold)`

	slu(sparse([4.5, 0, 3.2, 0; 3.1, 2.9, 0, 0.9; 0, 1.7, 3, 0; 3.5, 0.4, 0, 1]), 1, 0.001)

Also see: [lusolve](#lusolve), [lsolve](#lsolve), [usolve](#usolve), [matrix](#matrix), [sparse](#sparse), [lup](#lup), [qr](#qr)

#### sylvester
Solves the real-valued Sylvester equation AX+XB=C for X

Syntax: `sylvester(A,B,C)`

	sylvester([[-1, -2], [1, 1]], [[-2, 1], [-1, 2]], [[-3, 2], [3, 0]])
	A = [[-1, -2], [1, 1]]; B = [[2, -1], [1, -2]]; C = [[-3, 2], [3, 0]]
	sylvester(A, B, C)

Also see: [schur](#schur), [lyap](#lyap)

#### symbolicEqual
Returns true if the difference of the expressions simplifies to 0

Syntax: `symbolicEqual(expr1, expr2)` `symbolicEqual(expr1, expr2, options)`

	symbolicEqual("x*y","y*x")
	symbolicEqual("abs(x^2)", "x^2")
	symbolicEqual("abs(x)", "x", {context: {abs: {trivial: true}}})

Also see: [simplify](#simplify), [evaluate](#evaluate)

#### usolve
Finds one solution of the linear system U * x = b where U is an [n x n] upper triangular matrix and b is a [n] column vector.

Syntax: `x=usolve(U, b)`

	x=usolve(sparse([1, 1, 1, 1; 0, 1, 1, 1; 0, 0, 1, 1; 0, 0, 0, 1]), [1; 2; 3; 4])

Also see: [usolveAll](#usolveall), [lup](#lup), [lusolve](#lusolve), [lsolve](#lsolve), [matrix](#matrix), [sparse](#sparse)

#### usolveAll
Finds all solutions of the linear system U * x = b where U is an [n x n] upper triangular matrix and b is a [n] column vector.

Syntax: `x=usolve(U, b)`

	x=usolve(sparse([1, 1, 1, 1; 0, 1, 1, 1; 0, 0, 1, 1; 0, 0, 0, 1]), [1; 2; 3; 4])

Also see: [usolve](#usolve), [lup](#lup), [lusolve](#lusolve), [lsolve](#lsolve), [matrix](#matrix), [sparse](#sparse)
### Arithmetic
#### abs
Compute the absolute value.

Syntax: `abs(x)`

	abs(3.5)
	abs(-4.2)

Also see: [sign](#sign)

#### cbrt
Compute the cubic root value. If x = y * y * y, then y is the cubic root of x. When `x` is a number or complex number, an optional second argument `allRoots` can be provided to return all three cubic roots. If not provided, the principal root is returned

Syntax: `cbrt(x)` `cbrt(x, allRoots)`

	cbrt(64)
	cube(4)
	cbrt(-8)
	cbrt(2 + 3i)
	cbrt(8i)
	cbrt(8i, true)
	cbrt(27 m^3)

Also see: [square](#square), [sqrt](#sqrt), [cube](#cube), [multiply](#multiply)

#### ceil
Round a value towards plus infinity. If x is complex, both real and imaginary part are rounded towards plus infinity.

Syntax: `ceil(x)` `ceil(x, n)` `ceil(unit, valuelessUnit)` `ceil(unit, n, valuelessUnit)`

	ceil(3.2)
	ceil(3.8)
	ceil(-4.2)
	ceil(3.241cm, cm)
	ceil(3.241cm, 2, cm)

Also see: [floor](#floor), [fix](#fix), [round](#round)

#### cube
Compute the cube of a value. The cube of x is x * x * x.

Syntax: `cube(x)`

	cube(2)
	2^3
	2 * 2 * 2

Also see: [multiply](#multiply), [square](#square), [pow](#pow)

#### exp
Calculate the exponent of a value.

Syntax: `exp(x)`

	exp(1.3)
	e ^ 1.3
	log(exp(1.3))
	x = 2.4
	(exp(i*x) == cos(x) + i*sin(x))   # Euler's formula

Also see: [expm](#expm), [expm1](#expm1), [pow](#pow), [log](#log)

#### expm
Compute the matrix exponential, expm(A) = e^A. The matrix must be square. Not to be confused with exp(a), which performs element-wise exponentiation.

Syntax: `exp(x)`

	expm([[0,2],[0,0]])

Also see: [exp](#exp)

#### expm1
Calculate the value of subtracting 1 from the exponential value.

Syntax: `expm1(x)`

	expm1(2)
	pow(e, 2) - 1
	log(expm1(2) + 1)

Also see: [exp](#exp), [pow](#pow), [log](#log)

#### fix
Round a value towards zero. If x is complex, both real and imaginary part are rounded towards zero.

Syntax: `fix(x)` `fix(x, n)` `fix(unit, valuelessUnit)` `fix(unit, n, valuelessUnit)`

	fix(3.2)
	fix(3.8)
	fix(-4.2)
	fix(-4.8)
	fix(3.241cm, cm)
	fix(3.241cm, 2, cm)

Also see: [ceil](#ceil), [floor](#floor), [round](#round)

#### floor
Round a value towards minus infinity.If x is complex, both real and imaginary part are rounded towards minus infinity.

Syntax: `floor(x)` `floor(x, n)` `floor(unit, valuelessUnit)` `floor(unit, n, valuelessUnit)`

	floor(3.2)
	floor(3.8)
	floor(-4.2)
	floor(3.241cm, cm)
	floor(3.241cm, 2, cm)

Also see: [ceil](#ceil), [fix](#fix), [round](#round)

#### gcd
Compute the greatest common divisor.

Syntax: `gcd(a, b)` `gcd(a, b, c, ...)`

	gcd(8, 12)
	gcd(-4, 6)
	gcd(25, 15, -10)

Also see: [lcm](#lcm), [xgcd](#xgcd)

#### hypot
Calculate the hypotenuse of a list with values.

Syntax: `hypot(a, b, c, ...)` `hypot([a, b, c, ...])`

	hypot(3, 4)
	sqrt(3^2 + 4^2)
	hypot(-2)
	hypot([3, 4, 5])

Also see: [abs](#abs), [norm](#norm)

#### invmod
Calculate the (modular) multiplicative inverse of a modulo b. Solution to the equation ax ≣ 1 (mod b)

Syntax: `invmod(a, b)`

	invmod(8, 12)
	invmod(7, 13)
	invmod(15151, 15122)

Also see: [gcd](#gcd), [xgcd](#xgcd)

#### lcm
Compute the least common multiple.

Syntax: `lcm(x, y)`

	lcm(4, 6)
	lcm(6, 21)
	lcm(6, 21, 5)

Also see: [gcd](#gcd)

#### log
Compute the logarithm of a value. If no base is provided, the natural logarithm of x is calculated. If base if provided, the logarithm is calculated for the specified base. log(x, base) is defined as log(x) / log(base).

Syntax: `log(x)` `log(x, base)`

	log(3.5)
	a = log(2.4)
	exp(a)
	10 ^ 4
	log(10000, 10)
	log(10000) / log(10)
	b = log(1024, 2)
	2 ^ b

Also see: [exp](#exp), [log1p](#log1p), [log2](#log2), [log10](#log10)

#### log10
Compute the 10-base logarithm of a value.

Syntax: `log10(x)`

	log10(0.00001)
	log10(10000)
	10 ^ 4
	log(10000) / log(10)
	log(10000, 10)

Also see: [exp](#exp), [log](#log)

#### log1p
Calculate the logarithm of a `value+1`

Syntax: `log1p(x)` `log1p(x, base)`

	log1p(2.5)
	exp(log1p(1.4))
	pow(10, 4)
	log1p(9999, 10)
	log1p(9999) / log(10)

Also see: [exp](#exp), [log](#log), [log2](#log2), [log10](#log10)

#### log2
Calculate the 2-base of a value. This is the same as calculating `log(x, 2)`.

Syntax: `log2(x)`

	log2(0.03125)
	log2(16)
	log2(16) / log2(2)
	pow(2, 4)

Also see: [exp](#exp), [log1p](#log1p), [log](#log), [log10](#log10)

#### norm
Calculate the norm of a number, vector or matrix.

Syntax: `norm(x)` `norm(x, p)`

	abs(-3.5)
	norm(-3.5)
	norm(3 - 4i)
	norm([1, 2, -3], Infinity)
	norm([1, 2, -3], -Infinity)
	norm([3, 4], 2)
	norm([[1, 2], [3, 4]], 1)
	norm([[1, 2], [3, 4]], "inf")
	norm([[1, 2], [3, 4]], "fro")



#### nthRoot
Calculate the nth root of a value. The principal nth root of a positive real number A, is the positive real solution of the equation "x^root = A".

Syntax: `nthRoot(a)` `nthRoot(a, root)`

	4 ^ 3
	nthRoot(64, 3)
	nthRoot(9, 2)
	sqrt(9)

Also see: [nthRoots](#nthroots), [pow](#pow), [sqrt](#sqrt)

#### nthRoots
Calculate the nth roots of a value. An nth root of a positive real number A, is a positive real solution of the equation "x^root = A". This function returns an array of complex values.

Syntax: `nthRoots(A)` `nthRoots(A, root)`

	nthRoots(1)
	nthRoots(1, 3)

Also see: [sqrt](#sqrt), [pow](#pow), [nthRoot](#nthroot)

#### round
round a value towards the nearest integer.If x is complex, both real and imaginary part are rounded towards the nearest integer. When n is specified, the value is rounded to n decimals.

Syntax: `round(x)` `round(x, n)` `round(unit, valuelessUnit)` `round(unit, n, valuelessUnit)`

	round(3.2)
	round(3.8)
	round(-4.2)
	round(-4.8)
	round(pi, 3)
	round(123.45678, 2)
	round(3.241cm, 2, cm)
	round([3.2, 3.8, -4.7])

Also see: [ceil](#ceil), [floor](#floor), [fix](#fix)

#### sign
Compute the sign of a value. The sign of a value x is 1 when x>0, -1 when x<0, and 0 when x=0.

Syntax: `sign(x)`

	sign(3.5)
	sign(-4.2)
	sign(0)

Also see: [abs](#abs)

#### sqrt
Compute the square root value. If x = y * y, then y is the square root of x.

Syntax: `sqrt(x)`

	sqrt(25)
	5 * 5
	sqrt(-1)

Also see: [square](#square), [sqrtm](#sqrtm), [multiply](#multiply), [nthRoot](#nthroot), [nthRoots](#nthroots), [pow](#pow)

#### sqrtm
Calculate the principal square root of a square matrix. The principal square root matrix `X` of another matrix `A` is such that `X * X = A`.

Syntax: `sqrtm(x)`

	sqrtm([[33, 24], [48, 57]])

Also see: [sqrt](#sqrt), [abs](#abs), [square](#square), [multiply](#multiply)

#### square
Compute the square of a value. The square of x is x * x.

Syntax: `square(x)`

	square(3)
	sqrt(9)
	3^2
	3 * 3

Also see: [multiply](#multiply), [pow](#pow), [sqrt](#sqrt), [cube](#cube)

#### xgcd
Calculate the extended greatest common divisor for two values. The result is an array [d, x, y] with 3 entries, where d is the greatest common divisor, and d = x * a + y * b.

Syntax: `xgcd(a, b)`

	xgcd(8, 12)
	gcd(8, 12)
	xgcd(36163, 21199)

Also see: [gcd](#gcd), [lcm](#lcm)
### Bitwise
#### bitAnd
Bitwise AND operation. Performs the logical AND operation on each pair of the corresponding bits of the two given values by multiplying them. If both bits in the compared position are 1, the bit in the resulting binary representation is 1, otherwise, the result is 0

Syntax: `x & y` `bitAnd(x, y)`

	5 & 3
	bitAnd(53, 131)
	[1, 12, 31] & 42

Also see: [bitNot](#bitnot), [bitOr](#bitor), [bitXor](#bitxor), [leftShift](#leftshift), [rightArithShift](#rightarithshift), [rightLogShift](#rightlogshift)

#### bitNot
Bitwise NOT operation. Performs a logical negation on each bit of the given value. Bits that are 0 become 1, and those that are 1 become 0.

Syntax: `~x` `bitNot(x)`

	~1
	~2
	bitNot([2, -3, 4])

Also see: [bitAnd](#bitand), [bitOr](#bitor), [bitXor](#bitxor), [leftShift](#leftshift), [rightArithShift](#rightarithshift), [rightLogShift](#rightlogshift)

#### bitOr
Bitwise OR operation. Performs the logical inclusive OR operation on each pair of corresponding bits of the two given values. The result in each position is 1 if the first bit is 1 or the second bit is 1 or both bits are 1, otherwise, the result is 0.

Syntax: `x | y` `bitOr(x, y)`

	5 | 3
	bitOr([1, 2, 3], 4)

Also see: [bitAnd](#bitand), [bitNot](#bitnot), [bitXor](#bitxor), [leftShift](#leftshift), [rightArithShift](#rightarithshift), [rightLogShift](#rightlogshift)

#### bitXor
Bitwise XOR operation, exclusive OR. Performs the logical exclusive OR operation on each pair of corresponding bits of the two given values. The result in each position is 1 if only the first bit is 1 or only the second bit is 1, but will be 0 if both are 0 or both are 1.

Syntax: `bitXor(x, y)`

	bitOr(1, 2)
	bitXor([2, 3, 4], 4)

Also see: [bitAnd](#bitand), [bitNot](#bitnot), [bitOr](#bitor), [leftShift](#leftshift), [rightArithShift](#rightarithshift), [rightLogShift](#rightlogshift)

#### leftShift
Bitwise left logical shift of a value x by y number of bits.

Syntax: `x << y` `leftShift(x, y)`

	4 << 1
	8 >> 1

Also see: [bitAnd](#bitand), [bitNot](#bitnot), [bitOr](#bitor), [bitXor](#bitxor), [rightArithShift](#rightarithshift), [rightLogShift](#rightlogshift)

#### rightArithShift
Bitwise right arithmetic shift of a value x by y number of bits.

Syntax: `x >> y` `rightArithShift(x, y)`

	8 >> 1
	4 << 1
	-12 >> 2

Also see: [bitAnd](#bitand), [bitNot](#bitnot), [bitOr](#bitor), [bitXor](#bitxor), [leftShift](#leftshift), [rightLogShift](#rightlogshift)

#### rightLogShift
Bitwise right logical shift of a value x by y number of bits.

Syntax: `x >>> y` `rightLogShift(x, y)`

	8 >>> 1
	4 << 1
	-12 >>> 2

Also see: [bitAnd](#bitand), [bitNot](#bitnot), [bitOr](#bitor), [bitXor](#bitxor), [leftShift](#leftshift), [rightArithShift](#rightarithshift)
### Combinatorics
#### bellNumbers
The Bell Numbers count the number of partitions of a set. A partition is a pairwise disjoint subset of S whose union is S. `bellNumbers` only takes integer arguments. The following condition must be enforced: n >= 0.

Syntax: `bellNumbers(n)`

	bellNumbers(3)
	bellNumbers(8)

Also see: [stirlingS2](#stirlings2)

#### catalan
The Catalan Numbers enumerate combinatorial structures of many different types. catalan only takes integer arguments. The following condition must be enforced: n >= 0.

Syntax: `catalan(n)`

	catalan(3)
	catalan(8)

Also see: [bellNumbers](#bellnumbers)

#### composition
The composition counts of n into k parts. composition only takes integer arguments. The following condition must be enforced: k <= n.

Syntax: `composition(n, k)`

	composition(5, 3)

Also see: [combinations](#combinations)

#### stirlingS2
The Stirling numbers of the second kind, counts the number of ways to partition a set of n labelled objects into k nonempty unlabelled subsets. `stirlingS2` only takes integer arguments. The following condition must be enforced: k <= n. If n = k or k = 1, then s(n,k) = 1.

Syntax: `stirlingS2(n, k)`

	stirlingS2(5, 3)

Also see: [bellNumbers](#bellnumbers), [bernoulli](#bernoulli)
### Complex
#### arg
Compute the argument of a complex value. If x = a+bi, the argument is computed as atan2(b, a).

Syntax: `arg(x)`

	arg(2 + 2i)
	atan2(3, 2)
	arg(2 + 3i)

Also see: [re](#re), [im](#im), [conj](#conj), [abs](#abs)

#### conj
Compute the complex conjugate of a complex value. If x = a+bi, the complex conjugate is a-bi.

Syntax: `conj(x)`

	conj(2 + 3i)
	conj(2 - 3i)
	conj(-5.2i)

Also see: [re](#re), [im](#im), [abs](#abs), [arg](#arg)

#### im
Get the imaginary part of a complex number.

Syntax: `im(x)`

	im(2 + 3i)
	re(2 + 3i)
	im(-5.2i)
	im(2.4)

Also see: [re](#re), [conj](#conj), [abs](#abs), [arg](#arg)

#### re
Get the real part of a complex number.

Syntax: `re(x)`

	re(2 + 3i)
	im(2 + 3i)
	re(-5.2i)
	re(2.4)

Also see: [im](#im), [conj](#conj), [abs](#abs), [arg](#arg)
### Constants
#### e
Euler's number, the base of the natural logarithm. Approximately equal to 2.71828

Syntax: `e`

	e
	e ^ 2
	exp(2)
	log(e)

Also see: [exp](#exp)

#### false
Boolean value false

Syntax: `false`

	false

Also see: [true](#true)

#### i
Imaginary unit, defined as i*i=-1. A complex number is described as a + b*i, where a is the real part, and b is the imaginary part.

Syntax: `i`

	i
	i * i
	sqrt(-1)



#### Infinity
Infinity, a number which is larger than the maximum number that can be handled by a floating point number.

Syntax: `Infinity`

	Infinity
	1 / 0



#### LN10
Returns the natural logarithm of 10, approximately equal to 2.302

Syntax: `LN10`

	LN10
	log(10)



#### LN2
Returns the natural logarithm of 2, approximately equal to 0.693

Syntax: `LN2`

	LN2
	log(2)



#### LOG10E
Returns the base-10 logarithm of E, approximately equal to 0.434

Syntax: `LOG10E`

	LOG10E
	log(e, 10)



#### LOG2E
Returns the base-2 logarithm of E, approximately equal to 1.442

Syntax: `LOG2E`

	LOG2E
	log(e, 2)



#### NaN
Not a number

Syntax: `NaN`

	NaN
	0 / 0



#### null
Value null

Syntax: `null`

	null

Also see: [true](#true), [false](#false)

#### phi
Phi is the golden ratio. Two quantities are in the golden ratio if their ratio is the same as the ratio of their sum to the larger of the two quantities. Phi is defined as `(1 + sqrt(5)) / 2` and is approximately 1.618034...

Syntax: `phi`

	phi



#### pi
The number pi is a mathematical constant that is the ratio of a circle's circumference to its diameter, and is approximately equal to 3.14159

Syntax: `pi`

	pi
	sin(pi/2)

Also see: [tau](#tau)

#### SQRT1_2
Returns the square root of 1/2, approximately equal to 0.707

Syntax: `SQRT1_2`

	SQRT1_2
	sqrt(1/2)



#### SQRT2
Returns the square root of 2, approximately equal to 1.414

Syntax: `SQRT2`

	SQRT2
	sqrt(2)



#### tau
Tau is the ratio constant of a circle's circumference to radius, equal to 2 * pi, approximately 6.2832.

Syntax: `tau`

	tau
	2 * pi

Also see: [pi](#pi)

#### true
Boolean value true

Syntax: `true`

	true

Also see: [false](#false)

#### e
Euler's number, the base of the natural logarithm. Approximately equal to 2.71828

Syntax: `e`

	e
	e ^ 2
	exp(2)
	log(e)

Also see: [exp](#exp)

#### pi
The number pi is a mathematical constant that is the ratio of a circle's circumference to its diameter, and is approximately equal to 3.14159

Syntax: `pi`

	pi
	sin(pi/2)

Also see: [tau](#tau)

#### version
A string with the version number of math.js

Syntax: `version`

	version


### Construction
#### bigint
Create a bigint, an integer with an arbitrary number of digits, from a number or string.

Syntax: `bigint(x)`

	123123123123123123 # a large number will lose digits
	bigint("123123123123123123")
	bignumber(["1", "3", "5"])

Also see: [boolean](#boolean), [bignumber](#bignumber), [number](#number), [complex](#complex), [fraction](#fraction), [index](#index), [matrix](#matrix), [string](#string), [unit](#unit)

#### bignumber
Create a big number from a number or string.

Syntax: `bignumber(x)`

	0.1 + 0.2
	bignumber(0.1) + bignumber(0.2)
	bignumber("7.2")
	bignumber("7.2e500")
	bignumber([0.1, 0.2, 0.3])

Also see: [boolean](#boolean), [bigint](#bigint), [complex](#complex), [fraction](#fraction), [index](#index), [matrix](#matrix), [string](#string), [unit](#unit)

#### boolean
Convert a string or number into a boolean.

Syntax: `x` `boolean(x)`

	boolean(0)
	boolean(1)
	boolean(3)
	boolean("true")
	boolean("false")
	boolean([1, 0, 1, 1])

Also see: [bignumber](#bignumber), [complex](#complex), [index](#index), [matrix](#matrix), [number](#number), [string](#string), [unit](#unit)

#### complex
Create a complex number.

Syntax: `complex()` `complex(re, im)` `complex(string)`

	complex()
	complex(2, 3)
	complex("7 - 2i")

Also see: [bignumber](#bignumber), [boolean](#boolean), [index](#index), [matrix](#matrix), [number](#number), [string](#string), [unit](#unit)

#### createUnit
Create a user-defined unit and register it with the Unit type.

Syntax: `createUnit(definitions)` `createUnit(name, definition)`

	createUnit("foo")
	createUnit("knot", {definition: "0.514444444 m/s", aliases: ["knots", "kt", "kts"]})
	createUnit("mph", "1 mile/hour")

Also see: [unit](#unit), [splitUnit](#splitunit)

#### fraction
Create a fraction from a number or from integer numerator and denominator.

Syntax: `fraction(num)` `fraction(matrix)` `fraction(num,den)` `fraction({n: num, d: den})`

	fraction(0.125)
	fraction(1, 3) + fraction(2, 5)
	fraction({n: 333, d: 53})
	fraction([sqrt(9), sqrt(10), sqrt(11)])

Also see: [bignumber](#bignumber), [boolean](#boolean), [complex](#complex), [index](#index), [matrix](#matrix), [string](#string), [unit](#unit)

#### index
Create an index to get or replace a subset of a matrix

Syntax: `[start]` `[start:end]` `[start:step:end]` `[start1, start 2, ...]` `[start1:end1, start2:end2, ...]` `[start1:step1:end1, start2:step2:end2, ...]`

	A = [1, 2, 3; 4, 5, 6]
	A[1, :]
	A[1, 2] = 50
	A[1:2, 1:2] = 1
	B = [1, 2, 3]
	B[B>1 and B<3]

Also see: [bignumber](#bignumber), [boolean](#boolean), [complex](#complex), [matrix](#matrix), [number](#number), [range](#range), [string](#string), [unit](#unit)

#### matrix
Create a matrix.

Syntax: `[]` `[a1, b1, ...; a2, b2, ...]` `matrix()` `matrix("dense")` `matrix([...])`

	[]
	[1, 2, 3]
	[1, 2, 3; 4, 5, 6]
	matrix()
	matrix([3, 4])
	matrix([3, 4; 5, 6], "sparse")
	matrix([3, 4; 5, 6], "sparse", "number")

Also see: [bignumber](#bignumber), [boolean](#boolean), [complex](#complex), [index](#index), [number](#number), [string](#string), [unit](#unit), [sparse](#sparse)

#### number
Create a number or convert a string or boolean into a number.

Syntax: `x` `number(x)` `number(unit, valuelessUnit)`

	2
	2e3
	4.05
	number(2)
	number("7.2")
	number(true)
	number([true, false, true, true])
	number(unit("52cm"), "m")

Also see: [bignumber](#bignumber), [bigint](#bigint), [boolean](#boolean), [complex](#complex), [fraction](#fraction), [index](#index), [matrix](#matrix), [string](#string), [unit](#unit)

#### sparse
Create a sparse matrix.

Syntax: `sparse()` `sparse([a1, b1, ...; a1, b2, ...])` `sparse([a1, b1, ...; a1, b2, ...], "number")`

	sparse()
	sparse([3, 4; 5, 6])
	sparse([3, 0; 5, 0], "number")

Also see: [bignumber](#bignumber), [boolean](#boolean), [complex](#complex), [index](#index), [number](#number), [string](#string), [unit](#unit), [matrix](#matrix)

#### splitUnit
Split a unit in an array of units whose sum is equal to the original unit.

Syntax: `splitUnit(unit: Unit, parts: Unit[])`

	splitUnit(1 m, ["feet", "inch"])

Also see: [unit](#unit), [createUnit](#createunit)

#### string
Create a string or convert a value to a string

Syntax: `"text"` `string(x)`

	"Hello World!"
	string(4.2)
	string(3 + 2i)

Also see: [bignumber](#bignumber), [boolean](#boolean), [complex](#complex), [index](#index), [matrix](#matrix), [number](#number), [unit](#unit)

#### unit
Create a unit.

Syntax: `value unit` `unit(value, unit)` `unit(string)`

	5.5 mm
	3 inch
	unit(7.1, "kilogram")
	unit("23 deg")

Also see: [bignumber](#bignumber), [boolean](#boolean), [complex](#complex), [index](#index), [matrix](#matrix), [number](#number), [string](#string)
### Geometry
#### distance
Calculates the Euclidean distance between two points.

Syntax: `distance([x1, y1], [x2, y2])` `distance([[x1, y1], [x2, y2]])`

	distance([0,0], [4,4])
	distance([[0,0], [4,4]])



#### intersect
Computes the intersection point of lines and/or planes.

Syntax: `intersect(expr1, expr2, expr3, expr4)` `intersect(expr1, expr2, expr3)`

	intersect([0, 0], [10, 10], [10, 0], [0, 10])
	intersect([1, 0, 1],  [4, -2, 2], [1, 1, 1, 6])


### Logical
#### and
Logical and. Test whether two values are both defined with a nonzero/nonempty value.

Syntax: `x and y` `and(x, y)`

	true and false
	true and true
	2 and 4

Also see: [not](#not), [or](#or), [xor](#xor)

#### not
Logical not. Flips the boolean value of given argument.

Syntax: `not x` `not(x)`

	not true
	not false
	not 2
	not 0

Also see: [and](#and), [or](#or), [xor](#xor)

#### nullish
Nullish coalescing operator. Returns the right-hand operand when the left-hand operand is null or undefined, and otherwise returns the left-hand operand.

Syntax: `x ?? y` `nullish(x, y)`

	null ?? 42
	undefined ?? 42
	0 ?? 42
	false ?? 42
	null ?? undefined ?? 42

Also see: [and](#and), [or](#or), [not](#not)

#### or
Logical or. Test if at least one value is defined with a nonzero/nonempty value.

Syntax: `x or y` `or(x, y)`

	true or false
	false or false
	0 or 4

Also see: [not](#not), [and](#and), [xor](#xor)

#### xor
Logical exclusive or, xor. Test whether one and only one value is defined with a nonzero/nonempty value.

Syntax: `x xor y` `xor(x, y)`

	true xor false
	false xor false
	true xor true
	0 xor 4

Also see: [not](#not), [and](#and), [or](#or)
### Matrix
#### column
Return a column from a matrix or array.

Syntax: `column(x, index)`

	A = [[1, 2], [3, 4]]
	column(A, 1)
	column(A, 2)

Also see: [row](#row), [matrixFromColumns](#matrixfromcolumns)

#### concat
Concatenate matrices. By default, the matrices are concatenated by the last dimension. The dimension on which to concatenate can be provided as last argument.

Syntax: `concat(A, B, C, ...)` `concat(A, B, C, ..., dim)`

	A = [1, 2; 5, 6]
	B = [3, 4; 7, 8]
	concat(A, B)
	concat(A, B, 1)
	concat(A, B, 2)

Also see: [det](#det), [diag](#diag), [identity](#identity), [inv](#inv), [ones](#ones), [range](#range), [size](#size), [squeeze](#squeeze), [subset](#subset), [trace](#trace), [transpose](#transpose), [zeros](#zeros)

#### count
Count the number of elements of a matrix, array or string.

Syntax: `count(x)`

	a = [1, 2; 3, 4; 5, 6]
	count(a)
	size(a)
	count("hello world")

Also see: [size](#size)

#### cross
Calculate the cross product for two vectors in three dimensional space.

Syntax: `cross(A, B)`

	cross([1, 1, 0],  [0, 1, 1])
	cross([3, -3, 1], [4, 9, 2])
	cross([2, 3, 4],  [5, 6, 7])

Also see: [multiply](#multiply), [dot](#dot)

#### ctranspose
Complex Conjugate and Transpose a matrix

Syntax: `x'` `ctranspose(x)`

	a = [1, 2, 3; 4, 5, 6]
	a'
	ctranspose(a)

Also see: [concat](#concat), [det](#det), [diag](#diag), [identity](#identity), [inv](#inv), [ones](#ones), [range](#range), [size](#size), [squeeze](#squeeze), [subset](#subset), [trace](#trace), [zeros](#zeros)

#### det
Calculate the determinant of a matrix

Syntax: `det(x)`

	det([1, 2; 3, 4])
	det([-2, 2, 3; -1, 1, 3; 2, 0, -1])

Also see: [concat](#concat), [diag](#diag), [identity](#identity), [inv](#inv), [ones](#ones), [range](#range), [size](#size), [squeeze](#squeeze), [subset](#subset), [trace](#trace), [transpose](#transpose), [zeros](#zeros)

#### diag
Create a diagonal matrix or retrieve the diagonal of a matrix. When x is a vector, a matrix with the vector values on the diagonal will be returned. When x is a matrix, a vector with the diagonal values of the matrix is returned. When k is provided, the k-th diagonal will be filled in or retrieved, if k is positive, the values are placed on the super diagonal. When k is negative, the values are placed on the sub diagonal.

Syntax: `diag(x)` `diag(x, k)`

	diag(1:3)
	diag(1:3, 1)
	a = [1, 2, 3; 4, 5, 6; 7, 8, 9]
	diag(a)

Also see: [concat](#concat), [det](#det), [identity](#identity), [inv](#inv), [ones](#ones), [range](#range), [size](#size), [squeeze](#squeeze), [subset](#subset), [trace](#trace), [transpose](#transpose), [zeros](#zeros)

#### diff
Create a new matrix or array with the difference of the passed matrix or array.,Dim parameter is optional and used to indicate the dimension of the array/matrix to apply the difference,If no dimension parameter is passed it is assumed as dimension 0,Dimension is zero-based in javascript and one-based in the parser,Arrays must be 'rectangular' meaning arrays like [1, 2],If something is passed as a matrix it will be returned as a matrix but other than that all matrices are converted to arrays

Syntax: `diff(arr)` `diff(arr, dim)`

	A = [1, 2, 4, 7, 0]
	diff(A)
	diff(A, 1)
	B = [[1, 2], [3, 4]]
	diff(B)
	diff(B, 1)
	diff(B, 2)
	diff(B, bignumber(2))
	diff([[1, 2], matrix([3, 4])], 2)

Also see: [subtract](#subtract), [partitionSelect](#partitionselect)

#### dot
Calculate the dot product of two vectors. The dot product of A = [a1, a2, a3, ..., an] and B = [b1, b2, b3, ..., bn] is defined as dot(A, B) = a1 * b1 + a2 * b2 + a3 * b3 + ... + an * bn

Syntax: `dot(A, B)` `A * B`

	dot([2, 4, 1], [2, 2, 3])
	[2, 4, 1] * [2, 2, 3]

Also see: [multiply](#multiply), [cross](#cross)

#### eigs
Calculate the eigenvalues and optionally eigenvectors of a square matrix

Syntax: `eigs(x)`

	eigs([[5, 2.3], [2.3, 1]])
	eigs([[1, 2, 3], [4, 5, 6], [7, 8, 9]], { precision: 1e-6, eigenvectors: false })

Also see: [inv](#inv)

#### fft
Calculate N-dimensional Fourier transform

Syntax: `fft(x)`

	fft([[1, 0], [1, 0]])

Also see: [ifft](#ifft)

#### filter
Filter items in a matrix.

Syntax: `filter(x, test)`

	isPositive(x) = x > 0
	filter([6, -2, -1, 4, 3], isPositive)
	filter([6, -2, 0, 1, 0], x != 0)

Also see: [sort](#sort), [map](#map), [forEach](#foreach)

#### flatten
Flatten a multi dimensional matrix into a single dimensional matrix.

Syntax: `flatten(x)`

	a = [1, 2, 3; 4, 5, 6]
	size(a)
	b = flatten(a)
	size(b)

Also see: [concat](#concat), [resize](#resize), [size](#size), [squeeze](#squeeze)

#### forEach
Iterates over all elements of a matrix/array, and executes the given callback function.

Syntax: `forEach(x, callback)`

	numberOfPets = {}
	addPet(n) = numberOfPets[n] = (numberOfPets[n] ? numberOfPets[n]:0 ) + 1;
	forEach(["Dog","Cat","Cat"], addPet)
	numberOfPets

Also see: [map](#map), [sort](#sort), [filter](#filter)

#### getMatrixDataType
Find the data type of all elements in a matrix or array, for example "number" if all items are a number and "Complex" if all values are complex numbers. If a matrix contains more than one data type, it will return "mixed".

Syntax: `getMatrixDataType(x)`

	getMatrixDataType([1, 2, 3])
	getMatrixDataType([[5 cm], [2 inch]])
	getMatrixDataType([1, "text"])
	getMatrixDataType([1, bignumber(4)])

Also see: [matrix](#matrix), [sparse](#sparse), [typeOf](#typeof)

#### identity
Returns the identity matrix with size m-by-n. The matrix has ones on the diagonal and zeros elsewhere.

Syntax: `identity(n)` `identity(m, n)` `identity([m, n])`

	identity(3)
	identity(3, 5)
	a = [1, 2, 3; 4, 5, 6]
	identity(size(a))

Also see: [concat](#concat), [det](#det), [diag](#diag), [inv](#inv), [ones](#ones), [range](#range), [size](#size), [squeeze](#squeeze), [subset](#subset), [trace](#trace), [transpose](#transpose), [zeros](#zeros)

#### ifft
Calculate N-dimensional inverse Fourier transform

Syntax: `ifft(x)`

	ifft([[2, 2], [0, 0]])

Also see: [fft](#fft)

#### inv
Calculate the inverse of a matrix

Syntax: `inv(x)`

	inv([1, 2; 3, 4])
	inv(4)
	1 / 4

Also see: [concat](#concat), [det](#det), [diag](#diag), [identity](#identity), [ones](#ones), [range](#range), [size](#size), [squeeze](#squeeze), [subset](#subset), [trace](#trace), [transpose](#transpose), [zeros](#zeros)

#### kron
Calculates the Kronecker product of 2 matrices or vectors.

Syntax: `kron(x, y)`

	kron([[1, 0], [0, 1]], [[1, 2], [3, 4]])
	kron([1,1], [2,3,4])

Also see: [multiply](#multiply), [dot](#dot), [cross](#cross)

#### map
Create a new matrix or array with the results of the callback function executed on each entry of the matrix/array or the matrices/arrays.

Syntax: `map(x, callback)` `map(x, y, ..., callback)`

	map([1, 2, 3], square)
	map([1, 2], [3, 4], f(a,b) = a + b)

Also see: [filter](#filter), [forEach](#foreach)

#### mapSlices
Generate a matrix one dimension less than A by applying callback to each slice of A along dimension dim.

Syntax: `mapSlices(A, dim, callback)`

	A = [[1, 2], [3, 4]]
	mapSlices(A, 1, sum)
	mapSlices(A, 2, prod)

Also see: [map](#map), [forEach](#foreach)

#### matrixFromColumns
Create a dense matrix from vectors as individual columns.

Syntax: `matrixFromColumns(...arr)` `matrixFromColumns(row1, row2)` `matrixFromColumns(row1, row2, row3)`

	matrixFromColumns([1, 2, 3], [[4],[5],[6]])

Also see: [matrix](#matrix), [matrixFromRows](#matrixfromrows), [matrixFromFunction](#matrixfromfunction), [zeros](#zeros)

#### matrixFromFunction
Create a matrix by evaluating a generating function at each index.

Syntax: `matrixFromFunction(size, fn)` `matrixFromFunction(size, fn, format)` `matrixFromFunction(size, fn, format, datatype)` `matrixFromFunction(size, format, fn)` `matrixFromFunction(size, format, datatype, fn)`

	f(I) = I[1] - I[2]
	matrixFromFunction([3,3], f)
	g(I) = I[1] - I[2] == 1 ? 4 : 0
	matrixFromFunction([100, 100], "sparse", g)
	matrixFromFunction([5], random)

Also see: [matrix](#matrix), [matrixFromRows](#matrixfromrows), [matrixFromColumns](#matrixfromcolumns), [zeros](#zeros)

#### matrixFromRows
Create a dense matrix from vectors as individual rows.

Syntax: `matrixFromRows(...arr)` `matrixFromRows(row1, row2)` `matrixFromRows(row1, row2, row3)`

	matrixFromRows([1, 2, 3], [[4],[5],[6]])

Also see: [matrix](#matrix), [matrixFromColumns](#matrixfromcolumns), [matrixFromFunction](#matrixfromfunction), [zeros](#zeros)

#### ones
Create a matrix containing ones.

Syntax: `ones(m)` `ones(m, n)` `ones(m, n, p, ...)` `ones([m])` `ones([m, n])` `ones([m, n, p, ...])`

	ones(3)
	ones(3, 5)
	ones([2,3]) * 4.5
	a = [1, 2, 3; 4, 5, 6]
	ones(size(a))

Also see: [concat](#concat), [det](#det), [diag](#diag), [identity](#identity), [inv](#inv), [range](#range), [size](#size), [squeeze](#squeeze), [subset](#subset), [trace](#trace), [transpose](#transpose), [zeros](#zeros)

#### partitionSelect
Partition-based selection of an array or 1D matrix. Will find the kth smallest value, and mutates the input array. Uses Quickselect.

Syntax: `partitionSelect(x, k)` `partitionSelect(x, k, compare)`

	partitionSelect([5, 10, 1], 2)
	partitionSelect(["C", "B", "A", "D"], 1, compareText)
	arr = [5, 2, 1]
	partitionSelect(arr, 0) # returns 1, arr is now: [1, 2, 5]
	arr
	partitionSelect(arr, 1, 'desc') # returns 2, arr is now: [5, 2, 1]
	arr

Also see: [sort](#sort)

#### pinv
Calculate the Moore–Penrose inverse of a matrix

Syntax: `pinv(x)`

	pinv([1, 2; 3, 4])
	pinv([[1, 0], [0, 1], [0, 1]])
	pinv(4)

Also see: [inv](#inv)

#### reshape
Reshape a multi dimensional array to fit the specified dimensions.

Syntax: `reshape(x, sizes)`

	reshape([1, 2, 3, 4, 5, 6], [2, 3])
	reshape([[1, 2], [3, 4]], [1, 4])
	reshape([[1, 2], [3, 4]], [4])
	reshape([1, 2, 3, 4], [-1, 2])

Also see: [size](#size), [squeeze](#squeeze), [resize](#resize)

#### resize
Resize a matrix.

Syntax: `resize(x, size)` `resize(x, size, defaultValue)`

	resize([1,2,3,4,5], [3])
	resize([1,2,3], [5])
	resize([1,2,3], [5], -1)
	resize(2, [2, 3])
	resize("hello", [8], "!")

Also see: [size](#size), [subset](#subset), [squeeze](#squeeze), [reshape](#reshape)

#### rotate
Returns a 2-D rotation matrix (2x2) for a given angle (in radians). Returns a 2-D rotation matrix (3x3) of a given angle (in radians) around given axis.

Syntax: `rotate(w, theta)` `rotate(w, theta, v)`

	rotate([1, 0], pi / 2)
	rotate(matrix([1, 0]), unit("35deg"))
	rotate([1, 0, 0], unit("90deg"), [0, 0, 1])
	rotate(matrix([1, 0, 0]), unit("90deg"), matrix([0, 0, 1]))

Also see: [matrix](#matrix), [rotationMatrix](#rotationmatrix)

#### rotationMatrix
Returns a 2-D rotation matrix (2x2) for a given angle (in radians). Returns a 2-D rotation matrix (3x3) of a given angle (in radians) around given axis.

Syntax: `rotationMatrix(theta)` `rotationMatrix(theta, v)` `rotationMatrix(theta, v, format)`

	rotationMatrix(pi / 2)
	rotationMatrix(unit("45deg"), [0, 0, 1])
	rotationMatrix(1, matrix([0, 0, 1]), "sparse")

Also see: [cos](#cos), [sin](#sin)

#### row
Return a row from a matrix or array.

Syntax: `row(x, index)`

	A = [[1, 2], [3, 4]]
	row(A, 1)
	row(A, 2)

Also see: [column](#column), [matrixFromRows](#matrixfromrows)

#### size
Calculate the size of a matrix.

Syntax: `size(x)`

	size(2.3)
	size("hello world")
	a = [1, 2; 3, 4; 5, 6]
	size(a)
	size(1:6)

Also see: [concat](#concat), [count](#count), [det](#det), [diag](#diag), [identity](#identity), [inv](#inv), [ones](#ones), [range](#range), [squeeze](#squeeze), [subset](#subset), [trace](#trace), [transpose](#transpose), [zeros](#zeros)

#### sort
Sort the items in a matrix. Compare can be a string "asc", "desc", "natural", or a custom sort function.

Syntax: `sort(x)` `sort(x, compare)`

	sort([5, 10, 1])
	sort(["C", "B", "A", "D"], "natural")
	sortByLength(a, b) = size(a)[1] - size(b)[1]
	sort(["Langdon", "Tom", "Sara"], sortByLength)
	sort(["10", "1", "2"], "natural")

Also see: [map](#map), [filter](#filter), [forEach](#foreach)

#### squeeze
Remove inner and outer singleton dimensions from a matrix.

Syntax: `squeeze(x)`

	a = zeros(3,2,1)
	size(squeeze(a))
	b = zeros(1,1,3)
	size(squeeze(b))

Also see: [concat](#concat), [det](#det), [diag](#diag), [identity](#identity), [inv](#inv), [ones](#ones), [range](#range), [size](#size), [subset](#subset), [trace](#trace), [transpose](#transpose), [zeros](#zeros)

#### subset
Get or set a subset of the entries of a matrix or characters of a string. Indexes are one-based. There should be one index specification for each dimension of the target. Each specification can be a single index, a list of indices, or a range in colon notation `l:u`. In a range, both the lower bound l and upper bound u are included; and if a bound is omitted it defaults to the most extreme valid value. The cartesian product of the indices specified in each dimension determines the target of the operation.

Syntax: `value(index)` `value(index) = replacement` `subset(value, [index])` `subset(value, [index], replacement)`

	d = [1, 2; 3, 4]
	e = []
	e[1, 1:2] = [5, 6]
	e[2, :] = [7, 8]
	f = d * e
	f[2, 1]
	f[:, 1]
	f[[1,2], [1,3]] = [9, 10; 11, 12]
	f

Also see: [concat](#concat), [det](#det), [diag](#diag), [identity](#identity), [inv](#inv), [ones](#ones), [range](#range), [size](#size), [squeeze](#squeeze), [trace](#trace), [transpose](#transpose), [zeros](#zeros)

#### trace
Calculate the trace of a matrix: the sum of the elements on the main diagonal of a square matrix.

Syntax: `trace(A)`

	A = [1, 2, 3; -1, 2, 3; 2, 0, 3]
	trace(A)

Also see: [concat](#concat), [det](#det), [diag](#diag), [identity](#identity), [inv](#inv), [ones](#ones), [range](#range), [size](#size), [squeeze](#squeeze), [subset](#subset), [transpose](#transpose), [zeros](#zeros)

#### transpose
Transpose a matrix

Syntax: `x'` `transpose(x)`

	a = [1, 2, 3; 4, 5, 6]
	a'
	transpose(a)

Also see: [concat](#concat), [det](#det), [diag](#diag), [identity](#identity), [inv](#inv), [ones](#ones), [range](#range), [size](#size), [squeeze](#squeeze), [subset](#subset), [trace](#trace), [zeros](#zeros)

#### zeros
Create a matrix containing zeros.

Syntax: `zeros(m)` `zeros(m, n)` `zeros(m, n, p, ...)` `zeros([m])` `zeros([m, n])` `zeros([m, n, p, ...])`

	zeros(3)
	zeros(3, 5)
	a = [1, 2, 3; 4, 5, 6]
	zeros(size(a))

Also see: [concat](#concat), [det](#det), [diag](#diag), [identity](#identity), [inv](#inv), [ones](#ones), [range](#range), [size](#size), [squeeze](#squeeze), [subset](#subset), [trace](#trace), [transpose](#transpose)
### Numeric
#### solveODE
Numerical Integration of Ordinary Differential Equations.

Syntax: `solveODE(func, tspan, y0)` `solveODE(func, tspan, y0, options)`

	f(t,y) = y
	tspan = [0, 4]
	solveODE(f, tspan, 1)
	solveODE(f, tspan, [1, 2])
	solveODE(f, tspan, 1, { method:"RK23", maxStep:0.1 })

Also see: [derivative](#derivative), [simplifyCore](#simplifycore)
### Operators
#### add
Add two values.

Syntax: `x + y` `add(x, y)`

	a = 2.1 + 3.6
	a - 3.6
	3 + 2i
	3 cm + 2 inch
	"2.3" + "4"

Also see: [subtract](#subtract)

#### divide
Divide two values.

Syntax: `x / y` `divide(x, y)`

	a = 2 / 3
	a * 3
	4.5 / 2
	3 + 4 / 2
	(3 + 4) / 2
	18 km / 4.5

Also see: [multiply](#multiply)

#### dotDivide
Divide two values element wise.

Syntax: `x ./ y` `dotDivide(x, y)`

	a = [1, 2, 3; 4, 5, 6]
	b = [2, 1, 1; 3, 2, 5]
	a ./ b

Also see: [multiply](#multiply), [dotMultiply](#dotmultiply), [divide](#divide)

#### dotMultiply
Multiply two values element wise.

Syntax: `x .* y` `dotMultiply(x, y)`

	a = [1, 2, 3; 4, 5, 6]
	b = [2, 1, 1; 3, 2, 5]
	a .* b

Also see: [multiply](#multiply), [divide](#divide), [dotDivide](#dotdivide)

#### dotPow
Calculates the power of x to y element wise.

Syntax: `x .^ y` `dotPow(x, y)`

	a = [1, 2, 3; 4, 5, 6]
	a .^ 2

Also see: [pow](#pow)

#### mod
Calculates the modulus, the remainder of an integer division.

Syntax: `x % y` `x mod y` `mod(x, y)`

	7 % 3
	11 % 2
	10 mod 4
	isOdd(x) = x % 2
	isOdd(2)
	isOdd(3)

Also see: [divide](#divide)

#### multiply
multiply two values.

Syntax: `x * y` `multiply(x, y)`

	a = 2.1 * 3.4
	a / 3.4
	2 * 3 + 4
	2 * (3 + 4)
	3 * 2.1 km

Also see: [divide](#divide)

#### pow
Calculates the power of x to y, x^y.

Syntax: `x ^ y` `pow(x, y)`

	2^3
	2*2*2
	1 + e ^ (pi * i)
	pow([[1, 2], [4, 3]], 2)
	pow([[1, 2], [4, 3]], -1)

Also see: [multiply](#multiply), [nthRoot](#nthroot), [nthRoots](#nthroots), [sqrt](#sqrt)

#### subtract
subtract two values.

Syntax: `x - y` `subtract(x, y)`

	a = 5.3 - 2
	a + 2
	2/3 - 1/6
	2 * 3 - 3
	2.1 km - 500m

Also see: [add](#add)

#### unaryMinus
Inverse the sign of a value. Converts booleans and strings to numbers.

Syntax: `-x` `unaryMinus(x)`

	-4.5
	-(-5.6)
	-"22"

Also see: [add](#add), [subtract](#subtract), [unaryPlus](#unaryplus)

#### unaryPlus
Converts booleans and strings to numbers.

Syntax: `+x` `unaryPlus(x)`

	+true
	+"2"

Also see: [add](#add), [subtract](#subtract), [unaryMinus](#unaryminus)
### Probability
#### bernoulli
The nth Bernoulli number

Syntax: `bernoulli(n)`

	bernoulli(4)
	bernoulli(fraction(12))

Also see: [combinations](#combinations), [gamma](#gamma), [stirlingS2](#stirlings2)

#### combinations
Compute the number of combinations of n items taken k at a time

Syntax: `combinations(n, k)`

	combinations(7, 5)

Also see: [combinationsWithRep](#combinationswithrep), [permutations](#permutations), [factorial](#factorial)

#### combinationsWithRep
Compute the number of combinations of n items taken k at a time with replacements.

Syntax: `combinationsWithRep(n, k)`

	combinationsWithRep(7, 5)

Also see: [combinations](#combinations), [permutations](#permutations), [factorial](#factorial)

#### factorial
Compute the factorial of a value

Syntax: `n!` `factorial(n)`

	5!
	5 * 4 * 3 * 2 * 1
	3!

Also see: [combinations](#combinations), [combinationsWithRep](#combinationswithrep), [permutations](#permutations), [gamma](#gamma)

#### gamma
Compute the gamma function. For small values, the Lanczos approximation is used, and for large values the extended Stirling approximation.

Syntax: `gamma(n)`

	gamma(4)
	3!
	gamma(1/2)
	sqrt(pi)

Also see: [factorial](#factorial)

#### kldivergence
Calculate the Kullback-Leibler (KL) divergence  between two distributions.

Syntax: `kldivergence(x, y)`

	kldivergence([0.7,0.5,0.4], [0.2,0.9,0.5])



#### lgamma
Logarithm of the gamma function for real, positive numbers and complex numbers, using Lanczos approximation for numbers and Stirling series for complex numbers.

Syntax: `lgamma(n)`

	lgamma(4)
	lgamma(1/2)
	lgamma(i)
	lgamma(complex(1.1, 2))

Also see: [gamma](#gamma)

#### multinomial
Multinomial Coefficients compute the number of ways of picking a1, a2, ..., ai unordered outcomes from `n` possibilities. multinomial takes one array of integers as an argument. The following condition must be enforced: every ai > 0.

Syntax: `multinomial(A)`

	multinomial([1, 2, 1])

Also see: [combinations](#combinations), [factorial](#factorial)

#### permutations
Compute the number of permutations of n items taken k at a time

Syntax: `permutations(n)` `permutations(n, k)`

	permutations(5)
	permutations(5, 3)

Also see: [combinations](#combinations), [combinationsWithRep](#combinationswithrep), [factorial](#factorial)

#### pickRandom
Pick a random entry from a given array.

Syntax: `pickRandom(array)` `pickRandom(array, number)` `pickRandom(array, weights)` `pickRandom(array, number, weights)` `pickRandom(array, weights, number)`

	pickRandom(0:10)
	pickRandom([1, 3, 1, 6])
	pickRandom([1, 3, 1, 6], 2)
	pickRandom([1, 3, 1, 6], [2, 3, 2, 1])
	pickRandom([1, 3, 1, 6], 2, [2, 3, 2, 1])
	pickRandom([1, 3, 1, 6], [2, 3, 2, 1], 2)

Also see: [random](#random), [randomInt](#randomint)

#### random
Return a random number.

Syntax: `random()` `random(max)` `random(min, max)` `random(size)` `random(size, max)` `random(size, min, max)`

	random()
	random(10, 20)
	random([2, 3])

Also see: [pickRandom](#pickrandom), [randomInt](#randomint)

#### randomInt
Return a random integer number

Syntax: `randomInt(max)` `randomInt(min, max)` `randomInt(size)` `randomInt(size, max)` `randomInt(size, min, max)`

	randomInt(10, 20)
	randomInt([2, 3], 10)

Also see: [pickRandom](#pickrandom), [random](#random)
### Relational
#### compare
Compare two values. Returns 1 when x > y, -1 when x < y, and 0 when x == y.

Syntax: `compare(x, y)`

	compare(2, 3)
	compare(3, 2)
	compare(2, 2)
	compare(5cm, 40mm)
	compare(2, [1, 2, 3])

Also see: [equal](#equal), [unequal](#unequal), [smaller](#smaller), [smallerEq](#smallereq), [largerEq](#largereq), [compareNatural](#comparenatural), [compareText](#comparetext)

#### compareNatural
Compare two values of any type in a deterministic, natural way. Returns 1 when x > y, -1 when x < y, and 0 when x == y.

Syntax: `compareNatural(x, y)`

	compareNatural(2, 3)
	compareNatural(3, 2)
	compareNatural(2, 2)
	compareNatural(5cm, 40mm)
	compareNatural("2", "10")
	compareNatural(2 + 3i, 2 + 4i)
	compareNatural([1, 2, 4], [1, 2, 3])
	compareNatural([1, 5], [1, 2, 3])
	compareNatural([1, 2], [1, 2])
	compareNatural({a: 2}, {a: 4})

Also see: [equal](#equal), [unequal](#unequal), [smaller](#smaller), [smallerEq](#smallereq), [largerEq](#largereq), [compare](#compare), [compareText](#comparetext)

#### compareText
Compare two strings lexically. Comparison is case sensitive. Returns 1 when x > y, -1 when x < y, and 0 when x == y.

Syntax: `compareText(x, y)`

	compareText("B", "A")
	compareText("A", "B")
	compareText("A", "A")
	compareText("2", "10")
	compare("2", "10")
	compare(2, 10)
	compareNatural("2", "10")
	compareText("B", ["A", "B", "C"])

Also see: [compare](#compare), [compareNatural](#comparenatural)

#### deepEqual
Check equality of two matrices element wise. Returns true if the size of both matrices is equal and when and each of the elements are equal.

Syntax: `deepEqual(x, y)`

	deepEqual([1,3,4], [1,3,4])
	deepEqual([1,3,4], [1,3])

Also see: [equal](#equal), [unequal](#unequal), [smaller](#smaller), [larger](#larger), [smallerEq](#smallereq), [largerEq](#largereq), [compare](#compare)

#### equal
Check equality of two values. Returns true if the values are equal, and false if not.

Syntax: `x == y` `equal(x, y)`

	2+2 == 3
	2+2 == 4
	a = 3.2
	b = 6-2.8
	a == b
	50cm == 0.5m

Also see: [unequal](#unequal), [smaller](#smaller), [larger](#larger), [smallerEq](#smallereq), [largerEq](#largereq), [compare](#compare), [deepEqual](#deepequal), [equalText](#equaltext)

#### equalText
Check equality of two strings. Comparison is case sensitive. Returns true if the values are equal, and false if not.

Syntax: `equalText(x, y)`

	equalText("Hello", "Hello")
	equalText("a", "A")
	equal("2e3", "2000")
	equalText("2e3", "2000")
	equalText("B", ["A", "B", "C"])

Also see: [compare](#compare), [compareNatural](#comparenatural), [compareText](#comparetext), [equal](#equal)

#### larger
Check if value x is larger than y. Returns true if x is larger than y, and false if not. Comparing a value with NaN returns false.

Syntax: `x > y` `larger(x, y)`

	2 > 3
	5 > 2*2
	a = 3.3
	b = 6-2.8
	(a > b)
	(b < a)
	5 cm > 2 inch

Also see: [equal](#equal), [unequal](#unequal), [smaller](#smaller), [smallerEq](#smallereq), [largerEq](#largereq), [compare](#compare)

#### largerEq
Check if value x is larger or equal to y. Returns true if x is larger or equal to y, and false if not.

Syntax: `x >= y` `largerEq(x, y)`

	2 >= 1+1
	2 > 1+1
	a = 3.2
	b = 6-2.8
	(a >= b)

Also see: [equal](#equal), [unequal](#unequal), [smallerEq](#smallereq), [smaller](#smaller), [compare](#compare)

#### smaller
Check if value x is smaller than value y. Returns true if x is smaller than y, and false if not. Comparing a value with NaN returns false.

Syntax: `x < y` `smaller(x, y)`

	2 < 3
	5 < 2*2
	a = 3.3
	b = 6-2.8
	(a < b)
	5 cm < 2 inch

Also see: [equal](#equal), [unequal](#unequal), [larger](#larger), [smallerEq](#smallereq), [largerEq](#largereq), [compare](#compare)

#### smallerEq
Check if value x is smaller or equal to value y. Returns true if x is smaller than y, and false if not.

Syntax: `x <= y` `smallerEq(x, y)`

	2 <= 1+1
	2 < 1+1
	a = 3.2
	b = 6-2.8
	(a <= b)

Also see: [equal](#equal), [unequal](#unequal), [larger](#larger), [smaller](#smaller), [largerEq](#largereq), [compare](#compare)

#### unequal
Check unequality of two values. Returns true if the values are unequal, and false if they are equal.

Syntax: `x != y` `unequal(x, y)`

	2+2 != 3
	2+2 != 4
	a = 3.2
	b = 6-2.8
	a != b
	50cm != 0.5m
	5 cm != 2 inch

Also see: [equal](#equal), [smaller](#smaller), [larger](#larger), [smallerEq](#smallereq), [largerEq](#largereq), [compare](#compare), [deepEqual](#deepequal)
### Set
#### setCartesian
Create the cartesian product of two (multi)sets. Multi-dimension arrays will be converted to single-dimension arrays and the values will be sorted in ascending order before the operation.

Syntax: `setCartesian(set1, set2)`

	setCartesian([1, 2], [3, 4])

Also see: [setUnion](#setunion), [setIntersect](#setintersect), [setDifference](#setdifference), [setPowerset](#setpowerset)

#### setDifference
Create the difference of two (multi)sets: every element of set1, that is not the element of set2. Multi-dimension arrays will be converted to single-dimension arrays before the operation.

Syntax: `setDifference(set1, set2)`

	setDifference([1, 2, 3, 4], [3, 4, 5, 6])
	setDifference([[1, 2], [3, 4]], [[3, 4], [5, 6]])

Also see: [setUnion](#setunion), [setIntersect](#setintersect), [setSymDifference](#setsymdifference)

#### setDistinct
Collect the distinct elements of a multiset. A multi-dimension array will be converted to a single-dimension array before the operation.

Syntax: `setDistinct(set)`

	setDistinct([1, 1, 1, 2, 2, 3])

Also see: [setMultiplicity](#setmultiplicity)

#### setIntersect
Create the intersection of two (multi)sets. Multi-dimension arrays will be converted to single-dimension arrays before the operation.

Syntax: `setIntersect(set1, set2)`

	setIntersect([1, 2, 3, 4], [3, 4, 5, 6])
	setIntersect([[1, 2], [3, 4]], [[3, 4], [5, 6]])

Also see: [setUnion](#setunion), [setDifference](#setdifference)

#### setIsSubset
Check whether a (multi)set is a subset of another (multi)set: every element of set1 is the element of set2. Multi-dimension arrays will be converted to single-dimension arrays before the operation.

Syntax: `setIsSubset(set1, set2)`

	setIsSubset([1, 2], [3, 4, 5, 6])
	setIsSubset([3, 4], [3, 4, 5, 6])

Also see: [setUnion](#setunion), [setIntersect](#setintersect), [setDifference](#setdifference)

#### setMultiplicity
Count the multiplicity of an element in a multiset. A multi-dimension array will be converted to a single-dimension array before the operation.

Syntax: `setMultiplicity(element, set)`

	setMultiplicity(1, [1, 2, 2, 4])
	setMultiplicity(2, [1, 2, 2, 4])

Also see: [setDistinct](#setdistinct), [setSize](#setsize)

#### setPowerset
Create the powerset of a (multi)set: the powerset contains very possible subsets of a (multi)set. A multi-dimension array will be converted to a single-dimension array before the operation.

Syntax: `setPowerset(set)`

	setPowerset([1, 2, 3])

Also see: [setCartesian](#setcartesian)

#### setSize
Count the number of elements of a (multi)set. When the second parameter "unique" is true, count only the unique values. A multi-dimension array will be converted to a single-dimension array before the operation.

Syntax: `setSize(set)` `setSize(set, unique)`

	setSize([1, 2, 2, 4])
	setSize([1, 2, 2, 4], true)

Also see: [setUnion](#setunion), [setIntersect](#setintersect), [setDifference](#setdifference)

#### setSymDifference
Create the symmetric difference of two (multi)sets. Multi-dimension arrays will be converted to single-dimension arrays before the operation.

Syntax: `setSymDifference(set1, set2)`

	setSymDifference([1, 2, 3, 4], [3, 4, 5, 6])
	setSymDifference([[1, 2], [3, 4]], [[3, 4], [5, 6]])

Also see: [setUnion](#setunion), [setIntersect](#setintersect), [setDifference](#setdifference)

#### setUnion
Create the union of two (multi)sets. Multi-dimension arrays will be converted to single-dimension arrays before the operation.

Syntax: `setUnion(set1, set2)`

	setUnion([1, 2, 3, 4], [3, 4, 5, 6])
	setUnion([[1, 2], [3, 4]], [[3, 4], [5, 6]])

Also see: [setIntersect](#setintersect), [setDifference](#setdifference)
### Signal
#### freqz
Calculates the frequency response of a filter given its numerator and denominator coefficients.

Syntax: `freqz(b, a)` `freqz(b, a, w)`

	freqz([1, 2], [1, 2, 3])
	freqz([1, 2], [1, 2, 3], [0, 1])
	freqz([1, 2], [1, 2, 3], 512)



#### zpk2tf
Compute the transfer function of a zero-pole-gain model.

Syntax: `zpk2tf(z, p, k)`

	zpk2tf([1, 2], [-1, -2], 1)
	zpk2tf([1, 2], [-1, -2])
	zpk2tf([1 - 3i, 2 + 2i], [-1, -2])


### Special
#### erf
Compute the erf function of a value using a rational Chebyshev approximations for different intervals of x

Syntax: `erf(x)`

	erf(0.2)
	erf(-0.5)
	erf(4)



#### zeta
Compute the Riemann Zeta Function using an infinite series and Riemann's Functional Equation for the entire complex plane

Syntax: `zeta(s)`

	zeta(0.2)
	zeta(-0.5)
	zeta(4)


### Statistics
#### corr
Compute the correlation coefficient of a two list with values, For matrices, the matrix correlation coefficient is calculated.

Syntax: `corr(A,B)`

	corr([2, 4, 6, 8],[1, 2, 3, 6])
	corr(matrix([[1, 2.2, 3, 4.8, 5], [1, 2, 3, 4, 5]]), matrix([[4, 5.3, 6.6, 7, 8], [1, 2, 3, 4, 5]]))

Also see: [max](#max), [mean](#mean), [min](#min), [median](#median), [min](#min), [prod](#prod), [std](#std), [sum](#sum)

#### cumsum
Compute the cumulative sum of all values.

Syntax: `cumsum(a, b, c, ...)` `cumsum(A)`

	cumsum(2, 3, 4, 1)
	cumsum([2, 3, 4, 1])
	cumsum([1, 2; 3, 4])
	cumsum([1, 2; 3, 4], 1)
	cumsum([1, 2; 3, 4], 2)

Also see: [max](#max), [mean](#mean), [median](#median), [min](#min), [prod](#prod), [std](#std), [sum](#sum), [variance](#variance)

#### mad
Compute the median absolute deviation of a matrix or a list with values. The median absolute deviation is defined as the median of the absolute deviations from the median.

Syntax: `mad(a, b, c, ...)` `mad(A)`

	mad(10, 20, 30)
	mad([1, 2, 3])

Also see: [mean](#mean), [median](#median), [std](#std), [abs](#abs)

#### max
Compute the maximum value of a list of values. If any NaN values are found, the function yields the last NaN in the input.

Syntax: `max(a, b, c, ...)` `max(A)` `max(A, dimension)`

	max(2, 3, 4, 1)
	max([2, 3, 4, 1])
	max([2, 5; 4, 3])
	max([2, 5; 4, 3], 1)
	max([2, 5; 4, 3], 2)
	max(2.7, 7.1, -4.5, 2.0, 4.1)
	min(2.7, 7.1, -4.5, 2.0, 4.1)

Also see: [mean](#mean), [median](#median), [min](#min), [prod](#prod), [std](#std), [sum](#sum), [variance](#variance)

#### mean
Compute the arithmetic mean of a list of values.

Syntax: `mean(a, b, c, ...)` `mean(A)` `mean(A, dimension)`

	mean(2, 3, 4, 1)
	mean([2, 3, 4, 1])
	mean([2, 5; 4, 3])
	mean([2, 5; 4, 3], 1)
	mean([2, 5; 4, 3], 2)
	mean([1.0, 2.7, 3.2, 4.0])

Also see: [max](#max), [median](#median), [min](#min), [prod](#prod), [std](#std), [sum](#sum), [variance](#variance)

#### median
Compute the median of all values. The values are sorted and the middle value is returned. In case of an even number of values, the average of the two middle values is returned.

Syntax: `median(a, b, c, ...)` `median(A)`

	median(5, 2, 7)
	median([3, -1, 5, 7])

Also see: [max](#max), [mean](#mean), [min](#min), [prod](#prod), [std](#std), [sum](#sum), [variance](#variance), [quantileSeq](#quantileseq)

#### min
Compute the minimum value of a list of values. If any NaN values are found, the function yields the last NaN in the input.

Syntax: `min(a, b, c, ...)` `min(A)` `min(A, dimension)`

	min(2, 3, 4, 1)
	min([2, 3, 4, 1])
	min([2, 5; 4, 3])
	min([2, 5; 4, 3], 1)
	min([2, 5; 4, 3], 2)
	min(2.7, 7.1, -4.5, 2.0, 4.1)
	max(2.7, 7.1, -4.5, 2.0, 4.1)

Also see: [max](#max), [mean](#mean), [median](#median), [prod](#prod), [std](#std), [sum](#sum), [variance](#variance)

#### mode
Computes the mode of all values as an array. In case mode being more than one, multiple values are returned in an array.

Syntax: `mode(a, b, c, ...)` `mode(A)` `mode(A, a, b, B, c, ...)`

	mode(2, 1, 4, 3, 1)
	mode([1, 2.7, 3.2, 4, 2.7])
	mode(1, 4, 6, 1, 6)

Also see: [max](#max), [mean](#mean), [min](#min), [median](#median), [prod](#prod), [std](#std), [sum](#sum), [variance](#variance)

#### prod
Compute the product of all values.

Syntax: `prod(a, b, c, ...)` `prod(A)`

	prod(2, 3, 4)
	prod([2, 3, 4])
	prod([2, 5; 4, 3])

Also see: [max](#max), [mean](#mean), [min](#min), [median](#median), [min](#min), [std](#std), [sum](#sum), [variance](#variance)

#### quantileSeq
Compute the prob order quantile of a matrix or a list with values. The sequence is sorted and the middle value is returned. Supported types of sequence values are: Number, BigNumber, Unit Supported types of probability are: Number, BigNumber. 

In case of a (multi dimensional) array or matrix, the prob order quantile of all elements will be calculated.

Syntax: `quantileSeq(A, prob[, sorted])` `quantileSeq(A, [prob1, prob2, ...][, sorted])` `quantileSeq(A, N[, sorted])`

	quantileSeq([3, -1, 5, 7], 0.5)
	quantileSeq([3, -1, 5, 7], [1/3, 2/3])
	quantileSeq([3, -1, 5, 7], 2)
	quantileSeq([-1, 3, 5, 7], 0.5, true)

Also see: [mean](#mean), [median](#median), [min](#min), [max](#max), [prod](#prod), [std](#std), [sum](#sum), [variance](#variance)

#### std
Compute the standard deviation of all values, defined as std(A) = sqrt(variance(A)). Optional parameter normalization can be "unbiased" (default), "uncorrected", or "biased".

Syntax: `std(a, b, c, ...)` `std(A)` `std(A, dimension)` `std(A, normalization)` `std(A, dimension, normalization)`

	std(2, 4, 6)
	std([2, 4, 6, 8])
	std([2, 4, 6, 8], "uncorrected")
	std([2, 4, 6, 8], "biased")
	std([1, 2, 3; 4, 5, 6])

Also see: [max](#max), [mean](#mean), [min](#min), [median](#median), [prod](#prod), [sum](#sum), [variance](#variance)

#### sum
Compute the sum of all values.

Syntax: `sum(a, b, c, ...)` `sum(A)` `sum(A, dimension)`

	sum(2, 3, 4, 1)
	sum([2, 3, 4, 1])
	sum([2, 5; 4, 3])

Also see: [max](#max), [mean](#mean), [median](#median), [min](#min), [prod](#prod), [std](#std), [variance](#variance)

#### variance
Compute the variance of all values. Optional parameter normalization can be "unbiased" (default), "uncorrected", or "biased".

Syntax: `variance(a, b, c, ...)` `variance(A)` `variance(A, dimension)` `variance(A, normalization)` `variance(A, dimension, normalization)`

	variance(2, 4, 6)
	variance([2, 4, 6, 8])
	variance([2, 4, 6, 8], "uncorrected")
	variance([2, 4, 6, 8], "biased")
	variance([1, 2, 3; 4, 5, 6])

Also see: [max](#max), [mean](#mean), [min](#min), [median](#median), [min](#min), [prod](#prod), [std](#std), [sum](#sum)
### Trigonometry
#### acos
Compute the inverse cosine of a value in radians.

Syntax: `acos(x)`

	acos(0.5)
	acos(cos(2.3))

Also see: [cos](#cos), [atan](#atan), [asin](#asin)

#### acosh
Calculate the hyperbolic arccos of a value, defined as `acosh(x) = ln(sqrt(x^2 - 1) + x)`.

Syntax: `acosh(x)`

	acosh(1.5)

Also see: [cosh](#cosh), [asinh](#asinh), [atanh](#atanh)

#### acot
Calculate the inverse cotangent of a value.

Syntax: `acot(x)`

	acot(0.5)
	acot(cot(0.5))
	acot(2)

Also see: [cot](#cot), [atan](#atan)

#### acoth
Calculate the inverse hyperbolic tangent of a value, defined as `acoth(x) = (ln((x+1)/x) + ln(x/(x-1))) / 2`.

Syntax: `acoth(x)`

	acoth(2)
	acoth(0.5)

Also see: [acsch](#acsch), [asech](#asech)

#### acsc
Calculate the inverse cotangent of a value.

Syntax: `acsc(x)`

	acsc(2)
	acsc(csc(0.5))
	acsc(0.5)

Also see: [csc](#csc), [asin](#asin), [asec](#asec)

#### acsch
Calculate the inverse hyperbolic cosecant of a value, defined as `acsch(x) = ln(1/x + sqrt(1/x^2 + 1))`.

Syntax: `acsch(x)`

	acsch(0.5)

Also see: [asech](#asech), [acoth](#acoth)

#### asec
Calculate the inverse secant of a value.

Syntax: `asec(x)`

	asec(0.5)
	asec(sec(0.5))
	asec(2)

Also see: [acos](#acos), [acot](#acot), [acsc](#acsc)

#### asech
Calculate the inverse secant of a value.

Syntax: `asech(x)`

	asech(0.5)

Also see: [acsch](#acsch), [acoth](#acoth)

#### asin
Compute the inverse sine of a value in radians.

Syntax: `asin(x)`

	asin(0.5)
	asin(sin(0.5))

Also see: [sin](#sin), [acos](#acos), [atan](#atan)

#### asinh
Calculate the hyperbolic arcsine of a value, defined as `asinh(x) = ln(x + sqrt(x^2 + 1))`.

Syntax: `asinh(x)`

	asinh(0.5)

Also see: [acosh](#acosh), [atanh](#atanh)

#### atan
Compute the inverse tangent of a value in radians.

Syntax: `atan(x)`

	atan(0.5)
	atan(tan(0.5))

Also see: [tan](#tan), [acos](#acos), [asin](#asin)

#### atan2
Computes the principal value of the arc tangent of y/x in radians.

Syntax: `atan2(y, x)`

	atan2(2, 2) / pi
	angle = 60 deg in rad
	x = cos(angle)
	y = sin(angle)
	atan2(y, x)

Also see: [sin](#sin), [cos](#cos), [tan](#tan)

#### atanh
Calculate the hyperbolic arctangent of a value, defined as `atanh(x) = ln((1 + x)/(1 - x)) / 2`.

Syntax: `atanh(x)`

	atanh(0.5)

Also see: [acosh](#acosh), [asinh](#asinh)

#### cos
Compute the cosine of x in radians.

Syntax: `cos(x)`

	cos(2)
	cos(pi / 4) ^ 2
	cos(180 deg)
	cos(60 deg)
	sin(0.2)^2 + cos(0.2)^2

Also see: [acos](#acos), [sin](#sin), [tan](#tan)

#### cosh
Compute the hyperbolic cosine of x in radians.

Syntax: `cosh(x)`

	cosh(0.5)

Also see: [sinh](#sinh), [tanh](#tanh), [coth](#coth)

#### cot
Compute the cotangent of x in radians. Defined as 1/tan(x)

Syntax: `cot(x)`

	cot(2)
	1 / tan(2)

Also see: [sec](#sec), [csc](#csc), [tan](#tan)

#### coth
Compute the hyperbolic cotangent of x in radians.

Syntax: `coth(x)`

	coth(2)
	1 / tanh(2)

Also see: [sech](#sech), [csch](#csch), [tanh](#tanh)

#### csc
Compute the cosecant of x in radians. Defined as 1/sin(x)

Syntax: `csc(x)`

	csc(2)
	1 / sin(2)

Also see: [sec](#sec), [cot](#cot), [sin](#sin)

#### csch
Compute the hyperbolic cosecant of x in radians. Defined as 1/sinh(x)

Syntax: `csch(x)`

	csch(2)
	1 / sinh(2)

Also see: [sech](#sech), [coth](#coth), [sinh](#sinh)

#### sec
Compute the secant of x in radians. Defined as 1/cos(x)

Syntax: `sec(x)`

	sec(2)
	1 / cos(2)

Also see: [cot](#cot), [csc](#csc), [cos](#cos)

#### sech
Compute the hyperbolic secant of x in radians. Defined as 1/cosh(x)

Syntax: `sech(x)`

	sech(2)
	1 / cosh(2)

Also see: [coth](#coth), [csch](#csch), [cosh](#cosh)

#### sin
Compute the sine of x in radians.

Syntax: `sin(x)`

	sin(2)
	sin(pi / 4) ^ 2
	sin(90 deg)
	sin(30 deg)
	sin(0.2)^2 + cos(0.2)^2

Also see: [asin](#asin), [cos](#cos), [tan](#tan)

#### sinh
Compute the hyperbolic sine of x in radians.

Syntax: `sinh(x)`

	sinh(0.5)

Also see: [cosh](#cosh), [tanh](#tanh)

#### tan
Compute the tangent of x in radians.

Syntax: `tan(x)`

	tan(0.5)
	sin(0.5) / cos(0.5)
	tan(pi / 4)
	tan(45 deg)

Also see: [atan](#atan), [sin](#sin), [cos](#cos)

#### tanh
Compute the hyperbolic tangent of x in radians.

Syntax: `tanh(x)`

	tanh(0.5)
	sinh(0.5) / cosh(0.5)

Also see: [sinh](#sinh), [cosh](#cosh)
### Type
#### range
Create a range. Lower bound of the range is included, upper bound is excluded.

Syntax: `start:end` `start:step:end` `range(start, end)` `range(start, end, step)` `range(string)`

	1:5
	3:-1:-3
	range(3, 7)
	range(0, 12, 2)
	range("4:10")
	range(1m, 1m, 3m)
	a = [1, 2, 3, 4; 5, 6, 7, 8]
	a[1:2, 1:2]

Also see: [concat](#concat), [det](#det), [diag](#diag), [identity](#identity), [inv](#inv), [ones](#ones), [size](#size), [squeeze](#squeeze), [subset](#subset), [trace](#trace), [transpose](#transpose), [zeros](#zeros)
### Units
#### to
Change the unit of a value.

Syntax: `x to unit` `to(x, unit)`

	5 inch to cm
	3.2kg to g
	16 bytes in bits



#### toBest
Converts to the most appropriate display unit.

Syntax: `toBest(x)` `toBest(x, unitList)` `toBest(x, unitList, options)`

	toBest(unit(5000, "m"))
	toBest(unit(3500000, "W"))
	toBest(unit(0.000000123, "A"))
	toBest(unit(10, "m"), "cm")
	toBest(unit(10, "m"), "mm,km", {offset: 1.5})


### Utils
#### bin
Format a number as binary

Syntax: `bin(value)`

	bin(2)

Also see: [oct](#oct), [hex](#hex)

#### clone
Clone a variable. Creates a copy of primitive variables, and a deep copy of matrices

Syntax: `clone(x)`

	clone(3.5)
	clone(2 - 4i)
	clone(45 deg)
	clone([1, 2; 3, 4])
	clone("hello world")



#### format
Format a value of any type as string.

Syntax: `format(value)` `format(value, precision)`

	format(2.3)
	format(3 - 4i)
	format([])
	format(pi, 3)

Also see: [print](#print)

#### hasNumericValue
Test whether a value is an numeric value. In case of a string, true is returned if the string contains a numeric value.

Syntax: `hasNumericValue(x)`

	hasNumericValue(2)
	hasNumericValue("2")
	isNumeric("2")
	hasNumericValue(0)
	hasNumericValue(bignumber(500))
	hasNumericValue(fraction(0.125))
	hasNumericValue(2 + 3i)
	hasNumericValue([2.3, "foo", false])

Also see: [isInteger](#isinteger), [isZero](#iszero), [isNegative](#isnegative), [isPositive](#ispositive), [isNaN](#isnan), [isNumeric](#isnumeric)

#### hex
Format a number as hexadecimal

Syntax: `hex(value)`

	hex(240)

Also see: [bin](#bin), [oct](#oct)

#### isBounded
Test whether a value or its entries are bounded.

Syntax: `isBounded(x)`

	isBounded(Infinity)
	isBounded(bigint(3))
	isBounded([3, -Infinity, -3])

Also see: [isFinite](#isfinite), [isNumeric](#isnumeric), [isNaN](#isnan), [isNegative](#isnegative), [isPositive](#ispositive)

#### isFinite
Test whether a value is finite, elementwise on collections.

Syntax: `isFinite(x)`

	isFinite(Infinity)
	isFinite(bigint(3))
	isFinite([3, -Infinity, -3])

Also see: [isBounded](#isbounded), [isNumeric](#isnumeric), [isNaN](#isnan), [isNegative](#isnegative), [isPositive](#ispositive)

#### isInteger
Test whether a value is an integer number.

Syntax: `isInteger(x)`

	isInteger(2)
	isInteger(3.5)
	isInteger([3, 0.5, -2])

Also see: [isNegative](#isnegative), [isNumeric](#isnumeric), [isPositive](#ispositive), [isZero](#iszero)

#### isNaN
Test whether a value is NaN (not a number)

Syntax: `isNaN(x)`

	isNaN(2)
	isNaN(0 / 0)
	isNaN(NaN)
	isNaN(Infinity)

Also see: [isNegative](#isnegative), [isNumeric](#isnumeric), [isPositive](#ispositive), [isZero](#iszero), [isFinite](#isfinite), [isBounded](#isbounded)

#### isNegative
Test whether a value is negative: smaller than zero.

Syntax: `isNegative(x)`

	isNegative(2)
	isNegative(0)
	isNegative(-4)
	isNegative([3, 0.5, -2])

Also see: [isInteger](#isinteger), [isNumeric](#isnumeric), [isPositive](#ispositive), [isZero](#iszero)

#### isNumeric
Test whether a value is a numeric value. Returns true when the input is a number, BigNumber, Fraction, or boolean.

Syntax: `isNumeric(x)`

	isNumeric(2)
	isNumeric("2")
	hasNumericValue("2")
	isNumeric(0)
	isNumeric(bignumber(500))
	isNumeric(fraction(0.125))
	isNumeric(2 + 3i)
	isNumeric([2.3, "foo", false])

Also see: [isInteger](#isinteger), [isZero](#iszero), [isNegative](#isnegative), [isPositive](#ispositive), [isNaN](#isnan), [hasNumericValue](#hasnumericvalue), [isFinite](#isfinite), [isBounded](#isbounded)

#### isPositive
Test whether a value is positive: larger than zero.

Syntax: `isPositive(x)`

	isPositive(2)
	isPositive(0)
	isPositive(-4)
	isPositive([3, 0.5, -2])

Also see: [isInteger](#isinteger), [isNumeric](#isnumeric), [isNegative](#isnegative), [isZero](#iszero)

#### isPrime
Test whether a value is prime: has no divisors other than itself and one.

Syntax: `isPrime(x)`

	isPrime(3)
	isPrime(-2)
	isPrime([2, 17, 100])

Also see: [isInteger](#isinteger), [isNumeric](#isnumeric), [isNegative](#isnegative), [isZero](#iszero)

#### isZero
Test whether a value is zero.

Syntax: `isZero(x)`

	isZero(2)
	isZero(0)
	isZero(-4)
	isZero([3, 0, -2, 0])

Also see: [isInteger](#isinteger), [isNumeric](#isnumeric), [isNegative](#isnegative), [isPositive](#ispositive)

#### numeric
Convert a numeric input to a specific numeric type: number, BigNumber, bigint, or Fraction.

Syntax: `numeric(x)`

	numeric("4")
	numeric("4", "number")
	numeric("4", "bigint")
	numeric("4", "BigNumber")
	numeric("4", "Fraction")
	numeric(4, "Fraction")
	numeric(fraction(2, 5), "number")

Also see: [number](#number), [bigint](#bigint), [fraction](#fraction), [bignumber](#bignumber), [string](#string), [format](#format)

#### oct
Format a number as octal

Syntax: `oct(value)`

	oct(56)

Also see: [bin](#bin), [hex](#hex)

#### print
Interpolate values into a string template.

Syntax: `print(template, values)` `print(template, values, precision)`

	print("Lucy is $age years old", {age: 5})
	print("The value of pi is $pi", {pi: pi}, 3)
	print("Hello, $user.name!", {user: {name: "John"}})
	print("Values: $1, $2, $3", [6, 9, 4])

Also see: [format](#format)

#### typeOf
Get the type of a variable.

Syntax: `typeOf(x)`

	typeOf(3.5)
	typeOf(2 - 4i)
	typeOf(45 deg)
	typeOf("hello world")

Also see: [getMatrixDataType](#getmatrixdatatype)

### Special constants
#### Atomic mass constant

	atomicMass

#### Avogadro's number

	avogadro

#### Bohr magneton

	bohrMagneton

#### Bohr radius

	bohrRadius

#### Boltzmann constant

	boltzmann

#### Classical electron radius

	classicalElectronRadius

#### Conductance quantum

	conductanceQuantum

#### Coulomb's constant. Deprecated in favor of coulombConstant

	coulombConstant

#### Coulomb's constant

	coulombConstant

#### Deuteron Mass

	deuteronMass

#### Efimov factor

	efimovFactor

#### Electric constant (vacuum permeability)

	electricConstant

#### Electron mass

	electronMass

#### Elementary charge

	elementaryCharge

#### Faraday constant

	faraday

#### Fermi coupling constant

	fermiCoupling

#### Fine-structure constant

	fineStructure

#### First radiation constant

	firstRadiation

#### Gas constant

	gasConstant

#### Newtonian constant of gravitation

	gravitationConstant

#### Standard acceleration of gravity (standard acceleration of free-fall on Earth)

	gravity

#### Hartree energy

	hartreeEnergy

#### Inverse conductance quantum

	inverseConductanceQuantum

#### Von Klitzing constant

	klitzing

#### Loschmidt constant at T=273.15 K and p=101.325 kPa

	loschmidt

#### Magnetic constant (vacuum permeability)

	magneticConstant

#### Magnetic flux quantum

	magneticFluxQuantum

#### Molar mass constant

	molarMass

#### Molar mass constant of carbon-12

	molarMassC12

#### Molar Planck constant

	molarPlanckConstant

#### Molar volume of an ideal gas at T=273.15 K and p=101.325 kPa

	molarVolume

#### Neutron mass

	neutronMass

#### Nuclear magneton

	nuclearMagneton

#### Planck charge

	planckCharge

#### Planck constant

	planckConstant

#### Planck length

	planckLength

#### Planck mass

	planckMass

#### Planck temperature

	planckTemperature

#### Planck time

	planckTime

#### Proton mass

	protonMass

#### Quantum of circulation

	quantumOfCirculation

#### Reduced Planck constant

	reducedPlanckConstant

#### Rydberg constant

	rydberg

#### Sackur-Tetrode constant at T=1 K and p=101.325 kPa

	sackurTetrode

#### Second radiation constant

	secondRadiation

#### Speed of light in vacuum

	speedOfLight

#### Stefan-Boltzmann constant

	stefanBoltzmann

#### Thomson cross section

	thomsonCrossSection

#### Characteristic impedance of vacuum

	vacuumImpedance

#### Weak mixing angle

	weakMixingAngle

#### Wien displacement law constant

	wienDisplacement



### Amount Of Substance
|Unit|Prefixes|
|----|----|
|mol|da, h, k, M, G, T, P, E, Z, Y, R, Q, d, c, m, u, n, p, f, a, z, y, r, q|
|mole|deca, hecto, kilo, mega, giga, tera, peta, exa, zetta, yotta, ronna, quetta, deci, centi, milli, micro, nano, pico, femto, atto, zepto, yocto, ronto, quecto|
|moles|deca, hecto, kilo, mega, giga, tera, peta, exa, zetta, yotta, ronna, quetta, deci, centi, milli, micro, nano, pico, femto, atto, zepto, yocto, ronto, quecto|

### Angle
|Unit|Prefixes|
|----|----|
|rad|da, h, k, M, G, T, P, E, Z, Y, R, Q, d, c, m, u, n, p, f, a, z, y, r, q|
|radian|deca, hecto, kilo, mega, giga, tera, peta, exa, zetta, yotta, ronna, quetta, deci, centi, milli, micro, nano, pico, femto, atto, zepto, yocto, ronto, quecto|
|deg|da, h, k, M, G, T, P, E, Z, Y, R, Q, d, c, m, u, n, p, f, a, z, y, r, q|
|degree|deca, hecto, kilo, mega, giga, tera, peta, exa, zetta, yotta, ronna, quetta, deci, centi, milli, micro, nano, pico, femto, atto, zepto, yocto, ronto, quecto|
|grad|da, h, k, M, G, T, P, E, Z, Y, R, Q, d, c, m, u, n, p, f, a, z, y, r, q|
|gradian|deca, hecto, kilo, mega, giga, tera, peta, exa, zetta, yotta, ronna, quetta, deci, centi, milli, micro, nano, pico, femto, atto, zepto, yocto, ronto, quecto|
|cycle||
|arcsec||
|arcmin||
|radians|deca, hecto, kilo, mega, giga, tera, peta, exa, zetta, yotta, ronna, quetta, deci, centi, milli, micro, nano, pico, femto, atto, zepto, yocto, ronto, quecto|
|degrees|deca, hecto, kilo, mega, giga, tera, peta, exa, zetta, yotta, ronna, quetta, deci, centi, milli, micro, nano, pico, femto, atto, zepto, yocto, ronto, quecto|
|gradians|deca, hecto, kilo, mega, giga, tera, peta, exa, zetta, yotta, ronna, quetta, deci, centi, milli, micro, nano, pico, femto, atto, zepto, yocto, ronto, quecto|
|cycles||
|arcsecond||
|arcseconds||
|arcminute||
|arcminutes||

### Bit
|Unit|Prefixes|
|----|----|
|b|k, M, G, T, P, E, Z, Y, Ki, Mi, Gi, Ti, Pi, Ei, Zi, Yi|
|bits|kilo, mega, giga, tera, peta, exa, zetta, yotta, kibi, mebi, gibi, tebi, pebi, exi, zebi, yobi|
|B|k, M, G, T, P, E, Z, Y, Ki, Mi, Gi, Ti, Pi, Ei, Zi, Yi|
|bytes|kilo, mega, giga, tera, peta, exa, zetta, yotta, kibi, mebi, gibi, tebi, pebi, exi, zebi, yobi|
|bit|kilo, mega, giga, tera, peta, exa, zetta, yotta, kibi, mebi, gibi, tebi, pebi, exi, zebi, yobi|
|byte|kilo, mega, giga, tera, peta, exa, zetta, yotta, kibi, mebi, gibi, tebi, pebi, exi, zebi, yobi|

### Current
|Unit|Prefixes|
|----|----|
|A|da, h, k, M, G, T, P, E, Z, Y, R, Q, d, c, m, u, n, p, f, a, z, y, r, q|
|ampere|deca, hecto, kilo, mega, giga, tera, peta, exa, zetta, yotta, ronna, quetta, deci, centi, milli, micro, nano, pico, femto, atto, zepto, yocto, ronto, quecto|
|amperes|deca, hecto, kilo, mega, giga, tera, peta, exa, zetta, yotta, ronna, quetta, deci, centi, milli, micro, nano, pico, femto, atto, zepto, yocto, ronto, quecto|
|amps|deca, hecto, kilo, mega, giga, tera, peta, exa, zetta, yotta, ronna, quetta, deci, centi, milli, micro, nano, pico, femto, atto, zepto, yocto, ronto, quecto|
|amp|deca, hecto, kilo, mega, giga, tera, peta, exa, zetta, yotta, ronna, quetta, deci, centi, milli, micro, nano, pico, femto, atto, zepto, yocto, ronto, quecto|

### Electric Capacitance
|Unit|Prefixes|
|----|----|
|farad|deca, hecto, kilo, mega, giga, tera, peta, exa, zetta, yotta, ronna, quetta, deci, centi, milli, micro, nano, pico, femto, atto, zepto, yocto, ronto, quecto|
|F|da, h, k, M, G, T, P, E, Z, Y, R, Q, d, c, m, u, n, p, f, a, z, y, r, q|
|farads|deca, hecto, kilo, mega, giga, tera, peta, exa, zetta, yotta, ronna, quetta, deci, centi, milli, micro, nano, pico, femto, atto, zepto, yocto, ronto, quecto|

### Electric Charge
|Unit|Prefixes|
|----|----|
|coulomb|deca, hecto, kilo, mega, giga, tera, peta, exa, zetta, yotta, ronna, quetta, deci, centi, milli, micro, nano, pico, femto, atto, zepto, yocto, ronto, quecto|
|C|da, h, k, M, G, T, P, E, Z, Y, R, Q, d, c, m, u, n, p, f, a, z, y, r, q|
|coulombs|deca, hecto, kilo, mega, giga, tera, peta, exa, zetta, yotta, ronna, quetta, deci, centi, milli, micro, nano, pico, femto, atto, zepto, yocto, ronto, quecto|

### Electric Conductance
|Unit|Prefixes|
|----|----|
|siemens|deca, hecto, kilo, mega, giga, tera, peta, exa, zetta, yotta, ronna, quetta, deci, centi, milli, micro, nano, pico, femto, atto, zepto, yocto, ronto, quecto|
|S|da, h, k, M, G, T, P, E, Z, Y, R, Q, d, c, m, u, n, p, f, a, z, y, r, q|

### Electric Inductance
|Unit|Prefixes|
|----|----|
|henry|deca, hecto, kilo, mega, giga, tera, peta, exa, zetta, yotta, ronna, quetta, deci, centi, milli, micro, nano, pico, femto, atto, zepto, yocto, ronto, quecto|
|H|da, h, k, M, G, T, P, E, Z, Y, R, Q, d, c, m, u, n, p, f, a, z, y, r, q|

### Electric Potential
|Unit|Prefixes|
|----|----|
|volt|deca, hecto, kilo, mega, giga, tera, peta, exa, zetta, yotta, ronna, quetta, deci, centi, milli, micro, nano, pico, femto, atto, zepto, yocto, ronto, quecto|
|V|da, h, k, M, G, T, P, E, Z, Y, R, Q, d, c, m, u, n, p, f, a, z, y, r, q|
|volts|deca, hecto, kilo, mega, giga, tera, peta, exa, zetta, yotta, ronna, quetta, deci, centi, milli, micro, nano, pico, femto, atto, zepto, yocto, ronto, quecto|

### Electric Resistance
|Unit|Prefixes|
|----|----|
|ohm|da, h, k, M, G, T, P, E, Z, Y, R, Q, d, c, m, u, n, p, f, a, z, y, r, q, deca, hecto, kilo, mega, giga, tera, peta, exa, zetta, yotta, ronna, quetta, deci, centi, milli, micro, nano, pico, femto, atto, zepto, yocto, ronto, quecto|
|ohms|da, h, k, M, G, T, P, E, Z, Y, R, Q, d, c, m, u, n, p, f, a, z, y, r, q, deca, hecto, kilo, mega, giga, tera, peta, exa, zetta, yotta, ronna, quetta, deci, centi, milli, micro, nano, pico, femto, atto, zepto, yocto, ronto, quecto|

### Energy
|Unit|Prefixes|
|----|----|
|J|da, h, k, M, G, T, P, E, Z, Y, R, Q, d, c, m, u, n, p, f, a, z, y, r, q|
|joule|deca, hecto, kilo, mega, giga, tera, peta, exa, zetta, yotta, ronna, quetta, deci, centi, milli, micro, nano, pico, femto, atto, zepto, yocto, ronto, quecto|
|erg|da, h, k, M, G, T, P, E, Z, Y, R, Q, d, c, m, u, n, p, f, a, z, y, r, q, deca, hecto, kilo, mega, giga, tera, peta, exa, zetta, yotta, ronna, quetta, deci, centi, milli, micro, nano, pico, femto, atto, zepto, yocto, ronto, quecto|
|Wh|da, h, k, M, G, T, P, E, Z, Y, R, Q, d, c, m, u, n, p, f, a, z, y, r, q|
|BTU|MM|
|eV|da, h, k, M, G, T, P, E, Z, Y, R, Q, d, c, m, u, n, p, f, a, z, y, r, q|
|electronvolt|deca, hecto, kilo, mega, giga, tera, peta, exa, zetta, yotta, ronna, quetta, deci, centi, milli, micro, nano, pico, femto, atto, zepto, yocto, ronto, quecto|
|BTUs|MM|
|joules|deca, hecto, kilo, mega, giga, tera, peta, exa, zetta, yotta, ronna, quetta, deci, centi, milli, micro, nano, pico, femto, atto, zepto, yocto, ronto, quecto|
|electronvolts|deca, hecto, kilo, mega, giga, tera, peta, exa, zetta, yotta, ronna, quetta, deci, centi, milli, micro, nano, pico, femto, atto, zepto, yocto, ronto, quecto|

### Force
|Unit|Prefixes|
|----|----|
|N|da, h, k, M, G, T, P, E, Z, Y, R, Q, d, c, m, u, n, p, f, a, z, y, r, q|
|newton|deca, hecto, kilo, mega, giga, tera, peta, exa, zetta, yotta, ronna, quetta, deci, centi, milli, micro, nano, pico, femto, atto, zepto, yocto, ronto, quecto|
|dyn|da, h, k, M, G, T, P, E, Z, Y, R, Q, d, c, m, u, n, p, f, a, z, y, r, q|
|dyne|deca, hecto, kilo, mega, giga, tera, peta, exa, zetta, yotta, ronna, quetta, deci, centi, milli, micro, nano, pico, femto, atto, zepto, yocto, ronto, quecto|
|lbf||
|poundforce||
|kip|deca, hecto, kilo, mega, giga, tera, peta, exa, zetta, yotta, ronna, quetta, deci, centi, milli, micro, nano, pico, femto, atto, zepto, yocto, ronto, quecto|
|kilogramforce||
|kips|deca, hecto, kilo, mega, giga, tera, peta, exa, zetta, yotta, ronna, quetta, deci, centi, milli, micro, nano, pico, femto, atto, zepto, yocto, ronto, quecto|
|kgf||

### Frequency
|Unit|Prefixes|
|----|----|
|hertz|deca, hecto, kilo, mega, giga, tera, peta, exa, zetta, yotta, ronna, quetta, deci, centi, milli, micro, nano, pico, femto, atto, zepto, yocto, ronto, quecto|
|Hz|da, h, k, M, G, T, P, E, Z, Y, R, Q, d, c, m, u, n, p, f, a, z, y, r, q|

### Length
|Unit|Prefixes|
|----|----|
|meter|deca, hecto, kilo, mega, giga, tera, peta, exa, zetta, yotta, ronna, quetta, deci, centi, milli, micro, nano, pico, femto, atto, zepto, yocto, ronto, quecto|
|inch||
|foot||
|yard||
|mile||
|link||
|rod||
|chain||
|angstrom||
|m|da, h, k, M, G, T, P, E, Z, Y, R, Q, d, c, m, u, n, p, f, a, z, y, r, q|
|in||
|ft||
|yd||
|mi||
|li||
|rd||
|ch||
|mil||
|meters|deca, hecto, kilo, mega, giga, tera, peta, exa, zetta, yotta, ronna, quetta, deci, centi, milli, micro, nano, pico, femto, atto, zepto, yocto, ronto, quecto|
|inches||
|feet||
|yards||
|miles||
|links||
|rods||
|chains||
|angstroms||

### Luminous Intensity
|Unit|Prefixes|
|----|----|
|cd|da, h, k, M, G, T, P, E, Z, Y, R, Q, d, c, m, u, n, p, f, a, z, y, r, q|
|candela|deca, hecto, kilo, mega, giga, tera, peta, exa, zetta, yotta, ronna, quetta, deci, centi, milli, micro, nano, pico, femto, atto, zepto, yocto, ronto, quecto|

### Magnetic Flux
|Unit|Prefixes|
|----|----|
|weber|deca, hecto, kilo, mega, giga, tera, peta, exa, zetta, yotta, ronna, quetta, deci, centi, milli, micro, nano, pico, femto, atto, zepto, yocto, ronto, quecto|
|Wb|da, h, k, M, G, T, P, E, Z, Y, R, Q, d, c, m, u, n, p, f, a, z, y, r, q|
|webers|deca, hecto, kilo, mega, giga, tera, peta, exa, zetta, yotta, ronna, quetta, deci, centi, milli, micro, nano, pico, femto, atto, zepto, yocto, ronto, quecto|

### Magnetic Flux Density
|Unit|Prefixes|
|----|----|
|tesla|deca, hecto, kilo, mega, giga, tera, peta, exa, zetta, yotta, ronna, quetta, deci, centi, milli, micro, nano, pico, femto, atto, zepto, yocto, ronto, quecto|
|T|da, h, k, M, G, T, P, E, Z, Y, R, Q, d, c, m, u, n, p, f, a, z, y, r, q|
|teslas|deca, hecto, kilo, mega, giga, tera, peta, exa, zetta, yotta, ronna, quetta, deci, centi, milli, micro, nano, pico, femto, atto, zepto, yocto, ronto, quecto|

### Mass
|Unit|Prefixes|
|----|----|
|g|da, h, k, M, G, T, P, E, Z, Y, R, Q, d, c, m, u, n, p, f, a, z, y, r, q|
|gram|deca, hecto, kilo, mega, giga, tera, peta, exa, zetta, yotta, ronna, quetta, deci, centi, milli, micro, nano, pico, femto, atto, zepto, yocto, ronto, quecto|
|ton|da, h, k, M, G, T, P, E, Z, Y, R, Q, d, c, m, u, n, p, f, a, z, y, r, q|
|t|da, h, k, M, G, T, P, E, Z, Y, R, Q, d, c, m, u, n, p, f, a, z, y, r, q|
|tonne|deca, hecto, kilo, mega, giga, tera, peta, exa, zetta, yotta, ronna, quetta, deci, centi, milli, micro, nano, pico, femto, atto, zepto, yocto, ronto, quecto|
|grain||
|dram||
|ounce||
|poundmass||
|hundredweight||
|stick||
|stone||
|gr||
|dr||
|oz||
|lbm||
|cwt||
|grams|deca, hecto, kilo, mega, giga, tera, peta, exa, zetta, yotta, ronna, quetta, deci, centi, milli, micro, nano, pico, femto, atto, zepto, yocto, ronto, quecto|
|tons|da, h, k, M, G, T, P, E, Z, Y, R, Q, d, c, m, u, n, p, f, a, z, y, r, q|
|tonnes|deca, hecto, kilo, mega, giga, tera, peta, exa, zetta, yotta, ronna, quetta, deci, centi, milli, micro, nano, pico, femto, atto, zepto, yocto, ronto, quecto|
|grains||
|drams||
|ounces||
|poundmasses||
|hundredweights||
|sticks||
|lb||
|lbs||

### Power
|Unit|Prefixes|
|----|----|
|W|da, h, k, M, G, T, P, E, Z, Y, R, Q, d, c, m, u, n, p, f, a, z, y, r, q|
|watt|deca, hecto, kilo, mega, giga, tera, peta, exa, zetta, yotta, ronna, quetta, deci, centi, milli, micro, nano, pico, femto, atto, zepto, yocto, ronto, quecto|
|hp||
|VAR|da, h, k, M, G, T, P, E, Z, Y, R, Q, d, c, m, u, n, p, f, a, z, y, r, q|
|VA|da, h, k, M, G, T, P, E, Z, Y, R, Q, d, c, m, u, n, p, f, a, z, y, r, q|
|watts|deca, hecto, kilo, mega, giga, tera, peta, exa, zetta, yotta, ronna, quetta, deci, centi, milli, micro, nano, pico, femto, atto, zepto, yocto, ronto, quecto|

### Pressure
|Unit|Prefixes|
|----|----|
|Pa|da, h, k, M, G, T, P, E, Z, Y, R, Q, d, c, m, u, n, p, f, a, z, y, r, q|
|psi||
|atm||
|bar|da, h, k, M, G, T, P, E, Z, Y, R, Q, d, c, m, u, n, p, f, a, z, y, r, q, deca, hecto, kilo, mega, giga, tera, peta, exa, zetta, yotta, ronna, quetta, deci, centi, milli, micro, nano, pico, femto, atto, zepto, yocto, ronto, quecto|
|torr||
|mmHg||
|mmH2O||
|cmH2O||
|mmhg||
|mmh2o||
|cmh2o||

### Surface
|Unit|Prefixes|
|----|----|
|m2|da, h, k, M, G, T, P, E, Z, Y, R, Q, d, c, m, u, n, p, f, a, z, y, r, q|
|sqin||
|sqft||
|sqyd||
|sqmi||
|sqrd||
|sqch||
|sqmil||
|acre||
|hectare||
|acres||
|hectares||
|sqfeet||
|sqyard||
|sqmile||
|sqmiles||

### Temperature
|Unit|Prefixes|
|----|----|
|K|da, h, k, M, G, T, P, E, Z, Y, R, Q, d, c, m, u, n, p, f, a, z, y, r, q|
|degC|da, h, k, M, G, T, P, E, Z, Y, R, Q, d, c, m, u, n, p, f, a, z, y, r, q|
|degF|da, h, k, M, G, T, P, E, Z, Y, R, Q, d, c, m, u, n, p, f, a, z, y, r, q|
|degR|da, h, k, M, G, T, P, E, Z, Y, R, Q, d, c, m, u, n, p, f, a, z, y, r, q|
|kelvin|deca, hecto, kilo, mega, giga, tera, peta, exa, zetta, yotta, ronna, quetta, deci, centi, milli, micro, nano, pico, femto, atto, zepto, yocto, ronto, quecto|
|celsius|deca, hecto, kilo, mega, giga, tera, peta, exa, zetta, yotta, ronna, quetta, deci, centi, milli, micro, nano, pico, femto, atto, zepto, yocto, ronto, quecto|
|fahrenheit|deca, hecto, kilo, mega, giga, tera, peta, exa, zetta, yotta, ronna, quetta, deci, centi, milli, micro, nano, pico, femto, atto, zepto, yocto, ronto, quecto|
|rankine|deca, hecto, kilo, mega, giga, tera, peta, exa, zetta, yotta, ronna, quetta, deci, centi, milli, micro, nano, pico, femto, atto, zepto, yocto, ronto, quecto|

### Time
|Unit|Prefixes|
|----|----|
|s|da, h, k, M, G, T, P, E, Z, Y, R, Q, d, c, m, u, n, p, f, a, z, y, r, q|
|min||
|h||
|second|deca, hecto, kilo, mega, giga, tera, peta, exa, zetta, yotta, ronna, quetta, deci, centi, milli, micro, nano, pico, femto, atto, zepto, yocto, ronto, quecto|
|sec|deca, hecto, kilo, mega, giga, tera, peta, exa, zetta, yotta, ronna, quetta, deci, centi, milli, micro, nano, pico, femto, atto, zepto, yocto, ronto, quecto|
|minute||
|hour||
|day||
|week||
|month||
|year||
|decade||
|century||
|millennium||
|seconds|deca, hecto, kilo, mega, giga, tera, peta, exa, zetta, yotta, ronna, quetta, deci, centi, milli, micro, nano, pico, femto, atto, zepto, yocto, ronto, quecto|
|secs|deca, hecto, kilo, mega, giga, tera, peta, exa, zetta, yotta, ronna, quetta, deci, centi, milli, micro, nano, pico, femto, atto, zepto, yocto, ronto, quecto|
|minutes||
|mins||
|hours||
|hr||
|hrs||
|days||
|weeks||
|months||
|years||
|decades||
|centuries||
|millennia||

### Volume
|Unit|Prefixes|
|----|----|
|m3|da, h, k, M, G, T, P, E, Z, Y, R, Q, d, c, m, u, n, p, f, a, z, y, r, q|
|L|da, h, k, M, G, T, P, E, Z, Y, R, Q, d, c, m, u, n, p, f, a, z, y, r, q|
|l|da, h, k, M, G, T, P, E, Z, Y, R, Q, d, c, m, u, n, p, f, a, z, y, r, q|
|litre|deca, hecto, kilo, mega, giga, tera, peta, exa, zetta, yotta, ronna, quetta, deci, centi, milli, micro, nano, pico, femto, atto, zepto, yocto, ronto, quecto|
|cuin||
|cuft||
|cuyd||
|teaspoon||
|tablespoon||
|drop||
|gtt||
|minim||
|fluiddram||
|fluidounce||
|gill||
|cc||
|cup||
|pint||
|quart||
|gallon||
|beerbarrel||
|oilbarrel||
|hogshead||
|lt|da, h, k, M, G, T, P, E, Z, Y, R, Q, d, c, m, u, n, p, f, a, z, y, r, q|
|litres|deca, hecto, kilo, mega, giga, tera, peta, exa, zetta, yotta, ronna, quetta, deci, centi, milli, micro, nano, pico, femto, atto, zepto, yocto, ronto, quecto|
|liter|deca, hecto, kilo, mega, giga, tera, peta, exa, zetta, yotta, ronna, quetta, deci, centi, milli, micro, nano, pico, femto, atto, zepto, yocto, ronto, quecto|
|liters|deca, hecto, kilo, mega, giga, tera, peta, exa, zetta, yotta, ronna, quetta, deci, centi, milli, micro, nano, pico, femto, atto, zepto, yocto, ronto, quecto|
|teaspoons||
|tablespoons||
|minims||
|fldr||
|fluiddrams||
|floz||
|fluidounces||
|gi||
|gills||
|cp||
|cups||
|pt||
|pints||
|qt||
|quarts||
|gal||
|gallons||
|bbl||
|beerbarrels||
|obl||
|oilbarrels||
|hogsheads||
|gtts||
