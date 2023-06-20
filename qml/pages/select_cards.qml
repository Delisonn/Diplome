import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.15
import "../components"
import QtQuick.Timeline 1.0

Item {

    QtObject{
        id: internal
        function sendMoney(){
                var select_card_num = createCards(one_card[payCards.currentIndex])
                backend.sendMoney(select_card_num.card_num ,card_num_textField.text, sum_textField.text)
                console.log(one_card[payCards.currentIndex])
                console.log(card_num_textField.text)
                console.log(sum_textField.text)
        }
    }


    id: select_cards_bg
    // color: "#00000000"
    // visible: true
    // anchors.fill: parent 
    property var one_card: backend.showCards()
    property var cards: one_card.length

    function createCards(list){
        return {
            card_type: list[2],
            card_num: list[3],
            card_date_end: list[5],
            card_cvv: list[6],
            balance: list[7],
            credit_limit: list[8]
            
        };
    }

  ListModel{
            id: cardModel

            Component.onCompleted: {
                for (var i = 0; i < cards; i++) {
                    append(createCards(one_card[i]));
                }
            }
        }

  Label{
        id: label_from_card
        text: "З картки"
        color: "#ffffff"
        font.pointSize: 14
        anchors.left: select_cards_bg.left
        anchors.top: select_cards_bg.top
        anchors.topMargin: 50
        // anchors.leftMargin: 175
  }

  Component{
    id: cardDelegate 
      Rectangle {
          id: card
          color: "#27273a"
          height: 150
          border.width: 5
          border.color: ListView.isCurrentItem ? "#00ff7f" : "#00000000"
          width: 600
          radius: 10   
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

              Label{
                id: last_card_num
                anchors.left: iconCart.left
                anchors.top: parent.top
                anchors.topMargin: 15
                anchors.leftMargin: 35
                text: "*" + String(card_num).substring(12,16)
                color:"#ffffff"
                font.pointSize: 14
              }

              ColorOverlay {
                  anchors.fill: iconCart
                  source: iconCart
                  color: "#7f7f7f"
                  antialiasing: false
              }

             

              // Rectangle {
              //     id: hideValue_1
              //     x: 8
              //     y: 146
              //     width: 187
              //     height: 44
              //     color: "#ebfcff"
              //     radius: 5
              //     visible: !showValue
              // }
          }

          Label {
                  id: labelTitleBar
                  anchors.topMargin: 15
                  anchors.leftMargin: 15
                  anchors.left: whiteCard_1.right
                  anchors.top: card.top
                  color: "#ffffff"
                  text: "Картка " + card_type
                  font.bold: true
                  font.pointSize: 11
                  font.family: "Segoe UI"
              }

          Label {
                  id: labelTitleBar2
                  anchors.bottom: card.bottom
                  anchors.bottomMargin: 20
                  anchors.left: whiteCard_1.right
                  anchors.leftMargin: 20
                  color: "#55aaff"
                  text: balance
                  font.bold: true
                  font.pointSize: 20
                  font.family: "Segoe UI"
                  // visible: showValue
              }

          MouseArea{
          anchors.fill: parent
          onClicked: {
              payCards.currentIndex = index
              console.log(index)
          }       
      }  
    }            
  }

    ListView {
        id: payCards
        anchors.top: label_from_card.bottom
        // anchors.left: parent
        // anchors.right: parent
        // anchors.bottom: send_to_card.top
        anchors.topMargin: 20
        // anchors.bottomMargin: 20
        spacing: 10
        height: 150
        width: select_cards_bg.width
        flickableDirection: Flickable.HorizontalFlick
        orientation: Qt.Horizontal
        model: cardModel
        delegate: cardDelegate 
        clip: true
    }

    Label{
        id: label_to_card
        text: "На картку"
        color: "#ffffff"
        font.pointSize: 14
        anchors.left: select_cards_bg.left
        anchors.top: payCards.bottom
        anchors.topMargin: 50
        // anchors.leftMargin: 175
  }

    Rectangle {
        id: send_to_card
        color: "#27273a"
        height: 200
        width: select_cards_bg.width
        radius: 10   
        anchors.topMargin: 20
        anchors.top: label_to_card.bottom

            CustomTextField {
                id: card_num_textField
                // y: 273
                // minimumWidth: 200
                width: send_to_card.width
                height: 40
                opacity: 1
                color: "#ffffff"
                placeholderTextColor: "#ffffff"
                borderColor: "#00000000"
                placeholderText: "Номер картки"
                anchors.top: send_to_card.top
                anchors.left: send_to_card.left
                anchors.right: send_to_card.right
                anchors.topMargin: 30
                anchors.leftMargin: 20
                anchors.rightMargin: 20
                font.pointSize: 14
                font.bold: true
                font.family: "Segoe UI"
                font.weight: Font.DemiBold
            }

                Label{
                    id: sum_label
                    text: "Сума"
                    color: "#ffffff"
                    anchors.left: send_to_card.left
                    anchors.top: card_num_textField.top
                    anchors.topMargin: 60
                    anchors.leftMargin: 20
            }

            CustomTextField {
                id: sum_textField
                // y: 273
                // minimumWidth: 200
                width: send_to_card.width
                height: 40
                opacity: 1
                color: "#ffffff"
                placeholderTextColor: "#ffffff"
                borderColor: "#00000000"
                placeholderText: "Сума переказу"
                anchors.top: sum_label.top
                anchors.left: send_to_card.left
                anchors.right: send_to_card.right
                anchors.topMargin: 30
                anchors.leftMargin: 20
                anchors.rightMargin: 20
                font.pointSize: 14
                font.bold: true
                font.family: "Segoe UI"
                font.weight: Font.DemiBold
            }

            

        // anchors.left: select_cards_bg
        // anchors.right: select_cards_bg
        // anchors.bottom: buttonSucces.top
        // anchors.bottomMargin: 10
            
    }




   CustomButton {
        id: buttonSucces
        width: 250
        height: 60
        text: "Оплатити $" + sum_textField.text
        anchors.top: send_to_card.bottom
        anchors.topMargin: 20
        //   anchors.left: parent
        //   anchors.right: parent
        //   anchors.bottom: parent
        font.pointSize: 14
        colorPressed: "#55aaff"
        colorMouseOver: "#40405f"
        colorDefault: "#33334c"
        anchors.bottomMargin: 150
        
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked:{
            internal.sendMoney()
            stackView.push("card.qml")
        }
    }
}