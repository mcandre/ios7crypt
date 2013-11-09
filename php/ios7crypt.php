<?php

$password="";
if (array_key_exists("password", $_GET)) {
    $p=$_GET["password"];

    if (filter_var($p, FILTER_SANITIZE_SPECIAL_CHARS, FILTER_FLAG_STRIP_HIGH)) {
        $password=$p;
    }
}

$hash="";
if (array_key_exists("hash", $_GET)) {
    $h=$_GET["hash"];

    if (filter_var(
        $h,
        FILTER_VALIDATE_REGEXP,
        array("options"=>array("regexp"=>"/^[a-fA-F0-9]+$/"))
    )) {
        $hash=$h;
    }
}

$xlat=array(
    0x64, 0x73, 0x66, 0x64, 0x3b, 0x6b, 0x66, 0x6f,
    0x41, 0x2c, 0x2e, 0x69, 0x79, 0x65, 0x77, 0x72,
    0x6b, 0x6c, 0x64, 0x4a, 0x4b, 0x44, 0x48, 0x53,
    0x55, 0x42, 0x73, 0x67, 0x76, 0x63, 0x61, 0x36,
    0x39, 0x38, 0x33, 0x34, 0x6e, 0x63, 0x78, 0x76,
    0x39, 0x38, 0x37, 0x33, 0x32, 0x35, 0x34, 0x6b,
    0x3b, 0x66, 0x67, 0x38, 0x37
);

function encrypt($password) {
    global $xlat;

    if ($password==null || strlen($password)<1) {
        return "";
    }

    $seed=rand(0, 15);

    // Truncate
    $password=substr($password, 0, 11);

    $hash="";
    for ($i=0; $i<strlen($password); $i++) {
        $byte = ord(substr($password, $i, 1)) ^ $xlat[($i+$seed)%count($xlat)];
        $hash = $hash . sprintf("%02x", $byte);
    }

    return sprintf("%02d", $seed) . $hash;
}

function decrypt($hash) {
    global $xlat;

    if ($hash==null || strlen($hash)<4) {
        return "";
    }

    $seed=intval(substr($hash, 0, 2));
    $hash=substr($hash, 2);

    $pairs=str_split($hash, 2);

    $password="";

    for ($i=0; $i<count($pairs); $i++) {
        $hex=$pairs[$i];
        if (strlen($hex)==2) {
            $byte=intval($hex, 16) ^ $xlat[($i+$seed)%count($xlat)];
            $password = $password . chr($byte);
        }
    }

    return $password;
}

if ($password!="") {
    $hash=encrypt($password);
} elseif ($hash!="") {
    $password=decrypt($hash);
} ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
	<meta http-equiv="content-type" content="text/html;charset=UTF-8" />
	<title>IOS7Crypt</title>
	<link href="favicon.ico" rel="shortcut icon" type="image/x-icon" />
</head>
<body>

<h1 id="logo">IOS7Crypt</h1>

<div id="crypto_form">

<form action="ios7crypt.php" method="get">
	<p><label for="password">Password</label> <input id="password" type="text" name="password" value="<?php echo $password ?>" /></p>
</form>
<form action="ios7crypt.php" method="get">
	<p><label for="hash">Hash</label> <input id="hash" type="text" name="hash" value="<?php echo $hash ?>" /></p>
</form>

</div>

<p>&copy; 2008 <a href="http://yellosoft.us/">YelloSoft</a></p>

</body>
</html>