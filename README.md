# Mushare


![此处应有图片](https://github.com/Fayedy/Mushare/blob/master/image/logo.jpg)

Mushare is a music sharing app using swift.

## Mushare基本功能
Mushare可以实现歌单推荐，音乐播放、下载和收藏，歌词显示，动态分享，用户登录。

## 界面及运行流程
Mushare的主界面为分栏控制器，由四个导航控制器管理四个栏目：发现音乐、我的音乐、动态、账号，进入APP时默认为发现音乐界面。  
各个页面右上角均有一个**按键**可以进入当前播放页面。

###发现音乐
**1. 歌单推荐**

![此处应有图片](https://github.com/Fayedy/Mushare/blob/master/image/find.png)

界面的上半部分为Scroll View，能够循环显示图片。  
下半部分为一个Container View，使用Embed segue显示一个Table View Controller Scene，其中每个Cell显示的是推荐歌单的名称。
   
**2. 歌单内容**

![此处应有图片](https://github.com/Fayedy/Mushare/blob/master/image/album.png)
   
点击歌单后使用Show segue转向下一个Table View，列出此歌单内的所有歌曲的详细信息（歌曲名、歌手名、专辑图片）。  

**3. 播放页面**

![此处应有图片](https://github.com/Fayedy/Mushare/blob/master/image/play.png)

播放页面的排版使用了自动布局，以使界面更整齐美观。  
背景图使用了UIBlurEffect给专辑图片添加模糊效果。  
Txt View根据当前播放位置滚动歌词。
点击下载键可以下载歌曲到本地，下一次播放直接从本地资源中获取歌曲；收藏键可以添加歌曲至我的收藏；每次播放后歌曲信息将存入数据库。  
MPMoviePlayerController用来播放歌曲。并在点击后相应图标会发生改变。   
右上角的分享键可以将歌曲分享到动态。

**4. 搜索页面**

![此处应有图片](https://github.com/Fayedy/Mushare/blob/master/image/Search.png)

在发现音乐的左上角点击搜索按钮可以跳转至搜索页面。  
搜索页面由Search Bar和Table View组成，在搜索框中输入歌曲名称后，在列表显示搜索到的歌曲信息，点击之后跳转到播放页面播放。用UISearchBarDelegate来代理搜索框的行为。


###我的音乐

**1. 本地音乐**

![此处应有图片](https://github.com/Fayedy/Mushare/blob/master/image/download.png)

在歌曲的播放页面点击下载后，所下载的歌曲便会加入到本地音乐列表。
本地音乐列表是一个Table View，每一个cell显示歌曲信息，和发现音乐的歌单内容表示方式一致，显示歌曲信息、歌手信息及歌曲专辑图片

**2. 最近播放**

![此处应有图片](https://github.com/Fayedy/Mushare/blob/master/image/recent.png)

歌曲每一次播放后，若之前没有加入到最近播放列表，便会添加。此处只是简单的处理：调用SongList中的get函数来查找列表中是否有对应的歌曲，并没有把最近播放的歌曲按时间排序。显示方式同上。

**3. 我的收藏**

![此处应有图片](https://github.com/Fayedy/Mushare/blob/master/image/like.png)

歌曲的播放页面上点击我喜欢按钮后，该歌曲会添加到我的收藏列表。显示方式同上。

###动态

**1. 动态展示**

![此处应有图片](https://github.com/Fayedy/Mushare/blob/master/image/Moment.png)  

可以显示添加的新动态。

**2. 添加动态**

![此处应有图片](https://github.com/Fayedy/Mushare/blob/master/image/newMoment.png)

点击左上角的添加按钮，转到新建动态页面，可以添加文字和图片描述。


###账号

![此处应有图片](https://github.com/Fayedy/Mushare/blob/master/image/account.png)

**1. 用户登录**

第一次进入应用时，页面会显示**账号**和**密码**Label以及相应的TextField，在输入用户名和密码后，点击**登录**键，会显示用户名和用户头像。在DataCenter中有一个Account类的**me**用户，将登录时输入的用户名、用户密码以及用户头像存入**me**用户。

**2. 修改头像**

用户头像初始化为默认图片，若需修改，可以点击图片进入相册选择图片。该功能通过ImagePickerController，type设为.Library，表示从相册获取图片，在使用时用ImagePickerControllerDelegate和UINavigationControllerDelegate进行代理。

## 使用到的技术
**1. 网络通信Almafire && SwiftyJSON**

用request命令向网络发送请求，默认方法为.get，也可修改为.post，然后调用responseJSON获得JSON解析，获取歌曲信息并存入相应结构。

**2. FMDB数据库**

FMDB封装了SQLite，可以使用SQL命令对数据库进行操作。首先建立BaseDB并新建SongList类继承于BaseDB，SongList类中封装了对数据库的操作：get(), getName(), getAll(), insert(), delete()等操作。整个应用都是建立在SongList数据库之上。



##有待改进

* 没能实现预期的导入通讯录功能
* ScrollView点击一直出现bug，本想点击页面实现对应歌曲的播放，但由于时间原因调试不出来，为了维持程序的正常运行，将UserInteraction设为了false。
* 最近播放列表没有按时间排序，仅仅添加进歌单
* 登录本质上并没有实现，页面切换也比较简陋
* 由于歌曲源的问题，会偶尔出现歌曲会无法播放或者无法自动下一首，而本次并没有对相关部分进行检查和修改。

##代码行数

4005

   

   
   