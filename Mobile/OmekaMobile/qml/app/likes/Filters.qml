import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "../base"
import "../../utils"

Item {
    id: root
    width: parent.width
    height: list.height
    clip: true
    state: "close"

    property var model: ["all", "collection 1", "collection 2"]
    property var verticalOffset: list.height + list.y

    //prevent multiple selections
    ExclusiveGroup {
        id: group
    }

    //filter list
    ListView {
        id: list
        width: parent.width
        height: childrenRect.height
        spacing: Resolution.applyScale(-6)
        model: root.model
        delegate: delegate
    }

    //filter options
    Component {
        id: delegate
        Button {
            width: parent.width
            height: Resolution.applyScale(150)
            text: list.model[index]
            checkable: true
            exclusiveGroup: group

            style: ButtonStyle {
                background: Rectangle {
                    border.color: Style.color1
                    border.width: Resolution.applyScale(6)
                    color: Style.color3
                }
                label: OmekaText {
                    text: control.text
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    _font: Style.headerFont
                }
            }
        }
    }

    //open/close states
    states: [
        State {
            name: "open"
            AnchorChanges { target: list; anchors.bottom: root.bottom }
            PropertyChanges { target: root; opacity: 1 }
        },
        State {
            name: "close"
            AnchorChanges { target: list; anchors.bottom: root.top }
            PropertyChanges { target: root; opacity: 0 }
        }
    ]

    //animations
    transitions: Transition {
        AnchorAnimation { duration: 250; easing.type: Easing.OutQuad }
        PropertyAnimation { target: root; property: "opacity"; duration:500; easing.type: Easing.OutQuad }
    }
}