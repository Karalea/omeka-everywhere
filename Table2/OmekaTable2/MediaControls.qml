import QtQuick 2.5
import QtQuick.Controls 1.4
import QtMultimedia 5.5
import "."


Item {
    id: root
    visible: height
    //z: 1
    y: 0//ItemManager.fullScreen ? size.height/2 - height/2 : toolbar.height
    anchors.horizontalCenter: parent.horizontalCenter

    property alias player: scrubber.player
    property var media
    property real scalar
    property Rectangle size

    signal interative();

    //media bindings
    Binding on player { value: media && media.current ? media.current.player : null }
    Binding on size { value: media && media.current ? media.current.background : null }
    Binding on scalar { value: media ? media.scale : 1 }
    Binding on width { value : size ? size.width : 0 }
    Binding on height { value : size ? size.height * scalar : 0 }

    //on touch, toggle between play and pause states
    MouseArea {
        enabled: scrubber.visible && !scrubber.pressed
        anchors.fill: parent
        anchors.margins: 50
        onClicked: {
            if(player.playbackState === MediaPlayer.PlayingState){
                indicator.play = false
                player.pause()
                interative();
            } else {
                indicator.play = true
                player.play()
                interative();
            }
        }
     }

    //playback state indicator
    PlaybackIndicator {
        id: indicator
        anchors.centerIn: parent
        width: 150//Resolution.applyScale(150)
        height: width
    }

    //full screen mode toggle control
//    OmekaToggle {
//       id: toggle
//       anchors.top: parent.top
//       anchors.right: parent.right
//       anchors.margins: 10
//       defaultSource: Style.maximize
//       checkedSource: Style.minimize
//       iconScale: Resolution.scaleRatio
//       onCheckedChanged: ItemManager.fullScreen = checked
//    }

    //playback scrubbing
    Scrubber {
       id: scrubber
       onScrubberInterative: root.interative();

    }
}
