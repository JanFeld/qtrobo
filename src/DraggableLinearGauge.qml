import QtQuick 2.2
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4
import QtQuick.Extras 1.4
import QtQuick.Extras.Private 1.0
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.3

Item{
    id: root
    width: 150
    height: 300

    property string eventName
    property string label: qsTr("New Linear Gauge")
    property alias enabled: layout.enabled
    property alias minimumValue: gauge.minimumValue
    property alias maximumValue: gauge.maximumValue
    property int mappedMinimumValue: gauge.minimumValue
    property int mappedMaximumValue: gauge.maximumValue
    property var componentType: GlobalDefinitions.ComponentType.LinearGauge
    property color fontColor: "black"
    property color componentColor: "black"
    property bool edible: true
    property string outputScript

    function setConfig(origin)
    {
        root.eventName = origin.eventName
        root.componentColor = origin.componentColor
        root.fontColor = origin.fontColor
        root.label = origin.label
        root.minimumValue = origin.minimumValue
        root.maximumValue = origin.maximumValue
        root.mappedMinimumValue = origin.mappedMinimumValue
        root.mappedMaximumValue = origin.mappedMaximumValue
    }

    onEdibleChanged: enabled = !edible


    GridLayout{
        id: layout
        enabled: false
        columns: 1
        anchors.fill: parent
        anchors.margins: 5

        Label{
            text: label
            color: fontColor
            Layout.alignment: Qt.AlignHCenter
            Layout.bottomMargin: 10
            font.pointSize: 12
        }

        Gauge{
            id: gauge
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignHCenter

            tickmarkStepSize: Math.abs(maximumValue - minimumValue) / 10
            Behavior on value{
                SmoothedAnimation{
                    velocity: 75
                }
            }

            style: GaugeStyle{
                tickmark: Item {
                    implicitWidth: 18
                    implicitHeight: 1

                    Rectangle {
                        color: fontColor
                        anchors.fill: parent
                        anchors.leftMargin: 3
                        anchors.rightMargin: 3
                    }
                }

                minorTickmark: Item {
                    implicitWidth: 8
                    implicitHeight: 1

                    Rectangle {
                        color: fontColor
                        anchors.fill: parent
                        anchors.leftMargin: 2
                        anchors.rightMargin: 4
                    }
                }

                tickmarkLabel: Text{
                    color: fontColor
                    text: Math.floor(styleData.value)
                    font.pointSize: 10
                }

                valueBar: Rectangle {
                    implicitWidth: 16
                    color: componentColor
                }
            }
        }

        Connections{
            id: connection
            target: qtRobo.connection
            function onDataChanged(eventName, data){
                if(eventName === root.eventName && data){
                    var parsedValue = parseInt(data)
                    if(!isNaN(parsedValue)){
                        var result = GlobalDefinitions.mapToValueRange(parsedValue, mappedMinimumValue, mappedMaximumValue, gauge.minimumValue, gauge.maximumValue)

                        if(outputScript){
                            result = qtRobo.connection.javascriptParser.runScript(eventName, parsedValue, outputScript)

                            if(result.value)
                                parsedValue = result.value
                        }
                        gauge.value = parsedValue
                    }

                }
            }

            Component.onDestruction: connection.target = null
        }
    }

    DeleteComponentKnob{
        root: root
        enabled: root.edible
    }

    ScaleKnob{
        root: root
        enabled: root.edible
    }

    RightClickEdit{
        root: root
        enabled: root.edible
    }
}
