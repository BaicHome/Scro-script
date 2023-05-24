import os
import sys
from crontab import CronTab
from PyQt5.QtWidgets import QApplication, QWidget, QComboBox, QLabel, QLineEdit, QPushButton, QVBoxLayout, QHBoxLayout, QMessageBox


class MainWindow(QWidget):
    def __init__(self):
        super().__init__()

        self.initUI()

    def initUI(self):
        # 创建控件
        self.time_label = QLabel('执行时间：')
        self.time_combobox = QComboBox()
        self.time_combobox.addItems(['每分钟', '每小时', '每天', '每周'])
        self.command_label = QLabel('执行命令：')
        self.command_edit = QLineEdit()
        self.submit_button = QPushButton('提交')
        self.submit_button.clicked.connect(self.submit)

        # 布局控件
        vbox = QVBoxLayout()
        hbox1 = QHBoxLayout()
        hbox1.addWidget(self.time_label)
        hbox1.addWidget(self.time_combobox)
        vbox.addLayout(hbox1)
        hbox2 = QHBoxLayout()
        hbox2.addWidget(self.command_label)
        hbox2.addWidget(self.command_edit)
        vbox.addLayout(hbox2)
        vbox.addWidget(self.submit_button)
        self.setLayout(vbox)

        # 设置窗口属性
        self.setWindowTitle('定时任务配置')
        self.setGeometry(300, 300, 300, 150)
        self.show()

    def submit(self):
        # 获取用户输入
        time = self.time_combobox.currentText()
        command = self.command_edit.text()

        # 配置定时任务
        cron = CronTab(user='root')
        job = cron.new(command=command)
        if time == '每分钟':
            job.setall('* * * * *')
        elif time == '每小时':
            job.setall('0 * * * *')
        elif time == '每天':
            job.setall('0 0 * * *')
        elif time == '每周':
            job.setall('0 0 * * 0')
        cron.write()

        # 提示用户配置成功
        QMessageBox.information(self, '提示', '定时任务配置成功！')


def check_install(package):
    try:
        __import__(package)
    except ImportError:
        os.system('pip install ' + package)


if __name__ == '__main__':
    # 检测并安装必需的依赖和第三方库
    check_install('python-crontab')
    check_install('PyQt5')

    # 检测是否已安装crontab，如未安装，则自动进行安装。
    if not os.path.exists('/usr/bin/crontab'):
        os.system('apt-get update')
        os.system('apt-get install -y cron')

    # 显示图形化界面，要求用户选择/输入执行时间和需要执行的shell命令
    app = QApplication(sys.argv)
    window = MainWindow()
    sys.exit(app.exec_())
