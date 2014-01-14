#!/usr/bin/env lua

-- Andrew Pennebaker (andrew.pennebaker@gmail.com)
-- Copyright 2008 Andrew Pennebaker

os=require("os")
math=require("math")

-- Necessary for Windows 2K and Mac OS X systems
-- http://lua-users.org/wiki/MathLibraryTutorial
math.randomseed(os.time())
math.random(); math.random(); math.random();

-- Arno Wagner's bin_xor()
-- http://lua-users.org/wiki/BitUtils
function bxor(x, y)
	local z=0
	for i=0, 31 do
		if (x%2==0) then     -- x had a '0' in bit i
			if (y%2==1) then -- y had a '1' in bit i
				y=y-1 
				z=z+2^i      -- set bit i of z to '1' 
			end
		else                 -- x had a '1' in bit i
			x=x-1
			if (y%2==0) then -- y had a '0' in bit i
				z=z+2^i      -- set bit i of z to '1' 
			else
				y=y-1 
			end
		end

		y=y/2
		x=x/2
	end

	return z
end

function usage()
	print(
		"Usage: CommandLine [OPTIONS]\n" ..
		"--help, -h:\n" ..
		"    show help\n" ..
		"--encrypt, -e <password1> <password2> <password3> ...:\n" ..
		"    prints out the encrypted passwords as hashes\n" ..
		"--decrypt, -d <hash1> <hash2> <hash3> ...:\n" ..
		"    prints out the decrypted hashes as passwords"
	)

	os.exit()
end

local xlat={
	0x64, 0x73, 0x66, 0x64, 0x3b, 0x6b, 0x66, 0x6f,
	0x41, 0x2c, 0x2e, 0x69, 0x79, 0x65, 0x77, 0x72,
	0x6b, 0x6c, 0x64, 0x4a, 0x4b, 0x44, 0x48, 0x53,
	0x55, 0x42, 0x73, 0x67, 0x76, 0x63, 0x61, 0x36,
	0x39, 0x38, 0x33, 0x34, 0x6e, 0x63, 0x78, 0x76,
	0x39, 0x38, 0x37, 0x33, 0x32, 0x35, 0x34, 0x6b,
	0x3b, 0x66, 0x67, 0x38, 0x37
}

function encrypt(password)
	local seed=math.random(15)

	if password:len()<1 then
		return ""
	elseif password:len()>11 then
		password=password:sub(1, 11)
	end

	local hash=string.format("%02d", seed)

	for i=1, password:len() do
		local encryptedByte=bxor(xlat[(seed+i) % #xlat], password:byte(i, i))
		hash=hash .. string.format("%02x", encryptedByte)
	end

	return hash
end

function decrypt(hash)
	if hash:len()<4 or hash:len()%2~=0 then
		return ""
	end

	local seed=tonumber(hash:sub(1, 2))
	if seed==nil then
		return ""
	end

	local hash=hash:sub(3, hash:len())

	-- illegal characters
	if hash:match("[^%x]") then
		return ""
	end

	local password=""

	local i=1
	for p in hash:gmatch("%x%x") do
		local encryptedByte=tonumber(p, 16)
		password=password .. string.char(bxor(encryptedByte, xlat[(seed+i)%#xlat]))

		i=i+1
	end

	return password
end

function main(arg)
	if #arg<1 or arg[1]=="-h" or arg[1]=="--help" then
		usage()
	elseif arg[1]=="-e" or arg[1]=="--encrypt" then
		for i=2, #arg do
			print(encrypt(arg[i]))
		end
	elseif arg[1]=="-d" or arg[1]=="--decrypt" then
		for i=2, #arg do
			print(decrypt(arg[i]))
		end
	end
end

if type(package.loaded[(...)]) ~= "userdata" then
	main(arg)
else
	module(..., package.seeall)
end