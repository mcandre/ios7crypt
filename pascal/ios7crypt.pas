{$IFDEF ios7crypt}
program IOS7Crypt;
{$ELSE}
unit IOS7Crypt;
{$ENDIF}
type
	bytes = array of byte;
const
	XlatSize = 53;
	XlatPrime : array[0 .. XlatSize - 1] of byte = (
		$64, $73, $66, $64, $3b, $6b, $66, $6f,
		$41, $2c, $2e, $69, $79, $65, $77, $72,
		$6b, $6c, $64, $4a, $4b, $44, $48, $53,
		$55, $42, $73, $67, $76, $63, $61, $36,
		$39, $38, $33, $34, $6e, $63, $78, $76,
		$39, $38, $37, $33, $32, $35, $34, $6b,
		$3b, $66, $67, $38, $37
	);
	Empty : bytes = nil;
	One : array[0 .. 0] of byte = ($00);
{$IFDEF ios7crypt}{$ELSE}
interface
function Xlat (i : integer; len : integer) : bytes;
function Encrypt (password : string) : string;
function Decrypt (hash : string) : string;
implementation
{$ENDIF}
function Xlat (i : integer; len : integer) : bytes;
var
	Rest : bytes;
	J : integer;
begin
	if len < 1 then
		Xlat := Empty
	else
		begin
			Rest := Xlat(i + 1, len - 1);

			SetLength(Xlat, Length(Rest) + 1);

			Xlat[0] := XlatPrime[i mod XlatSize];

			for J := 0 to Length(Rest) - 1 do
				Xlat[J + 1] := Rest[J];
		end;
end;

function Encrypt (hash : string) : string;
begin
	Encrypt := 'abc';

	{ ... }
end;

function Decrypt (hash : string) : string;
begin
	Decrypt := 'abc';

	{ ... }
end;
{$IFDEF ios7crypt}
var
	password : string;
	hash : string;
begin
	password := 'abc';

	hash := Encrypt(password);

	password := Decrypt(hash);

	write('Password: ');
	writeln(password);

	{ ... }
{$ENDIF}
end.