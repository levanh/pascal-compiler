PROGRAM prog;

FUNCTION multiply(a,b: REAL): REAL;
BEGIN
	multiply := a*b;
END;

FUNCTION hot(temp: INTEGER): BOOLEAN;
BEGIN
	IF temp > 25 THEN hot := true ELSE hot := false;
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
