# FaceRecognitionSystemService

FaceRecognitionSystem 人脸识别系统的配套服务器 https://github.com/z695101385/FaceRecognitionSystem

项目描述

1、基于OpenCV 2.4.13的特征训练模块

2、基于CocoaAsyncSocket的人脸识别系统客户端的服务器端

3、特征库训练有两种方式，一种是在服务器端进行训练，另一种通过客户端上传特征

4、本项目未使用真正的数据库，而是将特征存在了database.plist中

5、分类器目前只有一种最近邻分类器，其他分类器正在编写中。。。

实现功能

1、若需要训练图像，输入训练图像所在文件夹，并按要求命名图像：ID-序号.扩展名 eg:张三-01.png

2、客户端发送特征得到库中最近结果

3、客户端上传特征与ID保存至服务器中

注意事项

1、端口随意填写（别用系统已经占用的端口）

2、修改数据文件database.plist的路径地址（ZCSaveTool中）

opencv官网http://opencv.org

注意！！！！本项目使用的是基于mac／Linux的OpenCV，并非客户端使用的基于iOS的OpenCV

注意！！！！本项目使用的是基于mac／Linux的OpenCV，并非客户端使用的基于iOS的OpenCV

注意！！！！本项目使用的是基于mac／Linux的OpenCV，并非客户端使用的基于iOS的OpenCV

安装方法自己百度，使用Homebrew安装，实在不会加我QQ695101385
