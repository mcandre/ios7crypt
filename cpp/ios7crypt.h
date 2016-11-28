#pragma once

// Copyright (C) YelloSoft

#include <string>
using std::string;

extern int xlat[];
extern int XLAT_SIZE;

static void usage(string const program);
string encrypt(string const password);
string decrypt(string const hash);

