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
{$IFDEF ios7crypt}{$ELSE}
interface
function Xlat (index : integer, length : integer) : bytes;
function Encrypt (password : string) : string;
function Decrypt (hash : string) : string;
implementation
{$ENDIF}
function Xlat (i : integer, len : integer) : bytes;
begin
	if len < 1 then
		Xlat := ();
	else
		begin
			XlatPrime[i % XlatSize] { ... }
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