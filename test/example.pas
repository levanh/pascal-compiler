PROGRAM prog;

{ function f }
FUNCTION F(x:INTEGER):INTEGER;
// This functions computes the sum of all even numbers from 0 to x
VAR i:INTEGER;
BEGIN
	i := 0;
	f := 0;
	WHILE i < x DO
		IF i MOD 2 = 0 THEN f := 0;
END;

{ main program }
VAR x:INTEGER;
BEGIN
	READLN(x);
	WRITELN(f(x));
END.
{ This comment should really be closed
