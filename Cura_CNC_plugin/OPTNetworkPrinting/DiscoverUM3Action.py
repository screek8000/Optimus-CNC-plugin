from cura.MachineAction import MachineAction

from UM.Application import Application
from UM.PluginRegistry import PluginRegistry
from UM.Logger import Logger

#from PyQt5.QtCore import pyqtSignal, pyqtProperty, pyqtSlot, QUrl, QObject
from PyQt5.QtQml import QQmlComponent, QQmlContext
from PyQt5.QtGui import *  
from PyQt5.QtCore import *  
from PyQt5.QtWidgets import *

import os.path

import time

import socket

import sys

import urllib

# import thread

import threading

import traceback

from UM.i18n import i18nCatalog


catalog = i18nCatalog("cura")
class DiscoverUM3Action(MachineAction):
    global tmp
    def __init__(self):
        super().__init__("DiscoverOPTAction", catalog.i18nc("@action","Connect OPT Network"))
        self._qml_url = "DiscoverUM3Action.qml"


        self.s=None
        self.isconnect=0
        self.thistemp=""



    @pyqtSlot(str)
    def connect(self,nowip):
        try:  
            self.s=socket.socket(socket.AF_INET,socket.SOCK_STREAM)
            self.s.connect((nowip.encode(),8080))
            self.isconnect=1
#            s.send(str.encode())
        except Exception as e:
            self.isconnect=0
            msg_box = QMessageBox(QMessageBox.Warning, "Alert", e.strerror)
           # msg_box.show()  
            msg_box.exec()
        msg_box = QMessageBox(QMessageBox.Warning, "Alert", "connect success"+str(self.isconnect))
        msg_box.exec()
     #   s.close()
        pass

    @pyqtSlot(str)
    def send(self,str):
        try:
            msg_box2 = QMessageBox(QMessageBox.Warning, "Alert", "we send"+str)
            msg_box2.exec()  
            self.s.send(str.encode())
            self.isconnect=1  
        except Exception as e:
            self.isconnect=0
            msg_box2 = QMessageBox(QMessageBox.Warning, "Alert", e.strerror)
            msg_box2.exec()
        pass
    @pyqtSlot(str)
    def gettemp(self,str):
        try:
            # msg_box2 = QMessageBox(QMessageBox.Warning, "Alert", "we send"+str)
            # msg_box2.exec()  
            self.s.send(str.encode())
            info=self.s.makefile()
            # line=info.readline()
            while True:
                line=info.readline()
                if line.find("T:")!=-1:
                    temp=line[line.index("T:"):]
                    nowtemp=temp[2 + temp.index("T:"):-1 + temp.index("B:")]
                    tmp=nowtemp.split('/')[0]
                    msg = QMessageBox(QMessageBox.Warning, "Alert", tmp+"°").exec()
                    break
            # temp=szBuf.decode('utf-8')[9:14]
            # msg_box3 = QMessageBox(QMessageBox.Warning, "Alert", "Now temp is:"+temp+"°")
            # msg_box3.exec()
            self.isconnect=1  
        except Exception as e:
            self.isconnect=0
            msg_box2 = QMessageBox(QMessageBox.Warning, "Alert", e.strerror)
            msg_box2.exec()

        # pass
    @pyqtSlot(result=str)
    def gettempstr(self):
        # try:




            # msg_box2 = QMessageBox(QMessageBox.Warning, "Alert", "we send"+self.thistemp)
            # msg_box2.exec()  

            self.s.send("M105\n".encode())
            self.isconnect=1  
            info=self.mainsocket.makefile()
            for line in info:
                line=info.readline()
                msg = QMessageBox(QMessageBox.Warning, "Alert", line).exec()
            # szBuf = self.s.recv(1024)

            if szBuf.decode('utf-8').index("T:")>0:
                temp=szBuf.decode('utf-8')[szBuf.decode('utf-8').index("T:"):]
                nowtemp=temp[2 + temp.index("T:"):-1 + temp.index("B:")]
                    # return szBuf.decode('utf-8')+temp
            tmp=nowtemp.split('/')[0]

            # if nowtemp.split('/')[0]!="":
            #     returntemp=nowtemp.split('/')[0]
            #     self.thistemp=nowtemp.split('/')[0]
            # else:
            #     returntemp=self.thistemp

            # temp=szBuf.decode('utf-8')[9:14]
            return tmp

        # except Exception as e:
            # msg_box2 = QMessageBox(QMessageBox.Warning, "Alert", e.strerror)
            # msg_box2.exec()
            # self.isconnect=0

        # pass
    @pyqtSlot(result=str)
    def getthreadtemp(self):

        try:
            t = threading.Thread(target=gettempstr).start()
            # t.start()
        except Exception as e:
            return e.strerror
            # msg_box3 = QMessageBox(QMessageBox.Warning, "Alert", e.strerror)
            # msg_box3.exec()
            # return tmp
        # pass


    @pyqtSlot()
    def motoroff(self):
        try:
            self.s.send("M84\n".encode())
        except Exception as e:
            self.isconnect=0
            msg_box3 = QMessageBox(QMessageBox.Warning, "Alert", e.strerror)
            msg_box3.exec()


    @pyqtSlot()
    def resetsaa(self):
        try:
            mess=QMessageBox(QMessageBox.Warning, "Alert", "e.strerror").exec()
            self.s.send("G28\n".encode())
        except Exception as e:
            self.isconnect=0
            msg_box3 = QMessageBox(QMessageBox.Warning, "Alert", e.strerror)
            msg_box3.exec()

    @pyqtSlot(str,str)
    def setx(self,distence,speed):
        try: 
            # msg_box2 = QMessageBox(QMessageBox.Warning, "Alert", "we send"+distence+"and"+speed)
            # msg_box2.exec()  
            self.s.send(("G91\nG1 X" + distence + " F" + speed + "\n" + "G90\n").encode())
        except Exception as e:
            self.isconnect=0
            msg_box2 = QMessageBox(QMessageBox.Warning, "Alert", e.strerror)
            msg_box2.exec()

        pass

    @pyqtSlot(str,str)
    def sety(self,distences,speeds):
        try:  
            self.s.send(("G91\nG1 Y" + distences + " F" + speeds + "\n" + "G90\n").encode())
        except Exception as e:
            self.isconnect=0
            msg_box2 = QMessageBox(QMessageBox.Warning, "Alert", e.strerror)
            msg_box2.exec()

        pass


    @pyqtSlot(str,str)
    def setz(self,distencez,speedz):
        try:  
            self.s.send(("G91\nG1 Z" + distencez + " F" + speedz + "\n" + "G90\n").encode())
        except Exception as e:
            self.isconnect=0
            msg_box2 = QMessageBox(QMessageBox.Warning, "Alert", e.strerror)
            msg_box2.exec()

        pass

    # @pyqtSlot(str, str)
    # def setManualPrinter(self, key, address):
    #     if key != "":
    #         # This manual printer replaces a current manual printer
    #         self._network_plugin.removeManualPrinter(key)

    #     if address != "":
    #         self._network_plugin.addManualPrinter(address)

    # def _onPrinterDiscoveryChanged(self, *args):
    #     self._last_zeroconf_event_time = time.time()
    #     self.printersChanged.emit()

    # @pyqtProperty("QVariantList", notify = printersChanged)
    # def foundDevices(self):
    #     if self._network_plugin:
    #         if Application.getInstance().getGlobalContainerStack():
    #             global_printer_type = Application.getInstance().getGlobalContainerStack().getBottom().getId()
    #         else:
    #             global_printer_type = "unknown"

    #         printers = list(self._network_plugin.getPrinters().values())
    #         # TODO; There are still some testing printers that don't have a correct printer type, so don't filter out unkown ones just yet.
    #         printers = [printer for printer in printers if printer.printerType == global_printer_type or printer.printerType == "unknown"]
    #         printers.sort(key = lambda k: k.name)
    #         return printers
    #     else:
    #         return []

    # @pyqtSlot(str)
    # def setKey(self, key):
    #     global_container_stack = Application.getInstance().getGlobalContainerStack()
    #     if global_container_stack:
    #         meta_data = global_container_stack.getMetaData()
    #         if "um_network_key" in meta_data:
    #             global_container_stack.setMetaDataEntry("um_network_key", key)
    #             # Delete old authentication data.
    #             global_container_stack.removeMetaDataEntry("network_authentication_id")
    #             global_container_stack.removeMetaDataEntry("network_authentication_key")
    #         else:
    #             global_container_stack.addMetaDataEntry("um_network_key", key)

    #     if self._network_plugin:
    #         # Ensure that the connection states are refreshed.
    #         self._network_plugin.reCheckConnections()

    @pyqtSlot(result = int)
    def isConnect(self):
        try:
            return self.isconnect
            pass
        except Exception as e:
            msg_box = QMessageBox(QMessageBox.Warning, "Alert", e.strerror)
            msg_box.exec()

        pass

    # @pyqtSlot(result = str)
    # def getStoredKey(self):
    #     global_container_stack = Application.getInstance().getGlobalContainerStack()
    #     if global_container_stack:
    #         meta_data = global_container_stack.getMetaData()
    #         if "um_network_key" in meta_data:
    #             return global_container_stack.getMetaDataEntry("um_network_key")

    #     return ""

    # @pyqtSlot()
    # def loadConfigurationFromPrinter(self):
    #     machine_manager = Application.getInstance().getMachineManager()
    #     hotend_ids = machine_manager.printerOutputDevices[0].hotendIds
    #     for index in range(len(hotend_ids)):
    #         machine_manager.printerOutputDevices[0].hotendIdChanged.emit(index, hotend_ids[index])
    #     material_ids = machine_manager.printerOutputDevices[0].materialIds
    #     for index in range(len(material_ids)):
    #         machine_manager.printerOutputDevices[0].materialIdChanged.emit(index, material_ids[index])

    # def _createAdditionalComponentsView(self):
    #     Logger.log("d", "Creating additional ui components for UM3.")
    #     path = QUrl.fromLocalFile(os.path.join(PluginRegistry.getInstance().getPluginPath("UM3NetworkPrinting"), "UM3InfoComponents.qml"))
    #     self.__additional_component = QQmlComponent(Application.getInstance()._engine, path)

    #     # We need access to engine (although technically we can't)
    #     self.__additional_components_context = QQmlContext(Application.getInstance()._engine.rootContext())  #Application.getInstance()._engine可能是QQuickView()
    #     self.__additional_components_context.setContextProperty("manager", self)

    #     self.__additional_components_view = self.__additional_component.create(self.__additional_components_context)
    #     if not self.__additional_components_view:
    #         Logger.log("w", "Could not create ui components for UM3.")
    #         return

    #     Application.getInstance().addAdditionalComponent("monitorButtons", self.__additional_components_view.findChild(QObject, "networkPrinterConnectButton"))
    #     Application.getInstance().addAdditionalComponent("machinesDetailPane", self.__additional_components_view.findChild(QObject, "networkPrinterConnectionInfo"))
