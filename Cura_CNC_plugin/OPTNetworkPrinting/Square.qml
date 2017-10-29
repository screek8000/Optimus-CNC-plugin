import QtQuick 2.0

Rectangle {
    id: rootframe
    width: 78 ; height: 78
    color: "green"
    border.color: Qt.lighter(color)
    border.width: mousearse.containsMouse ? 2.0 : 0.0

    //property alias source: pic.source  //对外图片接口
    property alias text: lbText.text   //对外接口
    signal clicked                      //对外信号

    Item{
        width:48 ; height: 48
        anchors.centerIn: rootframe
        Image{
             id:pic
             anchors.centerIn: parent
             source:"2.png" //请使用source接口设置
             smooth: true
             width: 32
             height: 32
        }

        Text{
            id:lbText
            anchors.top: pic.bottom
            anchors.topMargin: 3
            font.pixelSize: 16
            color:"#FFFFFF"
            style: Text.Sunken; styleColor: "#AAAAAA"
            anchors.horizontalCenter: pic.horizontalCenter
        }
    }

    //MouseArea
    MouseArea{
        id:mousearse
        anchors.fill: parent
        drag.target: rootframe
        drag.maximumX: parent.parent.parent.width - parent.width  //仅仅为了演示，实际请不要这样计算
        drag.maximumY: parent.parent.parent.height - parent.height
        drag.axis: drag.XAndYAxis

        hoverEnabled: true //处理mouse over事件，也可以通过state状态来控制
        acceptedButtons: Qt.LeftButton

        onClicked:{
            rootframe.clicked()
        }
    }

}
