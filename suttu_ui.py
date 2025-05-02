# -*- coding: utf-8 -*-

################################################################################
## Form generated from reading UI file 'suttu.ui'
##
## Created by: Qt User Interface Compiler version 6.8.0
##
## WARNING! All changes made in this file will be lost when recompiling UI file!
################################################################################

from PySide6.QtCore import (QCoreApplication, QDate, QDateTime, QLocale,
    QMetaObject, QObject, QPoint, QRect,
    QSize, QTime, QUrl, Qt)
from PySide6.QtGui import (QAction, QBrush, QColor, QConicalGradient,
    QCursor, QFont, QFontDatabase, QGradient,
    QIcon, QImage, QKeySequence, QLinearGradient,
    QPainter, QPalette, QPixmap, QRadialGradient,
    QTransform)
from PySide6.QtWidgets import (QApplication, QDateEdit, QLabel, QMainWindow,
    QMenu, QMenuBar, QSizePolicy, QStatusBar,
    QTimeEdit, QWidget)
import suttu_rc

class Ui_MainWindow(object):
    def setupUi(self, MainWindow):
        if not MainWindow.objectName():
            MainWindow.setObjectName(u"MainWindow")
        MainWindow.resize(800, 600)
        self.actionOhjetila = QAction(MainWindow)
        self.actionOhjetila.setObjectName(u"actionOhjetila")
        self.actionOhjetila.setCheckable(True)
        icon = QIcon(QIcon.fromTheme(u"help-browser"))
        self.actionOhjetila.setIcon(icon)
        self.centralwidget = QWidget(MainWindow)
        self.centralwidget.setObjectName(u"centralwidget")
        self.dateEdit = QDateEdit(self.centralwidget)
        self.dateEdit.setObjectName(u"dateEdit")
        self.dateEdit.setGeometry(QRect(40, 50, 115, 24))
        self.dateEdit.setCalendarPopup(True)
        self.dateLabel = QLabel(self.centralwidget)
        self.dateLabel.setObjectName(u"dateLabel")
        self.dateLabel.setGeometry(QRect(180, 60, 71, 16))
        self.timeEdit = QTimeEdit(self.centralwidget)
        self.timeEdit.setObjectName(u"timeEdit")
        self.timeEdit.setGeometry(QRect(40, 90, 118, 24))
        self.timeEdit.setCalendarPopup(True)
        self.timeLabel = QLabel(self.centralwidget)
        self.timeLabel.setObjectName(u"timeLabel")
        self.timeLabel.setGeometry(QRect(180, 90, 71, 16))
        MainWindow.setCentralWidget(self.centralwidget)
        self.menubar = QMenuBar(MainWindow)
        self.menubar.setObjectName(u"menubar")
        self.menubar.setGeometry(QRect(0, 0, 800, 33))
        self.menuOhje = QMenu(self.menubar)
        self.menuOhje.setObjectName(u"menuOhje")
        MainWindow.setMenuBar(self.menubar)
        self.statusbar = QStatusBar(MainWindow)
        self.statusbar.setObjectName(u"statusbar")
        MainWindow.setStatusBar(self.statusbar)

        self.menubar.addAction(self.menuOhje.menuAction())
        self.menuOhje.addAction(self.actionOhjetila)

        self.retranslateUi(MainWindow)

        QMetaObject.connectSlotsByName(MainWindow)
    # setupUi

    def retranslateUi(self, MainWindow):
        MainWindow.setWindowTitle(QCoreApplication.translate("MainWindow", u"MainWindow", None))
#if QT_CONFIG(whatsthis)
        MainWindow.setWhatsThis(QCoreApplication.translate("MainWindow", u"<html><head/><body><p>Luettelo taulukkomudoss. Voit valita auton klikkaamalla taulukon solua. Valitsemasi auton rekisterinumero n\u00e4kyy n\u00e4yt\u00f6n alaosassa tilarivill\u00e4. <a href=\"https://www.youtube.com/\"><span style=\" text-decoration: underline; color:#003e92;\">youtube</span></a></p><p><img src=\":/suttu/uiPictures/VWnbg.png\"/></p></body></html>", None))
#endif // QT_CONFIG(whatsthis)
        self.actionOhjetila.setText(QCoreApplication.translate("MainWindow", u"Ohjetila", None))
        self.dateLabel.setText(QCoreApplication.translate("MainWindow", u"P\u00e4iv\u00e4m\u00e4\u00e4r\u00e4", None))
        self.timeLabel.setText(QCoreApplication.translate("MainWindow", u"Kellonaika", None))
        self.menuOhje.setTitle(QCoreApplication.translate("MainWindow", u"Ohje", None))
    # retranslateUi

