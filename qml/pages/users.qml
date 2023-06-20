import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.15
import "../components"
import QtQuick.Timeline 1.0

    Item {
        property bool showValue: true
        property bool showAccess: false
        property var one_user: backend.showUsers()
        property var users: one_user.length

        function createUsers(list){
            // console.log(list)
            return {
                id: list[0],
                first_name: list[1],
                second_name: list[2],
                email: list[3],
                reg_date: list[6],
                score: list[7]
            };
        }    
        id: select_users_bg
        Flickable {
            id: flickable
            opacity: 1
            anchors.fill: parent
            clip: true
                

                ListModel{
                    id: userModel

                    Component.onCompleted: {
                        for (var i = 0; i < users; i++) {
                            var user = createUsers(one_user[i]);
                            user.showAccess = false; // Добавляем свойство showAccess в модель и устанавливаем его значение
                            append(user);
                        }
                    }
                }

                Component{
                    id: cardDelegate 
                        Rectangle {
                            id: user
                            color: "#27273a"
                            height: 220
                            width: flickable.width
                            radius: 10   

                        Label{
                            id:registration_date
                            anchors.top: user.top
                            anchors.left: user.left
                            anchors.topMargin: 15
                            anchors.leftMargin: 15
                            text: "Дата реєстрації: " + reg_date
                            color:"#767676"
                            font.pointSize: 12
                        }

                        Label{
                            id:first_name_user
                            anchors.top: registration_date.bottom
                            anchors.left: user.left
                            anchors.topMargin: 15
                            anchors.leftMargin: 15
                            text: "Ім'я: " + first_name
                            color:"#ffffff"
                            font.pointSize: 14
                        }

                        Label{
                            id:second_name_user
                            anchors.top: first_name_user.bottom
                            anchors.left: user.left
                            anchors.topMargin: 15
                            anchors.leftMargin: 15
                            text: "Призвіще: " + second_name
                            color:"#ffffff"
                            font.pointSize: 14
                        }

                        Label{
                            id:email_user
                            anchors.top: second_name_user.bottom
                            anchors.left: user.left
                            anchors.topMargin: 15
                            anchors.leftMargin: 15
                            text: "Email: " + email
                            color:"#ffffff"
                            font.pointSize: 14
                        }

                        Label{
                            id:score_num_user
                            anchors.top: email_user.bottom
                            anchors.left: user.left
                            anchors.topMargin: 15
                            anchors.leftMargin: 15
                            text: "Рахунок: " + score
                            color:"#ffffff"
                            font.pointSize: 14
                        }



                        MouseArea{
                            anchors.fill: parent
                            onClicked: {

                                var selectedItem = userModel.get(index) // Получаем выбранный элемент из модели
                                if (selectedItem !== null) {
                                    stackView.push("users_transaction.qml", { userId: selectedItem.id })
                                }
                            }
                        }

                        CustomButton{
                            id: createCard
                            width: 200
                            height: 40
                            text: "Редагувати"
                            anchors.bottom: user.bottom
                            anchors.horizontalCenter: user.horizontalCenter
                            colorMouseOver: "#40405f"
                            colorDefault: "#33334c"
                            anchors.bottomMargin: 15
                            font.pointSize:16
                            colorPressed: "#55aaff"
                            onClicked: {
                                listView.currentIndex = index
                                var selectedItem = userModel.get(index) // Получаем выбранный элемент из модели
                                if (selectedItem !== null) {
                                    stackView.push("updateUser.qml", { userId: selectedItem.id })
                                }
                            }
                        }

                        CustomButton{
                            id: delete_user
                            width: 50
                            height: 50
                            text: "X"
                            anchors.right: user.right
                            anchors.verticalCenter: user.verticalCenter
                            anchors.rightMargin: 15
                            colorMouseOver: "#40405f"
                            colorDefault: "#33334c"
                            font.pointSize:18
                            colorPressed: "#55aaff"
                            onClicked: {
                                listView.currentIndex = index
                                showAccess = !showAccess
                                // backend.deleteUser(selectedItem.id)
                                
                                for (var i = 0; i < userModel.count; i++) {
                                    if (i === index) {
                                        userModel.setProperty(i, "showAccess", showAccess);
                                    } else {
                                        userModel.setProperty(i, "showAccess", false);
                                    }
                                }
                            }
                        }

                        CustomButton{
                            id: access_delete_user
                            width: 100
                            height: 50
                            text: "Підтвердіть"
                            anchors.right: delete_user.left
                            anchors.verticalCenter: user.verticalCenter
                            anchors.rightMargin: 10
                            visible: showAccess
                            colorMouseOver: "#40405f"
                            colorDefault: "#33334c"
                            font.pointSize:13
                            colorPressed: "#55aaff"
                            onClicked: {
                                listView.currentIndex = index
                                // backend.deleteUser(selectedItem.id)


                                var selectedItem = userModel.get(index) // Получаем выбранный элемент из модели
                                if (selectedItem !== null) {
                                    backend.deleteUser(selectedItem.id)
                                    stackView.push("users.qml")
                                }

                                
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
                    model: userModel
                    delegate: cardDelegate 
                }

                CustomButton{
                    id: createCard
                    width: 250
                    height: 40
                    text: "Створити користувача"
                    anchors.top: listView.bottom
                    anchors.horizontalCenter: listView.horizontalCenter
                    colorMouseOver: "#40405f"
                    colorDefault: "#33334c"
                    anchors.topMargin: 25
                    font.pointSize:16
                    colorPressed: "#55aaff"
                    onClicked: {
                        stackView.push("createUser.qml")
                    }
                }
            }
        }
    