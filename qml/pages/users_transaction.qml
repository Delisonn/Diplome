import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.15
import "../components"
import QtQuick.Timeline 1.0

Item {
    id: select_cards_bg
    property int userId: stackView.options.userId
    property var one_transaction: backend.showTransactionsForAdmin(userId)
    property var transactions: one_transaction.length
    property var tran_source : null

    QtObject{
        id: internal
    }

    function createTransaction(list){
            tran_source = backend.checkTransaction(list[0])
            console.log(tran_source)
            return {
                transaction_id: list[0],
                sender_second_name: list[1],
                sender_name: list[2],
                receiver_name: list[3],
                receiver_second_name: list[4],
                amount: list[7],
                send_date: list[8],
                send_time: list[9],
                id_receiver: list[11],
                tran_source
            };
    }

  ListModel{
            id: cardModel
            Component.onCompleted: {
                try{
                    for (var i = 0; i < transactions; i++) {
                        append(createTransaction(one_transaction[i]));
                        console.log(one_transaction[i])
                    }
                } catch(e){
                    console.log(e)
                }
            }
        }

    Component{
        id: cardDelegate 
        Rectangle {
            id: transaction
            color: "#27273a"
            height: 150
            width: select_cards_bg.width
            radius: 10   

            Image{
                id: iconCart
                sourceSize.height: 30
                sourceSize.width: 30
                anchors.verticalCenter: transaction.verticalCenter
                anchors.leftMargin: 15
                height: 50
                width: 50
                visible: true
                anchors.left: parent.left
                source:  !tran_source ? "../../images/svg_images/transaction_to.svg" : "../../images/svg_images/transaction_from.svg"
                fillMode: Image.PreserveAspectFit
                antialiasing: false
            }

            Label{
                id:labelDate
                anchors.left: transaction.left
                anchors.top: transaction.top
                anchors.topMargin: 10
                anchors.leftMargin: 10
                text: send_date
                font.pointSize: 12
                color: "#c2bebe" 
            }

            Label{
                id: labelTransaction
                anchors.left: iconCart.right
                anchors.top: transaction.top
                anchors.leftMargin: 50
                anchors.topMargin: 30
                text: "Перекази"
                font.pointSize: 12
                color: "#c2bebe"
            }

            Label{
                id: labelSender
                anchors.left: iconCart.right
                anchors.top: labelTransaction.top
                anchors.leftMargin: 50
                anchors.topMargin: 30
                text: tran_source ? "Від " + sender_second_name + " " + sender_name : receiver_second_name + " " + receiver_name
                font.pointSize: 14
                color: "#ffffff"
            }

            Label{
                id: labelTime
                anchors.left: iconCart.right
                anchors.top: labelSender.bottom
                anchors.topMargin: 15
                anchors.leftMargin: 50
                text: send_time.substr(0, 5)
                font.pointSize: 12
                color: "#c2bebe"
            }

            Label{
                id: labelAmount
                anchors.right: transaction.right
                anchors.verticalCenter: transaction.verticalCenter
                anchors.rightMargin: 20
                text: tran_source ?  amount : "- " + amount
                font.pointSize: 14
                color: tran_source ? "#77c98a" : "#ffffff"
            }

        }            
    }

    ListView {
        id: transactionsList
        
        anchors.fill: select_cards_bg
        
        anchors.topMargin: 20
        spacing: 10
        height: select_cards_bg.height
        width: select_cards_bg.width
        flickableDirection: Flickable.VerticalFlick
        reuseItems: true
        contentY : flickable.contentY
        orientation: Qt.Vertical
        model: cardModel
        delegate: cardDelegate 
        clip: true
    }

}