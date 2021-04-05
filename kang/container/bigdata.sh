docker run -d -it --name=ubuntu daocloud.io/library/ubuntu:18.04 /bin/bash

# ubuntu 配置阿里云源
cp /etc/apt/sources.list /etc/apt/sources.list.backup
sed -i "s/archive.ubuntu.com/mirrors.aliyun.com/g" /etc/apt/sources.list
apt-get -y update

# 安装系统库依赖
apt-get -y install apt-transport-https ca-certificates curl software-properties-common
apt-get install -y openjdk-8-jre openjdk-8-jdk-headless

wget https://mirrors.bfsu.edu.cn/apache/hive/hive-3.1.2/apache-hive-3.1.2-bin.tar.gz

tar xvzf apache-hive-3.1.2-bin.tar.gz

mv apache-hive-3.1.2-bin /opt/hive

export HIVE_HOME=/opt/hive/
export PATH=${HIVE_HOME}/bin:$PATH

export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export JRE_HOME=${JAVA_HOME}/jre  
export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib  
export PATH=${JAVA_HOME}/bin:$PATH

source ~/.bashrc
cp hive-env.sh.template hive-env.sh
wget -P $HIVE_HOME/lib https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.20/mysql-connector-java-8.0.20.jar

cd $HIVE_HOME/conf
vim hive-site.xml

~~~
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
    <?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
    <configuration>
        <property>
            <name>javax.jdo.option.ConnectionURL</name>
            <value>jdbc:mysql://106.75.100.82:33060/bigdata_test?useSSL=false</value>
            <description>JDBC connect string for a JDBC metastore</description>
        </property>
        <property>
            <name>javax.jdo.option.ConnectionDriverName</name>
            <value>com.mysql.jdbc.Driver</value>
            <description>Driver class name for a JDBC metastore</description>
        </property>
        <property>
            <name>javax.jdo.option.ConnectionUserName</name>
            <!--MySQL账号-->
            <value>dev</value>
            <description>username to use against metastore database</description>
        </property>
        <property>
            <name>javax.jdo.option.ConnectionPassword</name>
            <!--MySQL密码-->
            <value>dev@bugmaker</value>
            <description>password to use against metastore database</description>
        </property>
    </configuration>
~~~

vim /etc/hosts
# 文件末尾增加
172.17.0.2      9d966ccd9261

apt-get install -y openssh-client openssh-server
ssh-keygen -t rsa
cat ~/.ssh/id_rsa.pub >> authorized_keys
# chmod 600 authorized_keys

# hadoop  https://dgideas.net/2020/install-hadoop-on-ubuntu-20-04/
useradd -m hadoop -s /bin/bash
passwd hadoop
adduser hadoop sudo

wget https://archive.apache.org/dist/hadoop/common/hadoop-2.8.5/hadoop-2.8.5.tar.gz
tar -xzvf hadoop-2.8.5.tar.gz

export HADOOP_HOME=/hadoop-2.8.5
export HADOOP_INSTALL=$HADOOP_HOME
export HADOOP_MAPRED_HOME=$HADOOP_HOME
export HADOOP_COMMON_HOME=$HADOOP_HOME
export HADOOP_HDFS_HOME=$HADOOP_HOME
export YARN_HOME=$HADOOP_HOME
export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
export PATH=$PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin
export HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib/native"
source ~/.bashrc

sudo -u hadoop ssh-keygen -b 4096 -C hadoop
sudo -u hadoop ssh-copy-id localhost -p 22

vim /hadoop-2.8.5/etc/hadoop/hadoop-env.sh    检查 JAVA_HOME HADOOP_CONF_DIR

mkdir -p /home/hadoop/hdfs/namenode /home/hadoop/hdfs/datanode


<configuration>
    <property>
        <name>dfs.replication</name>
        <value>1</value>
    </property>
    <property>
        <name>dfs.name.dir</name>
        <value>/home/hadoop/hdfs/namenode</value>
    </property>
    <property>
        <name>dfs.data.dir</name>
        <value>/home/hadoop/hdfs/datanode</value>
    </property>
</configuration>


# hdfs namenode -format
# hadoop/sbin  启用成功后可用 jps 命令查看
./start-dfs.sh
./start-yarn.sh
./mr-jobhistory-daemon.sh start historyserver
