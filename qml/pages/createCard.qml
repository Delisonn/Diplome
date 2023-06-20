import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.15
import "../components"
import QtQuick.Timeline 1.0

Item {
    property string sourceForCard: "../../images/images/visa.png"
    property string textCardType: "Кредитна"
    property string cardNum : "4*** **** **** 1234"


    function handleCreditClick() {
        rowLayout3.visible = true;
        creditTextField.visible = true;
        label_credit_limit_card.visible = true;
    }

    function handleDebitClick() {
        rowLayout3.visible = false;
        creditTextField.visible = false;
        label_credit_limit_card.visible = false;
    }

    function handleNoClick() {
        creditTextField.visible = false;
    }
    
    function handleYesClick() {
        creditTextField.visible = true;
    }


    Rectangle{
        id: bg_rectangle
        anchors.fill: parent
        width: parent * 0.5
        // anchors.horizontalCenter: parent.horizontalCenter * 0.8
        color: "#00000000"

        Label{
            id: label_type_card
            text: "Тип картки"
            color: "#ffffff"
            font.pointSize: 14
            anchors.top: bg_rectangle.top
            anchors.topMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter
            // anchors.bottomMargin: 15
        }

        CustomButtonGroup{
            id: buttonGroup
            buttons: rowLayout.children 
            preselectionIndex: 0
        }

        RowLayout{
            id: rowLayout
            anchors.top: label_type_card.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 5
            spacing:10

            CustomRadioButton{
                id: credit
                height: 40
                width: 120
                line: "Кредитна"
                onClicked: {
                    textCardType = line;
                    console.log(line);
                    handleCreditClick();
                    }
            }

            CustomRadioButton{
                id: debit
                height: 40
                width: 120
                line: "Дебетова"
                onClicked: {
                    textCardType = line;
                    console.log(line);
                    handleDebitClick();
                }
            }
        }


        Label{
            id: label_system_card
            text: "Платіжна система"
            color: "#ffffff"
            font.pointSize: 14
            // anchors.left: parent.left
            anchors.top: rowLayout.top
            anchors.topMargin: 45
            anchors.horizontalCenter: parent.horizontalCenter
            // anchors.leftMargin: 150
        }

        CustomButtonGroup{
            id: buttonGroup2
            buttons: rowLayout2.children 
            preselectionIndex: 0
        }

        RowLayout{
            id: rowLayout2
            anchors.top: label_system_card.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 10
            spacing:10

            CustomPaymentRadioButton{
                id: visa
                height: 100
                width: 120
                line: "Visa"
                iconSource: "../../images/images/visa.png"
                onClicked: {
                    sourceForCard= iconSource;
                    console.log(line);
                    cardNum = "4*** **** **** 1234"
                }
            }

            CustomPaymentRadioButton{
                id: mastercard
                height: 100
                width: 120
                line: "Mastercard"
                iconSource: "../../images/images/mastercard.png"
                onClicked:{ 
                    sourceForCard= iconSource;
                    console.log(line);
                    cardNum = "5*** **** **** 1234"
                }
            }
        }

        Rectangle {
                    id: card
                    anchors.top: rowLayout2.bottom
                    anchors.topMargin: 10
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "#27273a"
                    height: 220
                    radius: 10

                    Rectangle {
                        id: whiteCard_1
                        width: 340
                        color: "#52527d"
                        radius: 10
                        // anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                         anchors.horizontalCenter: parent.horizontalCenter
                        // anchors.leftMargin: 10
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
                            color: "#7f7f7f"
                            antialiasing: false
                        }

                        Label {
                            id: labelTitleBar
                            x: 58
                            y: 20
                            color: "#ffffff"
                            text: textCardType
                            font.bold: true
                            font.pointSize: 11
                            font.family: "Segoe UI"
                        }

                        Label {
                            id: labelTitleBar1
                            anchors.top: labelTitleBar.bottom
                            anchors.left: whiteCard_1.left
                            anchors.topMargin: 20 
                            anchors.leftMargin: 15
                            color: "#ffffff"
                            text: cardNum
                            font.pointSize: 14
                            font.family: "Segoe UI"
                        }

                        Label {
                            id: labelTitleBar2
                            anchors.top: labelTitleBar1.bottom
                            anchors.left: whiteCard_1.left
                            anchors.topMargin: 20 
                            anchors.leftMargin: 15
                            color: "#ffffff"
                            text: "06/25"
                            font.pointSize: 14
                            font.family: "Segoe UI"
                        }

                        Label {
                            id: labelTitleBar3
                            anchors.top: labelTitleBar2.bottom
                            anchors.left: whiteCard_1.left
                            anchors.topMargin: 35 
                            anchors.leftMargin: 15
                            color: "#ffffff"
                            text: "200 000 UAH"
                            font.pointSize: 16
                            font.bold: true
                            font.family: "Segoe UI"
                        }

                        Image {
                            x: 227
                            y: 153
                            width: 120 * 0.7
                            height: 100 * 0.5
                            anchors.right: parent.right
                            anchors.bottom: parent.bottom
                            anchors.rightMargin: 15
                            source: sourceForCard
                            anchors.bottomMargin: 17
                        }
                    }
                }

        Label{
            id: label_credit_limit_card
            text: "Встановити кредитний ліміт?"
            color: "#ffffff"
            font.pointSize: 14
            anchors.top: card.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 5
        }

        CustomButtonGroup{
            id: buttonGroup3
            buttons: rowLayout3.children 
            preselectionIndex: 0
        }

        RowLayout{
            id: rowLayout3
            anchors.top: label_credit_limit_card.bottom
            anchors.topMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter
            spacing:10

            CustomRadioButton{
                id: yes
                height: 40
                width: 50
                line: "Так"
                onClicked: {
                    // textCardType = line
                    console.log(line)
                    handleYesClick()
                    }
            }

            CustomRadioButton{
                id: no
                height: 40
                width: 50
                line: "Ні"
                onClicked: {
                    // textCardType = line
                    console.log(line)
                    handleNoClick()
                    }
            }
        }

        CustomTextField {
                id: creditTextField
                width: 294
                height: 40
                opacity: 1
                color: "#ffffff"
                borderColor: "#53538f"
                placeholderTextColor:"#ffffff"
                placeholderText: "0"
                anchors.top: rowLayout3.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 5
                font.pointSize: 14
                font.bold: true
                font.family: "Segoe UI"
                font.weight: Font.DemiBold        
            }


        CustomButton {
            id: createCard
            width: 200
            height: 40
            text: "Створити"
            anchors.top: creditTextField.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            colorMouseOver: "#40405f"
            colorDefault: "#33334c"
            anchors.topMargin: 15
            font.pointSize:16
            colorPressed: "#55aaff"
            onClicked: {
                backend.createCard(textCardType, cardNum.substring(0,1), creditTextField.text)
                stackView.push("card.qml")
                }
            }
    }
}