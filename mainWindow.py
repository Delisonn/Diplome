# This Python file uses the following encoding: utf-8
from PySide2.QtGui import QGuiApplication
from PySide2.QtQml import QQmlApplicationEngine
from PySide2.QtCore import QObject, Slot, Signal, QTimer, QUrl, Signal, Property
import psycopg2
import hashlib
import random
from classes.config import db_host, db_name, db_password, db_user
from datetime import datetime, date, time
import os

users = {}
login = ...
user_id= 1

class MainWindow(QObject):
    modelChanged = Signal()

    def __init__(self):
        QObject.__init__(self)
        global users
        global login

    @Slot(str, str, result=bool)
    def auth(self, login_from_prog, password):
        try:
            connection = psycopg2.connect(
                host=db_host,
                user=db_user,
                password=db_password,
                database=db_name
            )

            connection.autocommit = True

            global users
            global login
            
            login = login_from_prog

            with connection.cursor() as cursor:
                cursor.execute(f"""
                SELECT * FROM users WHERE email = '{login_from_prog}'""")
            
                item = cursor.fetchone()
                users[login_from_prog] = {
                    'id': item[0],
                    'salt': bytes.fromhex(item[5]),
                    'key': bytes.fromhex(item[4])
                }

                salt = users[login_from_prog]['salt']
                key = users[login_from_prog]['key']

                check_key = hashlib.pbkdf2_hmac(
                    'sha256',
                    password.encode('utf-8'),
                    salt,
                    100000
                )

                if key == check_key:
                    print('Пароль введён верно!')
                else:
                    print('Пароль введён не верно!')
                return True if key == check_key else False
             

        except Exception as e:
            print(e)
        finally:
            if connection:
                connection.close()     
                
    @Slot(result=list)
    def authLevel(self):
        try:
            connection = psycopg2.connect(
                host=db_host,
                user=db_user,
                password=db_password,
                database=db_name
            )

            connection.autocommit = True

            with connection.cursor() as cursor:
                cursor.execute(f"""
                SELECT level FROM users WHERE id = {users[login]['id']}""")
            
                item = cursor.fetchone()
                print(item)
                return item                
        except Exception as e:
            print(e)
        finally:
            if connection:
                connection.close()     
                
    

    @Slot(result=list)
    def showCards(self):
        try:
            connection = psycopg2.connect(
                host=db_host,
                user=db_user,
                password=db_password,
                database=db_name
            )

            connection.autocommit = True

            with connection.cursor() as cursor:
                cursor.execute(f"""
                SELECT * FROM cards WHERE user_id = {users[login]['id']}""")
                main_list = []
                
                items = cursor.fetchall()
                main_list = [[str(i) if isinstance(i, date) else i for i in item] for item in items]

                return main_list
        except Exception as e:
            print(e)
        finally:
            if connection:
                connection.close()   
                
    @Slot(result=list)
    def showUsers(self):
        try:
            connection = psycopg2.connect(
                host=db_host,
                user=db_user,
                password=db_password,
                database=db_name
            )

            connection.autocommit = True

            with connection.cursor() as cursor:
                cursor.execute(f"""
                SELECT * FROM users WHERE NOT id = {users[login]['id']}""")
                main_list = []
                
                items = cursor.fetchall()
                main_list = [[str(i) if isinstance(i, date) else i for i in item] for item in items]

                return main_list
        except Exception as e:
            print(e)
        finally:
            if connection:
                connection.close()   

    @Slot(str, str, str, result=bool)
    def sendMoney(self, from_card_num, to_card_num, sum):
        try:
            connection = psycopg2.connect(
                host=db_host,
                user=db_user,
                password=db_password,
                database=db_name
            )

            connection.autocommit = True

            with connection.cursor() as cursor:
                cursor.execute(f"""UPDATE cards SET balance = balance + CAST({sum} AS MONEY)  WHERE card_num = CAST({to_card_num} AS BIGINT);
                UPDATE cards SET balance = balance - CAST({sum} AS MONEY) WHERE card_num = CAST({from_card_num} AS BIGINT); 
                INSERT INTO public.transfers(sender_id, receiver_id, sender_card_id, receiver_card_id, amount, send_date, send_time)
                VALUES ( (SELECT user_id FROM public.cards WHERE card_num = {from_card_num}),
                         (SELECT user_id FROM public.cards WHERE card_num = {to_card_num}), 
                         (SELECT id FROM public.cards WHERE card_num = {from_card_num}),
                         (SELECT id FROM public.cards WHERE card_num = {to_card_num}), 
                         {sum}, '{datetime.now()}', '{datetime.now().time()}');""")


                if cursor.statusmessage:
                    return True
                else:
                    return False
        except Exception as e:
            print(e)
        finally:
            if connection:
                connection.close()
                
    @Slot(str, str, str, result=float)
    def strSum(self, balance, plus, minus):
        balance = balance[1:].replace(',','').replace('\u202f','')
        amount = float(balance) / (float(balance) + float(plus) + float(minus))
        print(amount)
        return amount
    
    @Slot(str, str, str, result=float)
    def strSumOrange(self, balance, plus, minus):
        balance = balance[1:].replace(',','').replace('\u202f','')
        amount = float(minus) / (float(balance) + float(plus) + float(minus))
        print(amount)
        return amount
    
                
    @Slot(int, result=float)
    def showPlusBalance(self, receiver_card_id):
        try:
            connection = psycopg2.connect(
                host=db_host,
                user=db_user,
                password=db_password,
                database=db_name
            )

            connection.autocommit = True
            main_list = []
            with connection.cursor() as cursor:
                cursor.execute(f"""SELECT amount FROM transfers WHERE receiver_id = {users[login]['id']} AND receiver_card_id = {receiver_card_id};""")
                items = cursor.fetchall()
                amount = 0
                for i in items:
                    for j in i:
                        amount += float(j[1:].replace(',','.').replace('\u202f',''))
                return amount
        except Exception as e:
            print(e)
        finally:
            if connection:
                connection.close()
                
    @Slot(int, result=float)
    def showMinusBalance(self, receiver_card_id):
        try:
            connection = psycopg2.connect(
                host=db_host,
                user=db_user,
                password=db_password,
                database=db_name
            )

            connection.autocommit = True
            main_list = []
            with connection.cursor() as cursor:
                cursor.execute(f"""SELECT amount FROM transfers WHERE sender_id = {users[login]['id']} AND sender_card_id = {receiver_card_id};""")
                items = cursor.fetchall()
                amount = 0
                for i in items:
                    for j in i:
                        amount += float(j[1:].replace(',','.').replace('\u202f',''))
                return amount
        except Exception as e:
            print(e)
        finally:
            if connection:
                connection.close()
                

    @Slot(result=list)
    def showTransactions(self):
        try:
            connection = psycopg2.connect(
                host=db_host,
                user=db_user,
                password=db_password,
                database=db_name
            )

            connection.autocommit = True
            main_list = []
            with connection.cursor() as cursor:
                cursor.execute(f"""SELECT id, (SELECT first_name FROM users WHERE id = sender_id), (SELECT second_name FROM users WHERE id = sender_id), (SELECT first_name FROM users WHERE id = receiver_id), (SELECT second_name FROM users WHERE id = receiver_id), sender_card_id, receiver_card_id, amount, send_date, send_time, receiver_id, sender_id
		FROM transfers WHERE sender_id = {users[login]['id']} OR receiver_id = {users[login]['id']};""")
                items = cursor.fetchall()
                main_list = [[str(i) if isinstance(i, date) or isinstance(i, time) else i for i in item] for item in items]
                main_list.sort(key= lambda x: (x[8], x[9]), reverse=True)
                return main_list
        except Exception as e:
            print(e)
        finally:
            if connection:
                connection.close()
                
                
    @Slot(int, result=list)
    def showTransactionsForAdmin(self, user_id):
        try:
            connection = psycopg2.connect(
                host=db_host,
                user=db_user,
                password=db_password,
                database=db_name
            )

            connection.autocommit = True
            main_list = []
            with connection.cursor() as cursor:
                cursor.execute(f"""SELECT id, (SELECT first_name FROM users WHERE id = sender_id), (SELECT second_name FROM users WHERE id = sender_id), (SELECT first_name FROM users WHERE id = receiver_id), (SELECT second_name FROM users WHERE id = receiver_id), sender_card_id, receiver_card_id, amount, send_date, send_time, receiver_id, sender_id
		FROM transfers WHERE sender_id = {user_id} OR receiver_id = {user_id};""")
                items = cursor.fetchall()
                print(user_id)
                main_list = [[str(i) if isinstance(i, date) or isinstance(i, time) else i for i in item] for item in items]
                main_list.sort(key= lambda x: (x[8], x[9]), reverse=True)
                # print(main)
                return main_list
        except Exception as e:
            print(e)
        finally:
            if connection:
                connection.close()
            
    @Slot(int, result=bool)
    def checkTransaction(self, transaction_id):
        try:
            connection = psycopg2.connect(
                host=db_host,
                user=db_user,
                password=db_password,
                database=db_name
            )

            connection.autocommit = True
            
            with connection.cursor() as cursor:
                cursor.execute(f"""SELECT * FROM transfers WHERE receiver_id = {users[login]['id']} AND id = {transaction_id};""")
                items = cursor.fetchall()
                if bool(items):
                    return False
                else: 
                    return True
        except Exception as e:
            print(e)
        finally:
            if connection:
                connection.close()
    
    @Slot(str)
    def copyToClipboard(self, line):
        clipboard = QGuiApplication.clipboard()
        clipboard.setText(line)
        
    @Slot(str, str, str, str, str, str, result=bool)
    def createUser(self, first_name, second_name, email, password, number, passport_number):
        try:
            connection = psycopg2.connect(
                host=db_host,
                user=db_user,
                password=db_password,
                database=db_name
            )
            connection.autocommit = True
            
            # username = input('Введите имя: ')
            # pas = input('Введите пароль: ')

            salt = os.urandom(32) 

            key = hashlib.pbkdf2_hmac(
                'sha256',
                password.encode('utf-8'),
                salt,
                100000
            )

            today = datetime.now().date()

            # Insert data into a table
            with connection.cursor() as cursor:
                cursor.execute(
                    "INSERT INTO users (first_name, second_name, email, password, salt, reg_date, score, phone_number, passport_number) VALUES(%s, %s, %s, %s, %s, %s, %s, %s, %s);", (first_name, second_name, email, key.hex(), salt.hex(), today, random.randint(100000, 1000000), number, passport_number)
                )

                # print(f'{cursor.fetchone()}')
                print(f'Success')
                return True
        except Exception as e:
                print(e)
                return False
        finally:
            if connection:
                connection.close()        

    @Slot(str, str, str, str, str, int, result=bool)
    def updateUser(self, first_name, second_name, email, number, passport_number, user_id):
        try:
            connection = psycopg2.connect(
                host=db_host,
                user=db_user,
                password=db_password,
                database=db_name
            )
            connection.autocommit = True

            # Insert data into a table
            with connection.cursor() as cursor:
                cursor.execute(
                    "UPDATE users SET first_name = %s, second_name = %s, email = %s, phone_number = %s, passport_number = %s WHERE id = %s;", (first_name, second_name, email, number, passport_number, user_id)
                )

                # print(f'{cursor.fetchone()}')
                print(f'Success')
                return True
        except Exception as e:
                print(e)
                return False
        finally:
            if connection:
                connection.close()  

    @Slot(int, result=list)
    def showUser(self, user_id):
        try:
            connection = psycopg2.connect(
                host=db_host,
                user=db_user,
                password=db_password,
                database=db_name
            )
            connection.autocommit = True
            

            # Insert data into a table
            with connection.cursor() as cursor:
                cursor.execute(
                    f"SELECT * FROM users WHERE id = {user_id};"
                )
                items = cursor.fetchone()
                print(items)
                return items
                print(f'Success')
                return True
        except Exception as e:
                print(e)
                return False
        finally:
            if connection:
                connection.close()
    
    @Slot(int, result=bool)
    def deleteUser(self, user_id):
        try:
            connection = psycopg2.connect(
                host=db_host,
                user=db_user,
                password=db_password,
                database=db_name
            )
            connection.autocommit = True
            
            with connection.cursor() as cursor:
                cursor.execute(
                    f"DELETE FROM users WHERE id = {user_id};"
                )

                print(f'Success')
                return True
        except Exception as e:
                print(e)
                return False
        finally:
            if connection:
                connection.close()
            
    @Slot(str, str, str)    
    def createCard(self, card_type, first_num ,credit_limit):
        try:
            connection = psycopg2.connect(
                    host=db_host,
                    user=db_user,
                    password=db_password,
                    database=db_name
                )

            connection.autocommit = True

            today = datetime.now().date()
            cardNum = first_num + "".join([random.randint(0,9).__str__() for i in range(15)])
            cvv = "".join([random.randint(0,9).__str__() for i in range(3)])
            if isinstance(credit_limit, float):
                with connection.cursor() as cursor:
                    cursor.execute(f"INSERT INTO cards (user_id, card_type, card_num, card_date_start, card_date_end, cvv, balance, credit_limit) VALUES({users[login]['id']}, '{card_type}', {int(cardNum)}, '{today}', '{today.replace(year=today.year + 4)}', {int(cvv)}, 0, {float(credit_limit)});")
            else:
                with connection.cursor() as cursor:
                    cursor.execute(f"INSERT INTO cards (user_id, card_type, card_num, card_date_start, card_date_end, cvv, balance, credit_limit) VALUES({users[login]['id']}, '{card_type}', {int(cardNum)}, '{today}', '{today.replace(year=today.year + 4)}', {int(cvv)}, 0, 0);")

        except Exception as e:
            print(e)
        finally:
            if connection:
                connection.close()     
                print('[INFO] Connection closed')
    

    modelCards = Property(list, fget=showCards, notify=modelChanged)



