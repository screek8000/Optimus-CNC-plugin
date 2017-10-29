# Copyright (c) 2015 Ultimaker B.V.
# Cura is released under the terms of the AGPLv3 or higher.
from . import NetworkPrinterOutputDevicePlugin
from . import DiscoverUM3Action
from UM.i18n import i18nCatalog
catalog = i18nCatalog("cura")

def getMetaData():
    return {
        "plugin": {
            "name": "OPT Network Connection",
            "author": "Ultimaker",
            "description": catalog.i18nc("@info:whatsthis", "Manages network connections to FEBTOP Optimus printers"),
            "version": "1.0",
            "api": 3
        }
    }

def register(app):
    return {  "machine_action": DiscoverUM3Action.DiscoverUM3Action()}