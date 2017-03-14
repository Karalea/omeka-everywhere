import QtQuick 2.5
import QtQuick.Controls 1.4

Row {
    width: parent.width
    height: 40
    spacing: 20
    property alias operation: button.text

    signal submit(var entry);

    Button {
        id: button
        width: 100
        height: parent.height
        onClicked: {
            submit(text.text)
            text.text = "";
        }
    }
    TextField {
        id: text
        width: parent.width - button.width - 20
        height: parent.height
    }
}
