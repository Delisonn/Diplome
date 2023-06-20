import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.15

Rectangle{ 
    id: outerRectangle
    color: outerRectangle.checked ? "#53538f" : "#363654"
    border.width: 2
    // border.color: "#262654"
    radius: 20
    opacity: mouseArea.containsMouse ? 0.5 : 1

    property bool checked: false
    property bool customCheckBehaviour: false
    property string line: ""
    property string iconSource: "../../images/svg_images/cart_icon.svg"

    signal clicked

    Image{
        id: image
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        visible: true
        source: iconSource
        height: parent.height * 0.5
        width: parent.width * 0.7
    }

    Label{
        id: innerLabel
        visible: true
        anchors.top: image.bottom
        anchors.horizontalCenter: image.horizontalCenter
        anchors.topMargin: 7
        color: outerRectangle.checked ? "#ffffff" : "#949494"
        text: line
        font.pointSize: 14

    }

    MouseArea{
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            if(!customCheckBehaviour)
                outerRectangle.checked = !outerRectangle.checked
            outerRectangle.clicked();
        }
        cursorShape: containsMouse ? Qt.PointingHandCursor : Qt.ArrowCursor
    }
}