import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0
import "."

import "settings.js" as Settings


    Item
    {
        id: root
        width: 158; height: img.height
        property var itemData: ({})
        property var itemResult
        property var title
        property string source:img.source
        property int file_id : -1
        property bool topScreen: false

        signal imageDragged();

        signal createImage(string source, int imageX, int imageY, int imageRotation, int imageWidth, int imageHeight);
        //scale: changeScale()
        //z: changeZ();//1 - Math.abs(index - list.currentIndex)
        //visible: Math.abs(index - list.currentIndex) < 3 || (list.count + index - list.currentIndex) < 3 ||
        //         (list.count - index + list.currentIndex) < 3
        //opacity: Math.abs(index - list.currentIndex) < 3 || (list.count + index - list.currentIndex) < 3 ||
        //         (list.count - index + list.currentIndex) < 3 ? 1.0 : 0.0
        Behavior on opacity {
            NumberAnimation
            {
                duration: 500
            }
        }
        property bool inScene: false

        function imageInScene()
        {
            //inScene = true;
            ItemManager.current = itemData;
            ItemManager.selectedItems.push(itemData);
        }
        function imageRemovedFromScene(source)
        {
            console.log("ImageViewer imageRemovedFromScene(source)= ", source)
            //inScene = false;
        }


        //Component.onCompleted:
        onItemResultChanged:
        {
            itemData.id = String(itemResult.item)
            console.log("itemData.id = ", itemData.id)
            itemData.fileCount = parseInt(itemResult.file_count)
            itemData.metadata = itemResult.metadata

            itemData.media = []
            itemData.mediaTypes = []

            //setInfo();
            Omeka.getFiles(itemData.id, root)

        }

        function setInfo()
        {
            file_id = Math.floor(randomizeId())
            console.log("file_id  = ", file_id )
            Omeka.getFiles(file_id, root)

        }

        Connections {
            target: Omeka
            onRequestComplete: {
                if(result.context === root)
                {
                    console.log("thum = ", result.thumb)

                    itemData.thumb = result.thumb

                    itemData.media.push(result.media)
                    itemData.mediaTypes.push(result.media_type)

//                    if(itemData.media.length === itemData.fileCount)
//                    {
                        img.source = itemData.thumb
                        img_id.text = itemData.id //test
                        //target = null
//                    }
                }
            }
        }

        Image
        {
            id: bkg
            source: "content/POI/_Image_.png"
            anchors.fill: img
            anchors.margins: -10
            visible: img.progress >= 1
            //rotation: topScreen ? 180 : 0
        }
        Image
        {
            id: img
            //anchors.fill: parent
            width: root.width
            fillMode: Image.PreserveAspectFit
            //rotation: topScreen ? 180 : 0
            Text
            {
                id: img_id
                color: "red"
                anchors.centerIn: parent
            }
        }

        MultiPointTouchArea
        {
            id: touch_area

            //anchors.fill: img

            width: img.width//400
            height: img.height//400

            property bool creatingImage: false
            property int touchId: -1


            property int bottomFlickMax: 500

            property var dragAmountsY: ({})
            property var dragAmountsX: ({})
            property var dragImages: ({})

            onTouchUpdated:
            {
                var updatedCreatedImage = false;
                for(var i = 0; i < touchPoints.length; i++)
                {
                    var touchPoint = touchPoints[i];

                    var deltaX = touchPoint.x - touchPoint.previousX;
                    var deltaY = touchPoint.y - touchPoint.previousY;

                    if(!creatingImage)
                    {

                        //if(touchPoint.y < bottomFlickMax + 100)
                        //{
                            if(!dragAmountsY[touchPoint.pointId])
                            {
                                dragAmountsY[touchPoint.pointId] = 0.0;
                                dragImages[touchPoint.pointId] = root;
                            }
                            if(!dragAmountsX[touchPoint.pointId])
                            {
                                dragAmountsX[touchPoint.pointId] = 0.0;
                            }

                            var dragY = dragAmountsY[touchPoint.pointId] ?
                                        dragAmountsY[touchPoint.pointId] : 0.0

                            dragAmountsY[touchPoint.pointId] = dragY + deltaY;



                            var dragX = dragAmountsX[touchPoint.pointId] ?
                                        dragAmountsX[touchPoint.pointId] : 0.0

                            dragAmountsX[touchPoint.pointId] = dragX + deltaX;

                            if(dragAmountsY[touchPoint.pointId] < -100 || dragAmountsY[touchPoint.pointId] > 100 ||
                               dragAmountsX[touchPoint.pointId] < -100 || dragAmountsX[touchPoint.pointId] > 100)
                            {
                                var imageSource = dragImages[touchPoint.pointId].source;
                                //var item = dragImages[touchPoint.pointId];

                                if(imageSource !== "" &&
                                        (!root.inScene))
                                {
                                    creatingImage = true;

                                    touchId = touchPoint.pointId;

                                    selected_image.source = imageSource;

                                    //selected_image.title = title;

                                    root.imageInScene();
                                    //imageItems.push(item);

                                    selected_image.screenX = touchPoint.x - selected_image.width / 2;
                                    selected_image.screenY = touchPoint.y - selected_image.height / 2;
                                    selected_image.width = 247;
                                    console.log("touchPoint.x = ", touchPoint.x, " touchPoint.y = ", touchPoint.y)
                                    updatedCreatedImage = true;

                                    root.imageDragged();

                                    break;
                                }
                            }
                        //}
                    }
                    else
                    {
                        if(touchPoint.pointId === touchId && touchPoint.pressed)
                        {
                            selected_image.screenX = touchPoint.x - selected_image.width / 2;
                            selected_image.screenY = touchPoint.y - selected_image.height / 2;
                            selected_image.width = 247;
                            updatedCreatedImage = true;
                        }
                    }
                }

                if(creatingImage && !updatedCreatedImage)
                {
                    creatingImage = false;

                    var imageCenterX = 0;
                    var imageCenterY = 0;
                    var rotation = 0;

                    if(root.topScreen)
                    {
                        imageCenterX = -selected_image.x - selected_image.width / 2// + root.x + touch_area.x;//
                        imageCenterY = -selected_image.y - selected_image.height // / 2//1080 + (selected_image.y); // selected_image.height / 2 + root.y + touch_area.y;
                        rotation = 180;
                    }
                    else
                    {
                        imageCenterX = selected_image.x//- selected_image.width / 2; //selected_image.width / 2 + root.x + touch_area.x;//
                        imageCenterY = selected_image.y// - selected_image.height / 2; // selected_image.height / 2 + root.y + touch_area.y;
                        rotation = 0;
                    }
                    console.log("selected_image.x = ", selected_image.x, " selected_image.y = ", selected_image.y)

                    root.createImage(selected_image.source, imageCenterX, imageCenterY, rotation,
                                     selected_image.width, selected_image.height);
                }

                var dragEntries = Object.getOwnPropertyNames(dragAmountsY);
                for (var index = 0; index < dragEntries.length; index++)
                {
                    var touchEntry = dragEntries[index];
                    var updatedEntry = false;
                    for(var j = 0; j < touchPoints.length; j++)
                    {
                        if(touchPoints[j].pointId == touchEntry)
                        {
                            updatedEntry = true;
                        }
                    }

                    if(!updatedEntry)
                    {
                        dragAmountsY[touchEntry] = 0.0;
                        dragAmountsX[touchEntry] = 0.0;
                    }
                }
            }

            Image
            {
                id: selected_image

                visible: touch_area.creatingImage

                source: ""
                height: root.imageHeight
                fillMode: Image.PreserveAspectFit

                property int screenX: 0
                property int screenY: 0

                x: screenX// - width / 2
                y: screenY// - height / 2
                z: 10
            }


                    Rectangle
                    {
                        anchors.fill: parent
                        color: "red"
                        opacity: 0.5
                        visible: parent.enabled && Settings.DEBUG_VIEW
                    }
        }

        //load indicator
        OmekaIndicator {
            scale: 2
            running: img.progress < 1
        }
    }
