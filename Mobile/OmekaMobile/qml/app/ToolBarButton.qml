import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "../utils"

/*!Toolbar button*/
Button {
    anchors.verticalCenter: parent.verticalCenter
    anchors.right: parent.right
    height: parent.height
    width: parent.height

    /*!file path to icon image*/
    property string icon
    /*!scale relative to parent dimensions*/
    property real iconScale: .65
    /*!default background color*/
    property color releasedColor: Style.toolBarColor
    /*!pressed background color*/
    property color pressedColor: Style.pressedColor

    /*!Button icon image*/
    BorderImage{
        anchors.centerIn: parent
        width: parent.width * iconScale
        height: parent.height * iconScale
        source: icon
    }

    /*!Custom button style*/
    style: ButtonStyle{
        background: Rectangle{
            implicitWidth: control.width
            implicitHeight: control.height
            radius: 30 * Resolution.scaleRatio
            color: control.pressed ? pressedColor : releasedColor
        }
    }
}