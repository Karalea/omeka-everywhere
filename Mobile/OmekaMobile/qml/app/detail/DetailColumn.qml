import QtQuick 2.5
import "viewers"
import "../base"
import "../../utils"

/*!
    \qmltype DetailColumn

    DetailColumn is the vertical layout container for detail items.
*/
ScaleColumn {
    y: parent.margins
    width: parent.width - 2 * parent.margins
    height: childrenRect.height
    anchors.horizontalCenter: parent.horizontalCenter

    /*! \qmlproperty
        Currently selected item
    */
    property variant item: ItemManager.current

    //actions
    toolbar: DetailToolbar { id: bar }

    //media view
    viewer: MediaViewer {
        id: media
        Binding on source { when: item; value: item.media[0] }
        Binding on type { when: item; value: item.mediaTypes[0] }
    }

    //info panel
    info: OmekaText {
        id: info
        width: parent.width
        height: contentHeight
        _font: Style.metadataFont
        Binding on text { when: item; value: metadata() }
    }

    //format metadata
    function metadata() {
        var metadata = ""
        if(item.metadata){
            var element
            for(var i=0; i<item.metadata.count; i++) {
                element = item.metadata.get(i);
                metadata += "<p><b>"+element.element.name+"</b><br/>"+element.text+"</p>"
            }
        }
        return metadata
    }
}
