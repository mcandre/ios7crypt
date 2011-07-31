#!/usr/bin/env python

__author__="Andrew Pennebaker (andrew.pennebaker@gmail.com)"
__date__="12 Apr 2006 - 21 Jul 2007"
__copyright__="Copyright 2006 2007 Andrew Pennebaker"

from IOS7Crypt import IOS7Crypt

import wx

ID_ANY=wx.ID_ANY
ID_PASSWORD=110
ID_HASH=111

cipher=IOS7Crypt()

class MainFrame(wx.Frame):
	def __init__(self, parent, id, title, pos=wx.DefaultPosition, size=(350, 120)):
		wx.Frame.__init__(self, parent, id, title, pos, size)

		self.panel=wx.Panel(self, ID_ANY)

		flags=wx.SizerFlags().Expand().Border(wx.ALL, 4)

		self.passwordLabel=wx.StaticText(self.panel, ID_ANY, "Password")

		self.passwordControl=wx.TextCtrl(self.panel, ID_PASSWORD, "", wx.DefaultPosition, wx.Size(250, -1), style=wx.TE_PROCESS_ENTER)
		wx.EVT_TEXT_ENTER(self.passwordControl, ID_PASSWORD, self.OnPassword)

		passwordSizer=wx.BoxSizer(wx.HORIZONTAL)
		passwordSizer.AddF(self.passwordLabel, flags)
		passwordSizer.AddF(self.passwordControl, flags)

		self.hashLabel=wx.StaticText(self.panel, ID_ANY, "Hash", size=wx.Size(60, 16))

		self.hashControl=wx.TextCtrl(self.panel, ID_HASH, "", wx.DefaultPosition, wx.Size(250, -1), style=wx.TE_PROCESS_ENTER)
		wx.EVT_TEXT_ENTER(self.hashControl, ID_HASH, self.OnHash)

		hashSizer=wx.BoxSizer(wx.HORIZONTAL)
		hashSizer.AddF(self.hashLabel, flags)
		hashSizer.AddF(self.hashControl, flags)

		box=wx.BoxSizer(wx.VERTICAL)
		box.Add(passwordSizer)
		box.Add(hashSizer)

		self.CreateStatusBar()

		self.panel.SetSizerAndFit(box)

		self.Show(True)

	def OnPassword(self, event):
		self.SetStatusText("Encrypting")

		password=self.passwordControl.GetValue()
		passwordBytes=[ord(e) for e in password]

		try:
			seed=cipher.generateKeyPair()[0]
			cipher.setKeys(seed)
			hashBytes=cipher.encrypt(passwordBytes)
			h="".join([chr(e) for e in hashBytes])

			self.hashControl.SetValue(h)

			self.SetStatusText("Encrypted")
		except:
			self.SetStatusText("Waiting for valid password")

	def OnHash(self, event):
		self.SetStatusText("Decrypting")

		h=self.hashControl.GetValue()
		hashBytes=[ord(e) for e in h]

		try:
			passwordBytes=cipher.decrypt(hashBytes)
			password="".join([chr(e) for e in passwordBytes])

			self.passwordControl.SetValue(password)

			self.SetStatusText("Decrypted")
		except:
			self.SetStatusText("Waiting for valid hash")

app=wx.PySimpleApp()
frame=MainFrame(None, ID_ANY, "IOS7Crypt")
app.MainLoop()