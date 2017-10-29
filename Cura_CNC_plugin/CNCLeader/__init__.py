from . import CNCLeaderAction

from UM.i18n import i18nCatalog
catalog = i18nCatalog("cura")

def getMetaData():
	return{
        "plugin": {
            "name": catalog.i18nc("@label", "Febtop CNC machine actions"),
            "author": "FebTop",
            "version": "1.5",
            "description": catalog.i18nc("@info:whatsthis", "Provides an auto leader to help user control CNC easier"),
            "api": 3
        }	
	}

def register(app):
	return { "machine_action": CNCLeaderAction.CNCLeaderAction()}