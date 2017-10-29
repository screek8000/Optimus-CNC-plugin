from cura.MachineAction import MachineAction

from UM.Application import Application
from UM.PluginRegistry import PluginRegistry
from UM.Logger import Logger

#from PyQt5.QtCore import pyqtSignal, pyqtProperty, pyqtSlot, QUrl, QObject
from PyQt5.QtQml import QQmlComponent, QQmlContext
from PyQt5.QtGui import *  
from PyQt5.QtCore import *  
from PyQt5.QtWidgets import *

from UM.View.GL.OpenGL import OpenGL

import glob

import os

if os.name == "nt":
    try:
        import winreg
    except:
        pass

import serial

import os.path

import time

import socket

import sys

# import thread

import threading

import traceback

from UM.i18n import i18nCatalog

from . import CNCLeaderHelp

from . import fileMode

catalog = i18nCatalog("cura")

class CNCLeaderAction(MachineAction):
	def __init__(self):
	    super().__init__("CNCLeaderAction", catalog.i18nc("@action", "CNCLeader"))
	    self._qml_url = "CNCLeaderAction.qml"

	    self.mainsocket=None

	    self.maincom=None

	    self.isconnect=0

	    self.setp=0

	    self.materialSize="20.0"

	    self.fileName=""

	    self.file_list_flag=False

	    self.checkMode=True

	instancesChanged = pyqtSignal()

	@pyqtSlot(str,result=str)
	def connect(self,nowip):
		try:
			self.mainsocket=socket.socket(socket.AF_INET,socket.SOCK_STREAM)
			ADDR=(nowip.encode(),8080)
				# self.mainsocket.connect(ADDR)
			self.mainsocket.connect(ADDR)
			# self.mainsocket.send("G28\n".encode())
			if self.setp!=0:
				self.setp=0
			self.setp=self.setp+1
			self.isconnect=1
		except Exception as e:
			self.isconnect=0
			connectResult=e.strerror+"Connect fail"
		if self.isconnect==1:
			connectResult="Connect Success"
		return connectResult

	@pyqtSlot(str)
	def send(self,code):
		try:
			self.mainsocket.send(code.encode())
		except Exception as e:
			mess=QMessageBox(QMessageBox.Warning, "Alert", "send error:"+e.strerror)
			mess.exec()
			pass

	def sendtest(self,codes):
		try:
			self.mainsocket.send(codes.encode())
		except Exception as e:
			mess=QMessageBox(QMessageBox.Warning, "Alert", "send error:"+e.strerror).exec()

	@pyqtSlot(result=bool)
	def connectCondition(self):
		if self.isconnect==1:
			condition=True
		if self.isconnect==0:
			condition=False
		return condition

	@pyqtSlot(result=int)
	def getStep(self):
		return self.setp

	@pyqtSlot(str,str,str,bool)
	def setMaterialSize(self,num,hight,zhight,checmode):
		if checmode==True:
			self.materialSize=("G92.1\nM306 X-"+str(float(num)/2)+" Y-"+str(float(hight)/2)+"\nG28 Z\nG31 J"+str(float(num)/2)+"\nG1 X0 Y0\nG30 Z"+str(float(hight))+"\nG92 X"+str(float(num)/2)+" Y"+str(float(num)/2)+" Z0\n"+"G1 Z5\n")
			self.checkMode=checmode
			# mess = QMessageBox(QMessageBox.Information, "Alert", self.materialSize+str(checmode)).exec()
		if checmode==False:
			self.materialSize=("G92.1\nM306 X0 Y0\nM557 P0 X"+str(float(num)*0.1)+" Y"+str(float(hight)*0.1)+"\n"+"M557 P1 X"+str(float(num)*0.9)+" Y"+str(float(hight)*0.1)+"\n"+"M557 P2 X"+str(float(num)*0.5)+" Y"+str(float(hight)*0.9)+"\nG32\n"+"G1 X"+str(float(num)*0.5)+" Y"+str(float(hight)*0.5)+" F2000\nG30 Z"+str(float(zhight))+"\nG92 Z"+str(float(zhight))+"\nG91\nG1 Z5 F500\nG90\n")
			# mess = QMessageBox(QMessageBox.Information, "Alert", self.materialSize).exec()
	
	@pyqtSlot(result=float)
	def getMaterialSize(self):
		return self.materialSize

	@pyqtSlot(result=str)
	def getStepHelp(self):
		if self.isconnect==1:
				if self.setp==2:
					help=CNCLeaderHelp.STEP_2
				if self.setp==3:
					help=CNCLeaderHelp.STEP_3
				if self.setp==4:
					help=CNCLeaderHelp.STEP_4
				if self.setp==5:
					help=CNCLeaderHelp.STEP_5
					pass
		return help

	@pyqtSlot()
	def backStep(self):
		if self.setp>1:
			self.setp=self.setp-1



	@pyqtSlot()
	def nextStep(self):
		if self.isconnect==1:
			if self.setp==5:
				mess = QMessageBox(QMessageBox.Information, "Alert", "If you want check cutter,make sure to set clip on zhe cutter!").exec()
				self.startPrint()
			if self.setp==4:
				mess = QMessageBox(QMessageBox.Information, "Alert", CNCLeaderHelp.After_FindPlane_Message,QMessageBox.Yes | QMessageBox.No).exec()
				if mess==QMessageBox.Yes:
					self.setp=self.setp+1
			if self.setp==3:
				mess = QMessageBox(QMessageBox.Information, "Alert", CNCLeaderHelp.Change_Cutter_Message,QMessageBox.Yes | QMessageBox.No).exec()
				if mess==QMessageBox.Yes:
					self.setp=self.setp+1
					try:
						self.mainsocket.send(self.materialSize.encode())
					except Exception as e:
						mess = QMessageBox(QMessageBox.Warning, "Alert", e.strerror+" error!please try again").exec()
						self.isconnect=0
						self.setp=self.setp-1
			if self.setp==2:
				try:
					self.mainsocket.send("G28\nM84\n".encode())
					self.setp=self.setp+1
				except Exception as e:
					mess = QMessageBox(QMessageBox.Warning, "Alert", e.strerror+" error!please try again").exec()
					self.isconnect=0
					self.setp=self.setp-1
			if self.setp==1:
				self.setp=self.setp+1


	def startPrint(self):
		mess = QMessageBox(QMessageBox.Warning, "Alert", "startPrint"+"M23 " + self.fileName+"\n").exec()
		self.mainsocket.send(("M23 " + self.fileName+"\n").encode())
		self.mainsocket.send(("M24\n").encode())

	@pyqtSlot(str)
	def getFile(self,fileNames):
		self.fileName=""
		self.fileName=fileNames+self.fileName
		try:
			mess = QMessageBox(QMessageBox.Warning, "Alert", self.fileName+" get name").exec()
		except Exception as e:
			mess = QMessageBox(QMessageBox.Warning, "Alert", e.strerror).exec()

	@pyqtSlot(int,result=QVariant)
	def foundFile(self,source):
		fileList=[]
		if self.isconnect==1:
			try:
				if source==1:
					self.mainsocket.send("M20 1:\n".encode())
				if source==2:
					self.mainsocket.send("M20 0:\n".encode())
				info=self.mainsocket.makefile()
				while True:
					line=info.readline()
					if line.find("End file list")!=-1:
					 	self.file_list_flag=False
					 	break
					if self.file_list_flag==True:
						fileList.append(line)
						# mess = QMessageBox(QMessageBox.Warning, "Alert", line+str(self.file_list_flag)).exec()
					if line.find("Begin file list")!=-1:
						self.file_list_flag=True
			except Exception as e:
				mess = QMessageBox(QMessageBox.Warning, "Alert", e.strerror+" error!please try again").exec()
				self.isconnect=0
		# f=None
		# try:
		# 	f=QVariant(fileList)
		# except Exception as e:
		# 	mess = QMessageBox(QMessageBox.Warning, "Alert", e.strerror).exec()

		# b=list.toPyObject()
		mess = QMessageBox(QMessageBox.Warning, "Alert", str(fileList)+str(self.file_list_flag)).exec()
		return QVariant(fileList)
	@pyqtSlot()
	def comtest(self):

		try:
			ms=QMessageBox(QMessageBox.Warning, "Alert", "serial test").exec()
			self.maincom = serial.Serial('COM3', 250000)
			ms=QMessageBox(QMessageBox.Warning, "Alert", "serial test2"+str(self.maincom.isOpen())).exec()
			n=self.maincom.write("G28\n".encode())  
			ms=QMessageBox(QMessageBox.Warning, "Alert", "serial test3").exec()
			a = self.maincom.read(n)  
			ms=QMessageBox(QMessageBox.Warning, "Alert", a).exec()
		except Exception as e:
			a=1

	@pyqtSlot()
	def comsend(self):
		baselist = []
		if os.name=="nt":
			try:
				key = winreg.OpenKey(winreg.HKEY_LOCAL_MACHINE, "HARDWARE\\DEVICEMAP\\SERIALCOMM")
				ms=QMessageBox(QMessageBox.Warning, "Alert", str([winreg.EnumValue(key, 0)[1]])).exec()
			except Exception as e:
				raise e

	@pyqtSlot(result=QVariant)
	def testlist(self):
		baselist = ["a","b","c"]
		return QVariant(baselist)


        # for g in ['/dev/ttyUSB*', '/dev/ttyACM*', "/dev/tty.*", "/dev/cu.*", "/dev/rfcomm*"]:
            # baselist += glob.glob(g)
        # return filter(self._bluetoothSerialFilter, baselist)
		# ms=QMessageBox(QMessageBox.Warning, "Alert", str(glob.glob('/dev/ttyACM*'))).exec()
		# for g in ['/dev/ttyUSB*', '/dev/ttyACM*', "/dev/tty.*", "/dev/cu.*", "/dev/rfcomm*"]:
  #       	baselist += glob.glob(g)
		# ms=QMessageBox(QMessageBox.Warning, "Alert", str(baselist)).exec()
		# self.maincom.write("G28\n".encode()) 


