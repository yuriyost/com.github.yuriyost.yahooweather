/*
 *   Author: Yuriy Ost <qcounter@yandex.ru>
 *   Copyright 2018
*
*   This program is free software; you can redistribute it and/or modify
*   it under the terms of the GNU Library General Public License as
*   published by the Free Software Foundation; either version 3 or
*   (at your option) any later version.
*/

import QtQuick 2.2
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.core 2.0 as PlasmaCore

Column {
	id: delegate
	width: width
	height: height 
	
	
	Rectangle {
		width: parent.width
		height: parent.height * 0.25
		color: "#30FFFFFF"
		border.width: 0

		PlasmaComponents.Label { 
			width: parent.width
			height: parent.height
			
			horizontalAlignment: Text.AlignHCenter
			text: '<b>'+ day +'</b>'

			font.pointSize: parent.height * 0.5
			minimumPointSize: 14
			fontSizeMode: Text.Fit 

		}
	}
	
	Row {
		width: parent.width
		height: parent.height * 0.5

		PlasmaCore.IconItem {
			source: icon
			anchors.horizontalCenter: parent.horizontalCenter
			width: parent.width
			height: parent.height
		}
	}

	PlasmaComponents.Label { 
		width: parent.width
		height: parent.height * 0.3

		horizontalAlignment: Text.AlignHCenter
		text: '<b>H: '+ tempHi +'</b><br>L: '+ tempLo

		font.pointSize: 100
		minimumPointSize: 10
		fontSizeMode: Text.Fit 

	}
}

