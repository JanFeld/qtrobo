import QtQuick 2.9
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

Rectangle {
    id: root
    width: 200
    height: 100
    border.width: 2
    border.color: componentColor

    property string eventName
    property alias label: label.text
    property alias enabled: comboBox.enabled
    property alias comboBox: comboBox
    property alias model: comboBox.model
    property var componentType: GlobalDefinitions.ComponentType.Dropdown
    property color componentColor: "lightgray"
    property color fontColor: "black"
    property bool edible: true
    property string outputScript
    onEdibleChanged: enabled = !edible

    function setConfig(origin)
    {
        root.eventName = origin.eventName
        root.componentColor = origin.componentColor
        root.fontColor = origin.fontColor
        root.label = origin.label
        root.model.clear()
        for(var index = 0; index < origin.model.count; ++index){
            root.model.append({"entry": origin.model.get(index).entry})
        }

        root.comboBox.currentIndex = 0
    }

    ColumnLayout{
        anchors.fill: parent
        anchors.margins: 2

        Label{
            id: label
            text: qsTr("New Dropdown")
            font.pointSize: 12
            Layout.alignment: Layout.Center
            color: fontColor
        }

        ComboBox{
            id: comboBox
            enabled: false
            textRole: "entry"
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: 15
            background: Rectangle{
                id: comboBoxBackground
                color: componentColor
                anchors.fill: parent
            }

            contentItem: Text{
                color: fontColor
                text: parent.currentText
                font.pointSize: 12
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                opacity: enabled ? 1.0 : 0.3
                elide: Text.ElideRight
            }

            model: ListModel{
                ListElement{
                    entry: "Entry 1"
                }
            }
            onCurrentIndexChanged: {
                if(eventName && eventName.length > 0){
                    var modifiedEvent = eventName
                    var modifiedData = comboBox.currentIndex
                    if(outputScript){
                        var result = qtRobo.connection.javascriptParser.runScript(modifiedEvent, modifiedData, outputScript)
                        if(result.value)
                            modifiedData = result.value
                        if(result.event)
                            modifiedEvent = result.event
                    }
                    qtRobo.connection.write(modifiedEvent, modifiedData)
                }
            }
        }
    }

    RightClickEdit{
        root: root
        enabled: root.edible
    }

    ScaleKnob{
        root: root
        enabled: root.edible
    }

    DeleteComponentKnob{
        root: root
        enabled: root.edible
    }
}
