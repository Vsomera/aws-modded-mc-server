# Ec2 Commands

[. . /readme.md](../readme.md)
- Server files are stored in `/minecraft`
```
cd /minecraft
```

### 1.) download contents from s3 bucket
- replace `s3_bucket_name` to the name of your s3 bucket
- replace `loader-x.xx.x-xx.x.x-installer.jar` to the name of your .jar file

```bash
aws s3 cp s3://s3_bucket_name/setup/loader-x.xx.x-xx.x.x-installer.jar /minecraft/

aws s3 cp s3://s3_bucket_name/setup/mods.zip /minecraft/mods.zip
aws s3 cp s3://s3_bucket_name/setup/config.zip /minecraft/config.zip
aws s3 cp s3://s3_bucket_name/setup/defaultconfigs.zip /minecraft/defaultconfigs.zip
```

### 2.) unzip files
```bash
unzip -o mods.zip
unzip -o config.zip
unzip -o defaultconfigs.zip
```

### 3.) configure minecraft to start when booting up instance
- replace `s3_bucket_name` to the name of your s3 bucket
```bash
sudo aws s3 cp s3://s3_bucket_name/setup/minecraft.service /etc/systemd/system/minecraft.service

sudo systemctl daemon-reload
sudo systemctl enable minecraft
```

### 4.) install server
- replace `loader-x.xx.x-xx.x.x-installer.jar` to the name of your .jar file
```
java -jar loader-x.xx.x-xx.x.x-installer.jar --installServer
```

### 5.) Edit `run.sh` and `user_jvm_args.txt`
- Add changes to last line of `./run.sh` : 
```bash
// run.sh
java @user_jvm_args.txt @libraries/net/minecraftforge/forge/1.20.1-47.3.0/unix_args.txt --nogui "$@"
```
- Configure `user_jvm_args.txt` (uncomment the last line) set number to how much ram you want to allocate to minecraft
```bash
// user_jvm_args.txt
-Xmx7G
```


### 6.) Start server
```bash
./run.sh
```
or
```bash
sudo systemctl start minecraft
```

- you can also run commands in the server console using `screen`:
```bash
screen -r minecraft
```