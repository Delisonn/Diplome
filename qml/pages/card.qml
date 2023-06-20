import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.15
import "../components"
import QtQuick.Timeline 1.0



    Item {
        property bool showValue: true
        property var one_card: backend.showCards()
        property var cards: one_card.length
        property bool showFullNumber: false


        function createCards(list){
            // console.log(typeof list[7])
            // console.log(typeof backend.showPlusBalance(list[0]) )
            // console.log(String(backend.showMinusBalance(list[0])) )
            return {
                card_id: list[0],
                card_type: list[2],
                card_num: list[3],
                card_date_end: list[5],
                card_cvv: list[6],
                balance: list[7],
                credit_limit: list[8],
                showFullNumber: false,
                showFullNumberTimer: false  
            };
        }



        function formatCardNumber(cardNumber, showFullNumber) {
            var formattedNumber = String(cardNumber).replace(/\s/g, '');
            var maskedNumber = "";

            if (showFullNumber) {
                for (var i = 0; i < formattedNumber.length; i++) {
                    if (i > 0 && i % 4 === 0) {
                        maskedNumber += " ";
                    }
                    maskedNumber += formattedNumber[i];
                }
            } else {
                maskedNumber = formattedNumber.substring(0, 4) + " **** **** " + formattedNumber.substring(12);
            }
            return maskedNumber;
        }


        function formatCardDate(cardDate) {
            var maskedNumber = cardDate.substring(5,7) + "/" + cardDate.substring(2, 4);
            return maskedNumber;
        }

        id: select_cards_bg
    
      

        Flickable {
            id: flickable
            opacity: 1
            anchors.fill: parent
            clip: true
                

                ListModel{
                    id: cardModel

                    Component.onCompleted: {
                        for (var i = 0; i < cards; i++) {
                            append(createCards(one_card[i]));
                        }
                    }
                }

                Component{
                    id: cardDelegate 
                        Rectangle {
                            id: card
                            color: "#27273a"
                            height: 220
                            width: flickable.width
                            radius: 10   

                            property bool showFullNumberDelegate: cardModel.get(index).showFullNumber
                            // showFullNumberTimer

                            Rectangle {
                                id: whiteCard_1
                                width: 340
                                color: "#3a3a5c"
                                radius: 10
                                anchors.left: parent.left
                                anchors.top: parent.top
                                anchors.bottom: parent.bottom
                                anchors.leftMargin: 10
                                anchors.bottomMargin: 10
                                anchors.topMargin: 10

                                Image {
                                    id: iconCart
                                    sourceSize.height: 30
                                    sourceSize.width: 30
                                    anchors.topMargin: 15
                                    anchors.leftMargin: 15
                                    height: 30
                                    width: 30
                                    visible: false
                                    anchors.left: parent.left
                                    anchors.top: parent.top
                                    source: "../../images/svg_images/cart_icon.svg"
                                    fillMode: Image.PreserveAspectFit
                                    antialiasing: false
                                }

                                ColorOverlay {
                                    anchors.fill: iconCart
                                    source: iconCart
                                    color: "#ffffff"
                                    antialiasing: false
                                }

                                Label {
                                    id: labelTitleBar
                                    x: 58
                                    y: 20
                                    color: "#ffffff"
                                    text: card_type
                                    font.bold: true
                                    font.pointSize: 11
                                    font.family: "Segoe UI"
                                }

                                MouseArea {
                                    id: mouseArea
                                    anchors.top: labelTitleBar.top
                                    height:15
                                    anchors.left: whiteCard_1.left
                                    anchors.leftMargin: 30
                                    anchors.topMargin: 30
                                    anchors.horizontalCenter: whiteCard_1.horizontalCenter
                                    onClicked: {
                                        cardModel.setProperty(index, "showFullNumber", !cardModel.get(index).showFullNumber);
                                        if (cardModel.get(index).showFullNumber) {
                                            backend.copyToClipboard(cardModel.get(index).card_num);
                                            cardModel.setProperty(index, "showFullNumberTimer", true);
                                        }
                                    }
                                }
                                Text {
                                    id: card_number
                                    anchors.top: labelTitleBar.top
                                    height:15
                                    anchors.left: whiteCard_1.left
                                    anchors.leftMargin: 30
                                    anchors.topMargin: 30
                                    text: formatCardNumber(card_num, showFullNumberDelegate)
                                    font.pointSize: 14
                                    color: "#ffffff"
                                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                                    elide: Text.ElideRight
                                }       

                                Label {
                                    id: card_date
                                    anchors.top: card_number.bottom
                                    anchors.left: whiteCard_1.left
                                    anchors.leftMargin: 30
                                    anchors.topMargin: 40
                                    text: formatCardDate(card_date_end)
                                    font.pointSize: 12
                                    font.family: "Segoe UI"
                                    color: "#ffffff" 
                                }

                                Label{
                                    id: card_cvv_label
                                    opacity: 1
                                    anchors.bottom: whiteCard_1.bottom
                                    anchors.right:  whiteCard_1.right
                                    anchors.rightMargin: 30
                                    anchors.bottomMargin: 30
                                    text: card_cvv
                                    font.bold: true
                                    color: "#ffffff"
                                    font.pointSize: 16
                                    font.family: "Segoe UI"
                                    font.weight: Font.Normal
                                }

                                Label {
                                    id: labelTitleBar1
                                    x: 15
                                    y: 129
                                    color: "#767676"
                                    text: qsTr("Баланс")
                                    font.pointSize: 10
                                    font.family: "Segoe UI"
                                }

                                Label {
                                    id: labelTitleBar2
                                    x: 13
                                    y: 138
                                    color: "#55aaff"
                                    text: balance
                                    font.bold: true
                                    font.pointSize: 20
                                    font.family: "Segoe UI"
                                    visible: showValue
                                }

                                Label {
                                    id: labelTitleBar3
                                    x: 14
                                    y: 170
                                    color: "#767676"
                                    text: "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0//EN\" \"http://www.w3.org/TR/REC-html40/strict.dtd\">\n<html><head><meta name=\"qrichtext\" content=\"1\" /><style type=\"text/css\">\np, li { white-space: pre-wrap; }\n</style></head><body style=\" font-family:'MS Shell Dlg 2'; font-size:8.25pt; font-weight:400; font-style:normal;\">\n<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">Ліміт: <span style=\" font-weight:600; color:#55aa00;\">" + credit_limit + "</span></p></body></html>"
                                    textFormat: Text.RichText
                                    font.pointSize: 10
                                    font.family: "Segoe UI"
                                    visible: showValue
                                }


                                Rectangle {
                                    id: hideValue_1
                                    x: 8
                                    y: 146
                                    width: 187
                                    height: 44
                                    color: "#ebfcff"
                                    radius: 5
                                    visible: !showValue
                                }
                            }


                            Rectangle {
                                id: greenBar
                                height: 10
                                opacity: 1
                                color: "#55ff7f"
                                radius: 5
                                anchors.left: whiteCard_1.right
                                anchors.right: parent.right
                                anchors.top: parent.top
                                clip: true
                                anchors.topMargin: 30
                                anchors.rightMargin: 15
                                anchors.leftMargin: 15

                                Rectangle {
                                    id: blueBar
                                    x: 395
                                    width: parent.width * backend.strSum(balance, String(backend.showPlusBalance(card_id)), String(backend.showMinusBalance(card_id)))
                                    height: 10
                                    color: "#55aaff"
                                    radius: 5
                                    anchors.right: parent.right
                                    anchors.rightMargin: 1
                                    clip: true
                                }

                                Rectangle {
                                    id: orangeBar
                                    x: 10
                                    y: 0
                                    width: parent.width * backend.strSumOrange(balance, String(backend.showPlusBalance(card_id)), String(backend.showMinusBalance(card_id)))
                                    height: 10
                                    color: "#ff5500"
                                    radius: 5
                                    anchors.right: parent.right
                                    anchors.rightMargin: 0
                                    clip: true
                                }
                            }

                            GridLayout {
                                id: textsFatura
                                x: 402
                                y: 52
                                anchors.left: whiteCard_1.right
                                anchors.right: parent.right
                                anchors.top: greenBar.bottom
                                anchors.topMargin: 10
                                anchors.rightMargin: 15
                                anchors.leftMargin: 40
                                rows: 2
                                columns: 3

                                Label {
                                    id: textValue_1
                                    color: "#55ff7f"
                                    text: "$" + backend.showPlusBalance(card_id)
                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                    font.pointSize: 14
                                    font.bold: true
                                    font.family: "Segoe UI"
                                    visible: showValue
                                }

                                Label {
                                    id: textValue_2
                                    color: "#55aaff"
                                    text: balance
                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                    font.pointSize: 14
                                    font.bold: true
                                    font.family: "Segoe UI"
                                    visible: showValue
                                }

                                Label {
                                    id: textValue_3
                                    color: "#ff5500"
                                    text: "$" + backend.showMinusBalance(card_id)
                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                    font.pointSize: 14
                                    font.bold: true
                                    font.family: "Segoe UI"
                                    visible: showValue
                                }

                                Label {
                                    id: labelTitleBar20
                                    color: "#ffffff"
                                    text: qsTr("Надходження")
                                    font.pointSize: 9
                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                    font.bold: false
                                    font.family: "Segoe UI"
                                    visible: showValue
                                }

                                Label {
                                    id: labelTitleBar21
                                    color: "#ffffff"
                                    text: qsTr("Залишок")
                                    font.pointSize: 9
                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                    font.bold: false
                                    font.family: "Segoe UI"
                                    visible: showValue
                                }

                                Label {
                                    id: labelTitleBar22
                                    color: "#ffffff"
                                    text: qsTr("Витрати")
                                    font.pointSize: 9
                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                    font.bold: false
                                    font.family: "Segoe UI"
                                    visible: showValue
                                }
                            }

                    }            
                }

                ListView{
                    id: listView
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: {parent.height - 70}
                    spacing: 10
                    model: cardModel
                    delegate: cardDelegate 
                }

                CustomButton{
                    id: createCard
                    width: 200
                    height: 40
                    text: "Створити картку"
                    anchors.top: listView.bottom
                    anchors.horizontalCenter: listView.horizontalCenter
                    colorMouseOver: "#40405f"
                    colorDefault: "#33334c"
                    anchors.topMargin: 25
                    font.pointSize:16
                    colorPressed: "#55aaff"
                    onClicked: {
                        stackView.push("createCard.qml")
                    }
                }

                Timer {
                    interval: 5000
                    running: true
                    repeat: true
                    triggeredOnStart: true
                    onTriggered: {
                        for (var i = 0; i < cardModel.count; i++) {
                            cardModel.setProperty(i, "showFullNumber", false);
                            cardModel.setProperty(i, "showFullNumberTimer", false);
                        }
                    }
                }
        }
    }