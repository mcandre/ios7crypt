{$IFDEF ios7crypt}
program IOS7Crypt;
{$ELSE}
unit IOS7Crypt;
{$ENDIF}
{$Mode ObjFPC}
uses
	sysutils;
type
	bytes = array of byte;
	strings = array of string;
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
function Xlat (i : integer; len : integer) : bytes;
function Encrypt (password : string) : string;
function Decrypt (hash : string) : string;
implementation
{$ENDIF}
function Xlat (i : integer; len : integer) : bytes;
var
	J : integer;
begin
	SetLength(Xlat, len);

	for J := 0 to len - 1 do
		Xlat[J] := XlatPrime[(i + J) mod XlatSize];
end;

function Encrypt (password : string) : string;
var
	Seed : integer;
	Plaintext : bytes;
	Keys : bytes;
	Ciphertext : bytes;
	I : integer;
	Hex : string;
begin
	if Length(password) = 0 then
		Encrypt := ''
	else
		begin
			Seed := Random(16);

			Keys := Xlat(Seed, Length(password));

			SetLength(Plaintext, Length(password));

			for I := 0 to Length(password) - 1 do
				{ String indices start at 1, but array indices start at 0 !? }
				Plaintext[I] := Ord(password[I + 1]);

			SetLength(Ciphertext, Length(password));

			for I := 0 to Length(password) - 1 do
				Ciphertext[I] := Keys[I] xor Plaintext[I];

			Hex := '';

			for I := 0 to Length(Ciphertext) - 1 do
				Hex := Concat(Hex, AnsiLowerCase(Format('%.2x', [Ciphertext[I]])));

			Encrypt := Concat(Format('%.2d', [Seed]), Hex);
		end;
end;

function OnlyPairs (text : string) : strings;
var
	Len : integer;
	I : integer;
begin
	Len := Length(text) div 2;

	SetLength(OnlyPairs, Len);

	for I := 0 to Len - 1 do
		OnlyPairs[I] := Copy(text, I * 2 + 1, 2);
end;

function Decrypt (hash : string) : string;
var
	Head : string;
	Tail : string;
	Seed : integer;
	HexPairs : strings;
	I : integer;
	Cipherbyte : integer;
	Ciphertext : bytes;
	Keys : bytes;
	Plaintext : bytes;
	Password : string;
begin
	if Length(hash) < 4 then
		Decrypt := ''
	else
		begin
			Head := Copy(hash, 1, 2);
			Tail := Copy(hash, 3, Length(hash) - 2);

			try
				Seed := StrToInt(Head);

				HexPairs := OnlyPairs(Tail);

				for I := 0 to Length(HexPairs) do
					begin
						try
							Cipherbyte := StrToInt(Concat('$', HexPairs[I]));

							SetLength(Ciphertext, I + 1);
							Ciphertext[I] := Cipherbyte;
						except
							on EConvertError do
							begin
							end;
						end;
					end;

				Keys := Xlat(Seed, Length(Ciphertext));

				SetLength(Plaintext, Length(Ciphertext));

				for I := 0 to Length(Ciphertext) do
					Plaintext[I] := Keys[I] xor Ciphertext[I];

				SetLength(Password, Length(Plaintext));

				for I := 0 to Length(Plaintext) do
					{ String indices start at 1, but array indices start at 0 !? }
					Password[I + 1] := chr(Plaintext[I]);

				Decrypt := Password;
			except
				on EConvertError do
					Decrypt := 'invalid hash';
			end;
		end;
end;
{$IFDEF ios7crypt}
var
	password : string;
	hash : string;
	password2 : string;
begin
{$ELSE}
initialization
{$ENDIF}
	Randomize;
{$IFDEF ios7crypt}
	password := 'monkey';

	write('Password: ');
	writeln(password);

	hash := Encrypt(password);

	write('Hash: ');
	writeln(hash);

	password2 := Decrypt(hash);

	write('Password: ');
	writeln(password2);

	{ ... }
{$ENDIF}
end.