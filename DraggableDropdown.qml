import QtQuick 2.9
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

Rectangle {
    id: root
    width: 200
    height: 100
    border.width: 2
    border.color: "lightgrey"
    objectName: "DraggableDropdown"

    property string displayedName: qsTr("Dropdown")
    property string eventName
    property alias label: label.text
    property alias enabled: comboBox.enabled
    property alias comboBox: comboBox
    property alias model: comboBox.model

    ColumnLayout{
        anchors.fill: parent
        anchors.margins: 2

        Text{
            id: label
            text: qsTr("New Dropdown")
            font.pointSize: 12
            Layout.alignment: Layout.Center
        }

        ComboBox{
            id: comboBox
            enabled: false
            textRole: "entry"
            Layout.fillWidth: true
            model: ListModel{
                ListElement{
                    entry: "Entry 1"
                }
            }
            onCurrentIndexChanged: {
                if(eventName)
                    serialConnection.writeToSerial(eventName, comboBox.currentIndex)
            }
        }
    }

    RightClickEdit{
        root: root
        enabled: !root.enabled
    }

    ScaleKnob{
        root: root
        enabled: !root.enabled
    }

    DeleteComponentKnob{
        root: root
        enabled: !root.enabled
    }
}