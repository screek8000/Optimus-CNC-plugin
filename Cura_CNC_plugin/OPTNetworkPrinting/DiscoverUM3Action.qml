import UM 1.2 as UM
import Cura 1.0 as Cura

import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import QtQuick.Window 2.1
import QtQuick.Controls.Styles 1.1 

Cura.MachineAction
{
    id: base
    anchors.fill: parent;
    property var selectedPrinter: null
    property bool completeProperties: true
    property var connectingToPrinter: null
    property bool isConnect:false

    Connections
    {
        target: dialog ? dialog : null
        ignoreUnknownSignals: true
        onNextClicked:
        {
            // Connect to the printer if the MachineAction is currently shown
            if(base.parent.wizard == dialog)
            {
                connectToPrinter();
            }
        }
    }

    function connectToPrinter()
    {
        if(base.selectedPrinter && base.completeProperties)
        {
            var printerKey = base.selectedPrinter.getKey()
            if(connectingToPrinter != printerKey) {
                // prevent an infinite loop
                connectingToPrinter = printerKey;
                manager.setKey(printerKey);
                completed();
            }
        }
    }


    Column
    {
        anchors.fill: parent;
        id: discoverUM3Action
        spacing: UM.Theme.getSize("default_margin").height

        SystemPalette { id: palette }
        UM.I18nCatalog { id: catalog; name:"cura" }
        Label
        {
            id: pageTitle
            width: parent.width
            text: catalog.i18nc("@title:window", "Connect to Networked Printer")
            wrapMode: Text.WordWrap
            font.pointSize: 18
        }

 //    Image  
 //   {  
//        id: background  
 //       anchors { top: parent.top; bottom: parent.bottom }  
//        anchors.fill: parent  
//        source: "pics/febtop_logo.png"  
//        fillMode: Image.PreserveAspectCrop  
//    }  


        Label
        {
            id: pageDescription
            width: parent.width
            wrapMode: Text.WordWrap
            text: catalog.i18nc("@label", "To print directly to your printer over the network, please make sure your printer is connected to the network using a network cable or by connecting your printer to your WIFI network.Press 'Connect' Button connect printer.")
        }

          TextField{
                id:ipinput;
                width: 240  
                height:20
                text: "192.168.3.100"  
                font.pointSize: 10  
                focus: true  
                }


            Button
            {
                id: addButton
                text: catalog.i18nc("@action:button", "Connect");
                onClicked:
                {
                    manager.connect(ipinput.text);
                    base.isConnect=manager.isConnect();
                    //manualPrinterDialog.showDialog("", "");
                }
            }

        Column
        {
         Row   //电机、打印机速度相关
         {
          id:controlRow
          visible: (base.isConnect) ? true : false
          spacing: UM.Theme.getSize("default_lining").width
             Button
             {
                id: bnMotoroff
                text: "Motors off"  
                onClicked:
                {
                    manager.motoroff();
                    base.isConnect=manager.isConnect();
                }
             }
             Label{
                id:xy
                text: catalog.i18nc("@label", "XY:")
                anchors.bottom: parent.bottom  
                anchors.bottomMargin: 4  
             }
             SpinBox {
                    id: xySpeed
                    Layout.fillWidth: true
                    minimumValue: 0
                    maximumValue: 10000
                    value: 3000  
                }
             Label{
                id:sp
                text: catalog.i18nc("@label", "mm/min")
                anchors.bottom: parent.bottom  
                anchors.bottomMargin: 4  
              }            
             Label{
                id:z
                text: catalog.i18nc("@label", " Z:")
                anchors.bottom: parent.bottom  
                anchors.bottomMargin: 4  
              }
             SpinBox {
                    id: zSpeed
                    Layout.fillWidth: true
                    minimumValue: 0
                    maximumValue: 10000
                    value: 200
                }

        }
        




        
          Row    //人工输入Gcode相关
            {
            visible: (base.isConnect) ? true : false
            spacing: UM.Theme.getSize("default_lining").width


           TextField{
                id:commandInput;
                width: 240  
                height:20
                text: "Edit Gcode"  
                font.pointSize: 10  
                focus: true  
                }
           Button
            {
                id: upButton
                iconSource:{ source:"pics/febtop_logo.png"}//指定按钮图标  
                text: "send"  
                onClicked:
                {
                    manager.send(commandInput.text+"\n");
                    base.isConnect=manager.isConnect();                    
                }
            }

            }

            Row{
                visible: (base.isConnect) ? true : false
                spacing: UM.Theme.getSize("default_lining").width

                 Column
                 {

                    Button{
                         width: 40;     // 直接指定窗口的宽度
                         height:20;
                         x: 3*width; 
                         text:"Y100"
                        onClicked:{
                                manager.sety("100",xySpeed.value);
                                    }
                            }
                    Button{
                        width: 40;     // 直接指定窗口的宽度
                        height:20;
                        x: 3*width; 
                        text:"Y10"
                        onClicked:{
                                manager.sety("10",xySpeed.value);
                                    }
                        }
                    Button{
                        width: 40;     // 直接指定窗口的宽度
                        height:20;
                        x: 3*width;  
                        text:"Y1"
                        onClicked:{
                                manager.sety("1",xySpeed.value);
                                }
                        }
                    Row{
                        width: parent.width;
                        visible: (base.isConnect) ? true : false
                        spacing: UM.Theme.getSize("default_lining").width
                            Button{
                                width: 40;     // 直接指定窗口的宽度
                                height:20;
                                text:"X-100"
                                onClicked:{
                                    manager.setx("-100",xySpeed.value);
                                }
                                    }
                            Button{
                                width: 40;     // 直接指定窗口的宽度
                                height:20;
                                text:"X-10"
                                onClicked:{
                                    manager.setx("-10",xySpeed.value);
                                        }
                                }
                            Button{
                                width: 40;     // 直接指定窗口的宽度
                                height:20;
                                text:"X-1"
                                onClicked:{
                                    manager.setx("-1",xySpeed.value);
                                        }
                            }
                            Button{
                                width: 40;     // 直接指定窗口的宽度
                                height:20;
                                text:"H"
                                onClicked:{
                                        manager.send("G28\n");
                                    }
                                }
                             Button{
                                width: 40;     // 直接指定窗口的宽度
                                height:20;
                                text:"X1"
                                onClicked:{
                                manager.setx("1",xySpeed.value);
                                }
                                }
                            Button{
                                width: 40;     // 直接指定窗口的宽度
                                height:20;
                                text:"X10"
                                onClicked:{
                                manager.setx("10",xySpeed.value);
                                }
                                }
                            Button{
                                width: 40;     // 直接指定窗口的宽度
                                height:20;
                                text:"X100"
                                onClicked:{
                                manager.setx("100",xySpeed.value);
                                }
                                }
                        }
                    Button{
                        width: 40;     // 直接指定窗口的宽度
                        height:20;
                        x: 3*width; 
                        text:"Y-1"
                        onClicked:{
                                manager.sety("-1",xySpeed.value);
                                }
                        }
                    Button{
                        width: 40;     // 直接指定窗口的宽度
                        height:20;
                        x: 3*width; 
                        text:"Y-10"
                        onClicked:{
                                manager.sety("-10",xySpeed.value);
                                }
                        }
                    Button{
                        width: 40;     // 直接指定窗口的宽度
                        height:20;
                        x: 3*width; 
                        text:"Y-100"
                        onClicked:{
                                manager.sety("-100",xySpeed.value);
                                }
                        }



                 }

             Column
                 { 
                    Button{
                        width: 40;     // 直接指定窗口的宽度
                        height:20;
                        x:7*width;
                        text:"Z100"
                        onClicked:{
                                manager.setz("100",xySpeed.value);
                                }
                        }
                    Button{
                        width: 40;     // 直接指定窗口的宽度
                        height:20;
                        x:7*width;
                        text:"Z10"
                        onClicked:{
                                manager.setz("10",xySpeed.value);
                                }
                        }
                    Button{
                        width: 40;     // 直接指定窗口的宽度
                        height:20;
                        x:7*width;
                        text:"Z1"
                        onClicked:{
                                manager.setz("1",xySpeed.value);
                                }
                        }
                    Button{
                        width: 40;     // 直接指定窗口的宽度
                        height:20;
                        x:7*width;
                        text:"ZH"
                        onClicked:{
                                manager.send("G28 Z\n");
                                }
                        }
                    Button{
                        width: 40;     // 直接指定窗口的宽度
                        height:20;
                        x:7*width;
                        text:"Z-1"
                        onClicked:{
                                manager.setz("-1",xySpeed.value);
                                }
                        }
                    Button{
                        width: 40;     // 直接指定窗口的宽度
                        height:20;
                        x:7*width;
                        text:"Z-10"
                        onClicked:{
                                manager.setz("-10",xySpeed.value);
                                }
                        }
                    Button{
                        width: 40;     // 直接指定窗口的宽度
                        height:20;
                        x:7*width;
                        text:"Z-100"
                        onClicked:{
                                manager.setz("-100",xySpeed.value);
                                }
                        }




                 }


            }

        Row{
            visible: (base.isConnect) ? true : false
            spacing: UM.Theme.getSize("default_lining").width
            Label{
                text:"Heat:"

                anchors.bottom: parent.bottom  
                anchors.bottomMargin: 4  
            }
            Button{
                width:30
                text:"OFF"
                onClicked:{
                    manager.send("M104 T0 S0\n");
                }
            }
            SpinBox {
                    id: heat
                    Layout.fillWidth: true
                    minimumValue: 0
                    maximumValue: 250
                    value: 100 
                }
            Button{
                width:30
                text:"SET"
                onClicked:{
                    manager.send("M104 T0 S" + heat.value + "\n");
                }
            }
            Button{
                text:"Check temp"
                onClicked:{
                    manager.gettemp("M105\n");
                }
            }
        }
        Row{
            visible: (base.isConnect) ? true : false
            spacing: UM.Theme.getSize("default_lining").width
            Label{
                text:" Bed:"

                anchors.bottom: parent.bottom  
                anchors.bottomMargin: 4  
            }
            Button{
                width:30
                text:"OFF"
                onClicked:{
                    manager.send("M140 S0\n");
                }
            }
            SpinBox {
                    id: bed
                    Layout.fillWidth: true
                    minimumValue: 0
                    maximumValue: 250
                    value: 100 
                }
            Button{
                width:30
                text:"SET"
                onClicked:{
                    manager.send("M140 S" + bed.value + "\n");
                }
            }


        }
        Row
        {
            visible: (base.isConnect) ? true : false
            spacing: UM.Theme.getSize("default_lining").width
            Button{
                text:"Extrude"
                    onClicked:{
                        manager.send("G91\nG1 E" + extrude.value + " F" + extrudespeed.value + "\n" + "G90\n");
                    }
            }
            Button{
                text:"Reverse"
                    onClicked:{
                        manager.send("G91\nG1 E-" + extrude.value  + " F" + extrudespeed.value + "\n" + "G90\n");
                    }
            }

        }
        Row{
            visible: (base.isConnect) ? true : false
            spacing: UM.Theme.getSize("default_lining").width

          SpinBox {
                    id: extrude
                    Layout.fillWidth: true
                    minimumValue: 0
                    maximumValue: 1000
                    value: 5.0
                }
            Label{
                text:"mm @"
                anchors.bottom: parent.bottom  
                anchors.bottomMargin: 4  
            }
          SpinBox {
                    id: extrudespeed
                    Layout.fillWidth: true
                    minimumValue: 0
                    maximumValue: 10000
                    value: 100 
                }
            Label{
                text:"mm/min"
                anchors.bottom: parent.bottom  
                anchors.bottomMargin: 4  
            }

        }
   //     ProgressBar{
    //        id:timeProgress
   //         minimumValue: 0;
  //          maximumValue: 100;
   //         value: 40;
   //         width: 150;
   //         height: 20;


  //      }
   // Timer {

   // interval: 2000;

   // running: true;

  //  repeat: true

//    onTriggered: {nowTemp.text = manager.gettempstr()+"°";
 //                 timeProgress.value=manager.gettempstr();


  //  }

 //   }
 //       Label{
 //           id:nowTemp
 //           text:"temp"
 //       }



     }




    }
}