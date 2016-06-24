import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "../../home"
import "../../base"
import "../../../utils"

/*!User settings*/
Item {

    Column {
        anchors.fill: parent
        spacing: 0

        /*!Settings header and back button*/
        OmekaToolBar {
            id: bar

            OmekaText {
                anchors.centerIn: parent
                text: "settings"
                _font: Style.titleFont
            }

            OmekaButton {
                id: back
                icon: Style.back
                onClicked: if(homeStack) homeStack.pop()
            }
        }

        /*!Scrollable list of settings*/
        OmekaScrollView {
            width: parent.width
            height: parent.height - bar.height

            ListView {
                anchors.fill: parent
                model: SettingsModel{}
                delegate: SettingsDelegate{}
                spacing: Resolution.applyScale(150)
            }
        }
    }
}
