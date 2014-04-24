PROGRAM functions;

FUNCTION multiply(a, b: REAL): REAL;
BEGIN
	WHILE multiply < 100.0 DO
		multiply := multiply + a * b;
END;

FUNCTION autoignition(fahrenheit: INTEGER): BOOLEAN;
BEGIN
	IF fahrenheit > 451 THEN
		autoignition := true
	ELSE
		BEGIN
			WRITELN(fahrenheit);
			autoignition := false;
		END;;
END;

PROCEDURE printSquare(a: INTEGER);
VAR n: INTEGER;
BEGIN
	n := a*a;
	WRITELN(n);
END;

VAR x:INTEGER;
BEGIN
	READLN(x);
	printSquare(x);
END.
