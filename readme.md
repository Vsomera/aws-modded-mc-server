
# Cloud Hosted Minecraft Server [Forge]

Terraform scripts to quickly deploy a modded minecraft server onto aws
- Works for Forge mc versions 1.18.x -up to-> 1.21.x

## Prerequisites & Setup

Install the following :
- Terraform [https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli]
- AWS CLI [https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html]

Setup the following :
- AWS Account [https://aws.amazon.com/resources/create-account/]
- Connect AWS account to AWS CLI by [creating an access key](https://www.youtube.com/watch?v=vZXpmgAs91s)


## Clone Repository

Clone repo with git :

```bash
git clone github.com/...
```
or
- Download the repo by clicking [ <> Code ] -> 'Download ZIP'
- Make sure to unzip the folder after downloading

## 1.) Configure the Following files
- Choose a unique name for your s3 bucket
- Replace all instances of `< s3_bucket_name >` in the files below with your chosen name (should all be the same name)
- Also remove `<` and `>` after editing

```
│   .gitignore
│   access.tf
│   main.tf                   <--- Edit < s3_bucket_name >
│   networking.tf
│
├───config
│       ec2_role.json
│       s3_policy.json        <--- Edit < s3_bucket_name >
│
├───setup
│       minecraft.service
│       readme.md
│
└───scripts
        user_data.sh          <--- Edit < s3_bucket_name >
```

## 2.) Transfer Files to S3 Bucket
- Download mod loader for minecraft version [pick between 1.18.x - 1.21.x](https://files.minecraftforge.net/net/minecraftforge/forge/)
    - Replace `<loader-xxxxx-installer.jar>` in `user_data.sh` to the name of your installer .jar file you downloaded

- Choose or use existing mods
    - Downloads mods : [Modrinth](https://www.curseforge.com/minecraft/mods) / [CurseForge](https://www.curseforge.com/minecraft/mods) (Must match minecraft version)

- Put all mods in a folder named `mods` and zip the folder to `mods.zip` 
    - You can optinally zip configs or defaultconfigs if you wish to add them to your server

```
│   .gitignore
│   access.tf
│   main.tf                 
│   networking.tf
│
├───config
│       ec2_role.json
│       s3_policy.json      
│
├───setup
│       mods.zip                <--- add mods.zip in setup folder
│       configs.zip             <--- optional
│       defaultconfigs.zip      <--- optional
│       minecraft.service
│       readme.md
│
└───scripts
        user_data.sh           <--- Edit < loader-x.xx.x-xx.x.x-installer.jar >
```
## 3.) Generate SSH key to access to Ec2 Instance
```
    ssh-keygen -t rsa -b 4096 -f ~/.ssh/mc-ec2-key
```
- You can also access your instance via aws by selecting your instance


## 4.) Apply Terraform Infastrucutre
- Navigate to root directory and run below command to deploy server
```
    terraform apply
```
- If your s3 bucket name is already taken, run `terraform destroy` and change the name of your s3 bucket. Then run `terraform apply`

## 5.) Edit `run.sh` and `user_jvm_args.txt` within ec2 instance
- SSH or visit AWS console to access the running ec2 instance
- Add changes to `./run.sh` : 
```
    java @user_jvm_args.txt @libraries/net/minecraftforge/forge/1.20.1-47.3.0/unix_args.txt --nogui "$@"
```
- Configure `user_jvm_args.txt` (uncomment the last line)
```
    -Xmx7G (ram allocation)
```

## 6.) Start server
```
    ./run.sh
```
or
```
    sudo systemctl start minecraft
```

- you can also run commands in the console using `screen`:
```
    screen -r minecraft
```