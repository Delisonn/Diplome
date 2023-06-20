import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.15
import "../components"
import QtQuick.Timeline 1.0

Item{
    function createUser(){
            var login_result = backend.createUser(first_name_textField.text, second_name_textField.text, email_textField.text, password_textField.text, number_textField.text, number_passport_textField.text)
            // backend.showCards()
            if(login_result){
                first_name_textField.borderColor = "#00ff7f"
                second_name_textField.borderColor = "#00ff7f"
                email_textField.borderColor = "#00ff7f"
                number_textField.borderColor = "#00ff7f"
                number_passport_textField.borderColor = "#00ff7f"
                password_textField.borderColor = "#00ff7f"
                return true
            } else{
                first_name_textField.borderColor = "#ff007f"
                second_name_textField.borderColor = "#ff007f"
                email_textField.borderColor = "#ff007f"
                number_textField.borderColor = "#ff007f"
                number_passport_textField.borderColor = "#ff007f"
                password_textField.borderColor = "#ff007f"
                return false
            }
        }

    Rectangle{
        id: bg_rectangle
        anchors.fill: parent
        anchors.horizontalCenter: parent.horizontalCenter * 0.8
        color: "#00000000"
        Label{
            id: label_first_name
            anchors.top: bg_rectangle.top
            anchors.topMargin: 15
            anchors.left: bg_rectangle.left
            anchors.leftMargin: 20
            text: "Ім'я"
            color: "#ffffff"
            font.pointSize: 14
        }

        CustomTextField {
                    id: first_name_textField
                    width: send_to_card.width
                    height: 40
                    opacity: 1
                    color: "#ffffff"
                    placeholderTextColor: "#ffffff"
                    borderColor: "#55aaff"
                    placeholderText: "Даніїл"
                    anchors.top: label_first_name.bottom
                    anchors.left: bg_rectangle.left
                    anchors.right: bg_rectangle.right
                    anchors.topMargin: 30
                    anchors.leftMargin: 20
                    anchors.rightMargin: 20
                    font.pointSize: 14
                    font.bold: true
                    font.family: "Segoe UI"
                    font.weight: Font.DemiBold
                }
    

     Label{
            id: label_second_name
            anchors.top: first_name_textField.bottom
             anchors.left: bg_rectangle.left
            anchors.leftMargin: 20
            anchors.topMargin: 15
            text: "Призвіще"
            color: "#ffffff"
            font.pointSize: 14
        }

        CustomTextField {
                    id: second_name_textField
                    width: send_to_card.width
                    height: 40
                    opacity: 1
                    color: "#ffffff"
                    placeholderTextColor: "#ffffff"
                    borderColor: "#55aaff"
                    placeholderText: "Казанцев"
                    anchors.top: label_second_name.bottom
                    anchors.left: bg_rectangle.left
                    anchors.right: bg_rectangle.right
                    anchors.topMargin: 30
                    anchors.leftMargin: 20
                    anchors.rightMargin: 20
                    font.pointSize: 14
                    font.bold: true
                    font.family: "Segoe UI"
                    font.weight: Font.DemiBold
                }

        Label{
            id: label_email
            anchors.top: second_name_textField.bottom
            anchors.left: bg_rectangle.left
            anchors.leftMargin: 20
            anchors.topMargin: 15
            text: "Email"
            color: "#ffffff"
            font.pointSize: 14
        }

        CustomTextField {
                    id: email_textField
                    width: send_to_card.width
                    height: 40
                    opacity: 1
                    color: "#ffffff"
                    placeholderTextColor: "#ffffff"
                    borderColor: "#55aaff"
                    placeholderText: "example@gmail.com"
                    anchors.top: label_email.bottom
                    anchors.left: bg_rectangle.left
                    anchors.right: bg_rectangle.right
                    anchors.topMargin: 30
                    anchors.leftMargin: 20
                    anchors.rightMargin: 20
                    font.pointSize: 14
                    font.bold: true
                    font.family: "Segoe UI"
                    font.weight: Font.DemiBold
                }

        Label{
            id: label_number
            anchors.top: email_textField.bottom
            anchors.left: bg_rectangle.left
            anchors.leftMargin: 20
            anchors.topMargin: 15
            text: "Номер"
            color: "#ffffff"
            font.pointSize: 14
        }

        CustomTextField {
                    id: number_textField
                    width: send_to_card.width
                    height: 40
                    opacity: 1
                    color: "#ffffff"
                    placeholderTextColor: "#ffffff"
                    borderColor: "#55aaff"
                    placeholderText: "+380986547547"
                    anchors.top: label_number.bottom
                    anchors.left: bg_rectangle.left
                    anchors.right: bg_rectangle.right
                    anchors.topMargin: 30
                    anchors.leftMargin: 20
                    anchors.rightMargin: 20
                    font.pointSize: 14
                    font.bold: true
                    font.family: "Segoe UI"
                    font.weight: Font.DemiBold
                }

        Label{
            id: label_number_passport
            anchors.top: number_textField.bottom
            anchors.left: bg_rectangle.left
            anchors.leftMargin: 20
            anchors.topMargin: 15
            text: "Номер паспорту"
            color: "#ffffff"
            font.pointSize: 14
        }
        

        CustomTextField {
                    id: number_passport_textField
                    width: send_to_card.width
                    height: 40
                    opacity: 1
                    color: "#ffffff"
                    placeholderTextColor: "#ffffff"
                    borderColor: "#55aaff"
                    placeholderText: "003253547"
                    anchors.top: label_number_passport.bottom
                    anchors.left: bg_rectangle.left
                    anchors.right: bg_rectangle.right
                    anchors.topMargin: 30
                    anchors.leftMargin: 20
                    anchors.rightMargin: 20
                    font.pointSize: 14
                    font.bold: true
                    font.family: "Segoe UI"
                    font.weight: Font.DemiBold
                }

        Label{
            id: label_password
            anchors.top: number_passport_textField.bottom
            anchors.left: bg_rectangle.left
            anchors.leftMargin: 20
            anchors.topMargin: 15
            text: "Пароль для користувача"
            color: "#ffffff"
            font.pointSize: 14
        }
        

        CustomTextField {
                    id: password_textField
                    width: send_to_card.width
                    height: 40
                    opacity: 1
                    color: "#ffffff"
                    placeholderTextColor: "#ffffff"
                    borderColor: "#55aaff"
                    placeholderText: "Пароль для користувача"
                    anchors.top: label_password.bottom
                    anchors.left: bg_rectangle.left
                    anchors.right: bg_rectangle.right
                    anchors.topMargin: 30
                    anchors.leftMargin: 20
                    anchors.rightMargin: 20
                    font.pointSize: 14
                    font.bold: true
                    font.family: "Segoe UI"
                    font.weight: Font.DemiBold
                }



         CustomButton{
                id: create_user
                width: 250
                height: 40
                text: "Створити"
                anchors.top: password_textField.bottom
                anchors.horizontalCenter: bg_rectangle.horizontalCenter
                colorMouseOver: "#40405f"
                colorDefault: "#33334c"
                anchors.topMargin: 25
                font.pointSize:16
                colorPressed: "#55aaff"
                onClicked: {
                    if (createUser()){
                        stackView.push("users.qml");
                    } else {
                        console.log("Помилка!")
                    }
                }
            }
    }

}