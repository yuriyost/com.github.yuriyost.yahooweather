/*
 *   Author: Symeon Huang (librehat) <hzwhuang@gmail.com>
 *   Copyright 2016
 * 
 *   Author: Yuriy Ost <qcounter@yandex.ru>
 *   Copyright 2018
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 3 or
 *   (at your option) any later version.
 */

import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

Item {
	width: 235
	height: 235
	Layout.minimumWidth: 235
	Layout.minimumHeight: 235
	clip: true
			
	PlasmaCore.IconItem {
		id: noneWeather
		source: "weather-none-available"
		width: parent.width
		height: parent.height
		visible: backend.hasdata == 0 ? 1 : 0
	}
	
    PlasmaComponents.BusyIndicator {
        anchors { horizontalCenter: parent.horizontalCenter; verticalCenter: parent.verticalCenter }
        width: parent.width
        height: parent.height
        visible: backend.m_isbusy
        running: backend.m_isbusy
    }
			
		Row {
			id: conditionRow
			width: parent.width
			height: parent.height * 0.3

			Column {
				width: parent.width * 0.3
				height: parent.height
				visible: backend.hasdata
				
				PlasmaComponents.Label { 	
					id: conditionDegree
					width: parent.width
					height: parent.height
					horizontalAlignment: Text.AlignHCenter
					verticalAlignment: Text.AlignVCenter
					
					font.pointSize: Math.round(conditionDegree.height / 5)
					minimumPointSize: 5
					fontSizeMode: Text.Fit 

					text: '<b>H: '+ backend.m_conditionH +'°</b><br>L: '+ backend.m_conditionL +'°'
				}


				
			}
			
			PlasmaCore.IconItem {
				id: conditionIcon
				visible: backend.hasdata
				source: backend.m_conditionIcon
				width: parent.width * 0.4
				height: parent.height + 20
			}
			
			Column {
				width: parent.width * 0.3
				height: parent.height
				visible: backend.hasdata
				
				PlasmaComponents.Label { 	
					id: conditionTemp
					width: parent.width
					height: parent.height
					
					horizontalAlignment: Text.AlignHCenter
					verticalAlignment: Text.AlignVCenter
					
					font.pointSize: 100
					minimumPointSize: 10
					fontSizeMode: Text.Fit
					
					text: backend.m_conditionTemp + "°"
				}

				
			}
			
		}
		
		Row {
			id: conditionRow2
			width: parent.width
			height: parent.height * 0.08
			anchors.top: conditionRow.bottom
			visible: backend.hasdata

			Column {
				width: parent.width * 0.3
				height: parent.height

				PlasmaComponents.Label {
					id: conditionHumidity
					width: parent.width
					height: parent.height
					
					text: backend.m_atmosphereHumidity + "%"
					horizontalAlignment: Text.AlignHCenter
					
					font.pointSize: 100
					minimumPointSize: 10
					fontSizeMode: Text.Fit 
					lineHeight: 1
				}
				
			}
			
			Column {
				width: parent.width * 0.4
				height: parent.height
				
				PlasmaComponents.Label {
					id: conditionCountry
					width: parent.width
					height: parent.height
					horizontalAlignment: Text.AlignHCenter
					
					text: '<b>'+ backend.m_city +'</b>'
					
					font.pointSize: 100
					minimumPointSize: 10
					fontSizeMode: Text.Fit 
					lineHeight: 1
				}
				
			}
			
			Column {
				width: parent.width * 0.3
				height: parent.height
				PlasmaComponents.Label {
					id: conditionSpeed
					width: parent.width
					height: parent.height
					
					text: backend.m_windSpeed + ' ' + backend.m_unitSpeed
					horizontalAlignment: Text.AlignHCenter
					
					font.pointSize: 100
					minimumPointSize: 10
					fontSizeMode: Text.Fit 
					lineHeight: 1
				}
				
			}
			
		}
		
		Row {
			id: regionRow
			width: parent.width
			height: parent.height * 0.06
			anchors.topMargin: 5
			anchors.top: conditionRow2.bottom
			visible: backend.hasdata
			
			PlasmaComponents.Label {
				id: regionName
				width: parent.width
				height: parent.height
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.Wrap

				text: backend.m_country +', '+ backend.m_region
				
				font.pointSize: 100
				minimumPointSize: 5
				fontSizeMode: Text.Fit 
				lineHeight: 1
			}

		}
	
		Row {
			id: forecastGrid
			visible: backend.hasdata
			width: parent.width
			height: parent.height * 0.4
			
			anchors.topMargin: 5
			anchors.top: regionRow.bottom

			ListView {
				id: forecastView
				visible: backend.hasdata
				orientation: ListView.Horizontal
				width: parent.width
				height: parent.height 
				model: backend.dataModel

				delegate: ForecastDelegate { 
					width: parent.parent.width / 4
					height: parent.parent.height 
				}
			}
		}


		Rectangle {
			width: parent.width
			height: parent.height * 0.05
			color: "#30FFFFFF"
			border.width: 0
			
			anchors.topMargin: 20
			anchors.top: forecastGrid.bottom
			
			Row {
				id: reloadRow
				width: parent.width
				height: parent.height

				Column {
					width: parent.width * 0.5
					height: parent.height
					
					Button {
						id: refresh_button
						width: parent.height 
						height: parent.height
						tooltip: i18n("Refresh")
						onClicked: action_reload()
					}
					
				}
				
				Column {
					width: parent.width * 0.5
					height: parent.height
					PlasmaComponents.Label {
						width: parent.width
						height: parent.height
						horizontalAlignment: Text.AlignRight
						linkColor: "red"
						
						text: '<a href="https://www.yahoo.com/weather/">' + i18n("YAHOO! Weather") + '</a>'
						
						font.pointSize: 100
						minimumPointSize: 5
						fontSizeMode: Text.Fit 
						onLinkActivated: Qt.openUrlExternally(link)
					}
					
				}
			}
		}
	
		Timer {
			id: timer
			interval: plasmoid.configuration.interval * 60000 //1m=60000ms
			running: !backend.m_isbusy
			repeat: true
			onTriggered: action_reload()
		}
		
		function action_reload () {
			backend.query()
		}
		
		Connections {
			target: plasmoid.configuration
			onWoeidChanged: action_reload()

			//this signal is emitted when any unit checkbox changes
			//binding multiple unit changed signals will cause a segfault
			onMbrChanged: backend.reparse()
		}

		Component.onCompleted: {
			if (!backend.haveQueried) {
				action_reload()
			}
		}

}
