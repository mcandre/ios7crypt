{$IFDEF ios7crypt}
program IOS7Crypt;
{$ELSE}
unit IOS7Crypt;
{$ENDIF}
{$Mode ObjFPC}
uses
	getopts,
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
procedure Test;
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
procedure Test;
begin
	{ ... }
end;
procedure Usage (Prog : string);
begin
	write('Usage: ');
	write(Prog);
	writeln(' [options]');
	writeln('--encrypt -e <password>'#9'Encrypt');
	writeln('--decrypt -d <hash>'#9'Decrypt');
	writeln('--test -t'#9#9'Unit test');
	writeln('--help -h'#9#9'Usage info');
	Halt(0);
end;
{$IFDEF ios7crypt}
var
	C : char;
	OptionIndex : longint;
	Options : array[1..7] of TOption;
	Mode : string;
	Password : string;
	Hash : string;
begin
{$ELSE}
initialization
{$ENDIF}
	Randomize;
{$IFDEF ios7crypt}
	Mode := 'help';

	with Options[1] do
		begin
			name := 'encrypt';
			has_arg := 1;
			flag := nil;
			value := #0;
		end;
	with Options[2] do
		begin
			name := 'decrypt';
			has_arg := 1;
			flag := nil;
			value := #0;
		end;
	with Options[3] do
		begin
			name := 'test';
			has_arg := 0;
			value := #0;
		end;
	with Options[4] do
		begin
			name := 'help';
			has_arg := 0;
		end;

	C := #0;

	repeat
		C := getlongopts('e:d:th', @Options[1], OptionIndex);
		case C of
			'e':
			begin
				Mode := 'encrypt';
				Password := optarg;
			end;
			'd':
			begin
				Mode := 'decrypt';
				Hash := optarg;
			end;
			't': Mode := 'test';
			'h': Usage(ParamStr(0));
			'?': Usage(ParamStr(0));
		end;
	until C = endofoptions;

	if Mode = 'encrypt' then
		writeln(Encrypt(Password))
	else
		if Mode = 'decrypt' then
			writeln(Decrypt(Hash))
		else
			if Mode = 'test' then
				Test()
			else
				Usage(ParamStr(0));
{$ENDIF}
end.
