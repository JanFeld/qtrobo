import QtQuick 2.0

Text{
    property var root
    property var rotate
    text: "↻"
    color: "blue"
    font.bold: true
    width: 15
    height: 15
    anchors.top: parent.bottom
    anchors.right: parent.left
    enabled: !display.enabled
    visible: enabled

    MouseArea{
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        onClicked: {
            root.rotation = root.rotation === 0 ? -90 : 0
        }
    }
}