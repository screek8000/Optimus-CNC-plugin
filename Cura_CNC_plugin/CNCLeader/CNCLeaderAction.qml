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
    property bool checkMode:true
    property int nowStep:0
    property var filelist:[]


     AnimatedImage   
    { 
        id: background
         visible:(base.nowStep!=3)?true:false
        x:(parent.width-width)/2
 //       anchors { top: parent.top; bottom: parent.bottom }  
//        anchors.fill: parent  
        source: "pics/febtop_logo.png"  
 //       fillMode: Image.PreserveAspectCrop  
    }  
    AnimatedImage
    {
      visible:(base.nowStep==3)?true:false
      x:(parent.width-width)/2
      source: "pics/act_change_cutter.gif"  

    }

    Label{
        id: stepDescription
        wrapMode: Text.WordWrap
        x:parent.width/2-background.width/2
        y:background.y+background.height+10
        text:"Step1:Connect our CNC Machine.\nPress Connect button to connect the Machine.\n"
      }

    TextField{
        id:ipinput;
         visible:(base.nowStep==0) ? true : false
        x:stepDescription.x
        y:stepDescription.y+stepDescription.height
        width: 240  
        height:20
        text: "192.168.3.100"  
        font.pointSize: 10  
        focus: true  
      }



    ExclusiveGroup{
        id: mos;
    }



    RadioButton{
        id: checkCirle;
         visible:(base.nowStep==2) ? true : false
        x:stepDescription.x
        y:stepDescription.y+stepDescription.height
        text:"Grid";
        exclusiveGroup: mos;
        activeFocusOnPress: true;
        onClicked: base.checkMode = true;
    }
    RadioButton{
        id: firefox;
        visible:(base.nowStep==2) ? true : false
        x:checkCirle.x+checkCirle.width
        y:checkCirle.y
        text:"Three-Points";
        exclusiveGroup: mos;

        onClicked: base.checkMode = false;

    }
    Row{
        visible:(base.nowStep==2) ? true : false
        spacing: UM.Theme.getSize("default_lining").width
        y:checkCirle.y+checkCirle.height
        x:checkCirle.x  
        Label{
          anchors.bottom: parent.bottom  
          anchors.bottomMargin: 4  
          text:base.checkMode ? "R: " :"X: "
        }
        TextField{
         id:materialSize;
         width: 50  
         height:20
         text: "40.0"  
         font.pointSize: 10  
         focus: true  
          }
        Label{
          anchors.bottom: parent.bottom  
          anchors.bottomMargin: 4  
          text:base.checkMode ? "H: " :"Y: "
        }
        TextField{
         id:materialHight;
         width: 50
         height:20
         text: "19.3"  
         font.pointSize: 10  
         focus: true  
          }
        Label{
          visible:base.checkMode ? false :true
          anchors.bottom: parent.bottom  
          anchors.bottomMargin: 4  
          text:"Z: "
        }
        TextField{
         visible:base.checkMode ? false :true
         id:zHight;
         width: 50
         height:20
         text: "20"  
         font.pointSize: 10  
         focus: true  
          }

      }




      Button 
      {
        visible:(base.isConnect) ? false : true
        id:btn_connect
        text:"Connect"
        x:parent.width-width
        y:parent.height-height
        onClicked:{
          stepDescription.text=manager.connect(ipinput.text);
          base.isConnect=manager.connectCondition();
          base.nowStep=manager.getStep();
        }

      }

       Button 
      {
        visible:base.isConnect
        id:btn_next
        text:"Next"
        x:parent.width-width
        y:parent.height-height
        onClicked:{
          base.isConnect=manager.connectCondition();
          if(base.isConnect)
          {
            if(base.nowStep==2)manager.setMaterialSize(materialSize.text,materialHight.text,zHight.text,base.checkMode);
            if(base.nowStep==4)manager.getFile(base.filelist[listview.currentIndex]+"");
            if(base.nowStep==5)manager.getFile(base.filelist[listview.currentIndex]+"");
            manager.nextStep();
            base.nowStep=manager.getStep();
            if(base.nowStep==4)btn_next.enabled=false;
            stepDescription.text=manager.getStepHelp();
          }
          base.isConnect=manager.connectCondition();
        }

      }

      Button 
      {
        visible:base.isConnect
        id:btn_back
        text:"Back"
        x:parent.width-2*width
        y:parent.height-height
        onClicked:{
          base.isConnect=manager.connectCondition();  
          manager.backStep();       
          base.nowStep=manager.getStep();
          stepDescription.text=manager.getStepHelp();
        }

      }

      Row{
          id:controlButton
          visible: (base.nowStep==3) ? true : false
          spacing: UM.Theme.getSize("default_lining").width
          x:parent.width/2-background.width
          y:stepDescription.y+stepDescription.height    
                 Column
                 {

                    Button{
                         width: 40;     // 直接指定窗口的宽度
                         height:20;
                         x: 3*width; 
                         text:"Y100"
                        onClicked:{
                                manager.send("G91\nG1 Y100 F1000\n" + "G90\n");
                                    }
                            }
                    Button{
                        width: 40;     // 直接指定窗口的宽度
                        height:20;
                        x: 3*width; 
                        text:"Y10"
                        onClicked:{
                                manager.send("G91\nG1 Y10 F1000\n" + "G90\n");
                                    }
                        }
                    Button{
                        width: 40;     // 直接指定窗口的宽度
                        height:20;
                        x: 3*width;  
                        text:"Y1"
                        onClicked:{
                                manager.send("G91\nG1 Y1 F1000\n" + "G90\n");
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
                                manager.send("G91\nG1 X-100 F1000\n" + "G90\n");
                                }
                                    }
                            Button{
                                width: 40;     // 直接指定窗口的宽度
                                height:20;
                                text:"X-10"
                                onClicked:{
                                manager.send("G91\nG1 X-10 F1000\n" + "G90\n");
                                        }
                                }
                            Button{
                                width: 40;     // 直接指定窗口的宽度
                                height:20;
                                text:"X-1"
                                onClicked:{
                                manager.send("G91\nG1 X-1 F1000\n" + "G90\n");
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
                                manager.send("G91\nG1 X1 F1000\n" + "G90\n");
                                }
                                }
                            Button{
                                width: 40;     // 直接指定窗口的宽度
                                height:20;
                                text:"X10"
                                onClicked:{
                                manager.send("G91\nG1 X10 F1000\n" + "G90\n");
                                }
                                }
                            Button{
                                width: 40;     // 直接指定窗口的宽度
                                height:20;
                                text:"X100"
                                onClicked:{
                                manager.send("G91\nG1 X100 F1000\n" + "G90\n");
                                }
                                }
                        }
                    Button{
                        width: 40;     // 直接指定窗口的宽度
                        height:20;
                        x: 3*width; 
                        text:"Y-1"
                        onClicked:{
                                manager.send("G91\nG1 Y-1 F1000\n" + "G90\n");
                                }
                        }
                    Button{
                        width: 40;     // 直接指定窗口的宽度
                        height:20;
                        x: 3*width; 
                        text:"Y-10"
                        onClicked:{
                                manager.send("G91\nG1 Y-10 F1000\n" + "G90\n");
                                }
                        }
                    Button{
                        width: 40;     // 直接指定窗口的宽度
                        height:20;
                        x: 3*width; 
                        text:"Y-100"
                        onClicked:{
                                manager.send("G91\nG1 Y-100 F1000\n" + "G90\n");
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
                                manager.send("G91\nG1 Z100 F1000\n" + "G90\n");
                                }
                        }
                    Button{
                        width: 40;     // 直接指定窗口的宽度
                        height:20;
                        x:7*width;
                        text:"Z10"
                        onClicked:{
                                manager.send("G91\nG1 Z10 F1000\n" + "G90\n");
                                }
                        }
                    Button{
                        width: 40;     // 直接指定窗口的宽度
                        height:20;
                        x:7*width;
                        text:"Z1"
                        onClicked:{
                                manager.send("G91\nG1 Z1 F1000\n" + "G90\n");
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
                                manager.send("G91\nG1 Z-1 F1000\n" + "G90\n");
                                }
                        }
                    Button{
                        width: 40;     // 直接指定窗口的宽度
                        height:20;
                        x:7*width;
                        text:"Z-10"
                        onClicked:{
                                manager.send("G91\nG1 Z-10 F1000\n" + "G90\n");
                                }
                        }
                    Button{
                        width: 40;     // 直接指定窗口的宽度
                        height:20;
                        x:7*width;
                        text:"Z-100"
                        onClicked:{
                                manager.send("G91\nG1 Z-100 F1000\n" + "G90\n");
                                }
                        }

                 }
            }

      Button{
        id:btn_sd
        visible: (base.nowStep>=4) ? true : false
        y:stepDescription.y+stepDescription.height
        text:"SD Card"
        onClicked:{
           base.filelist= manager.foundFile(1);
     //      btn_next.enabled=true;
           changeMode();
        }
      }

        Button{
        id:btn_u
        visible: (base.nowStep>=4) ? true : false
        x:btn_sd.x+btn_sd.width
        y:stepDescription.y+stepDescription.height
        text:"U-Disk"
        onClicked:{
           base.filelist= manager.foundFile(2);
     //      btn_next.enabled=true;
           changeMode();
        }
      }


        Button{
        id:btn_reZ
        visible: (base.nowStep==5) ? true : false
        x:btn_u.x+btn_u.width
        y:stepDescription.y+stepDescription.height
        text:"HomeZ"
        onClicked:{
           manager.send("G28 Z\n");
        }
      }

        Button{
        id:btn_reXY
        visible: (base.nowStep==5) ? true : false
        x:btn_reZ.x+btn_reZ.width
        y:stepDescription.y+stepDescription.height
        text:"CenterXY"
        onClicked:{
          
           manager.send("G1 X"+materialSize.text/2+"Y"+materialSize.text/2+"\n");
        }
      }



      Button{
        id:btn_checkZ
        visible: (base.nowStep==5) ? true : false
        x:btn_reXY.x+btn_reXY.width
        y:stepDescription.y+stepDescription.height
        text:"CheckCutter"
        onClicked:{
           manager.send("G30 Z0\n");
        }
      } 



      Button{
        id:btn_setZ
        visible: (base.nowStep==5) ? true : false
        x:btn_checkZ.x+btn_checkZ.width
        y:stepDescription.y+stepDescription.height
        text:"SetZ"
        onClicked:{
        stepDescription.text="G92 Z"+commandInput.text+"\n";
           manager.send("G92 Z"+commandInput.text+"\n");
        }
      } 

      Label{
        id:a
        visible: (base.nowStep==5) ? true : false
        x:btn_setZ.x+btn_setZ.width
        y:stepDescription.y+stepDescription.height
        text:" AT:"
        anchors.bottom: btn_setZ.bottom  
        anchors.bottomMargin: 4  
      }

      TextField{
        visible: (base.nowStep==5) ? true : false
        id:commandInput;
        width: 30
        height:20
        x:a.x+a.width
        y:stepDescription.y+stepDescription.height
        text: "0"  
        font.pointSize: 10  
        focus: true  
       }


     function changeMode()
    {
         testModel.clear();
          for(var i in base.filelist)
         {
            testModel.append({name: base.filelist[i]});
         }
    }


ListView {
    visible: (base.nowStep>=4) ? true : false
    width: parent.width
    height: 100
    y:btn_sd.y+btn_sd.height*2
    id: listview
    model: ListModel {id: testModel}
    highlightFollowsCurrentItem: true;  
    delegate:contactsDelegate 
    currentIndex: -1;
     Component {
         id: contactsDelegate
         Rectangle {
             id: wrapper
             width: 180
             height: contactInfo.height
             color: ListView.isCurrentItem ? "blue" : "white"
             Text {
                 id: contactInfo;
                 text: name;
                 font.pixelSize: 18;
                 color: wrapper.ListView.isCurrentItem ? "white" : "black";
             }
            MouseArea
            {
                anchors.fill: parent;
                onClicked:
                 {
                    btn_next.enabled=true;
                    //stepDescription.text= base.filelist[index];
                    listview.currentIndex = index;
                }
            }
         }
     } 

}




  }