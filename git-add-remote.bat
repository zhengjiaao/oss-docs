@echo off&title add remote
@setlocal enableextensions
setlocal enabledelayedexpansion
@cd /d "%~dp0"

:: 执行命令 ./git-add-remote.bat

:: 添加多个远程地址
set github=git@github.com:zhengjiaao/oss-docs.git
set gitee=git@gitee.com:zhengjiaao/oss-docs.git
set gitlab=ssh://git@elbgit-1200450932.cn-northwest-1.elb.amazonaws.com.cn:5337/zhengja/oss-docs.git

:: 添加远程地址 解决github无法连接问题
if defined github (
    git remote rm origin
    echo add Remote github: %github%
    git remote add github %github%
    git remote add origin %github%
)

if defined gitee (
    echo add Remote gitee: %gitee%
    git remote add gitee %gitee%
    git remote set-url --add origin %gitee%
)

if defined gitlab (
    echo add Remote gitlab: %gitlab%
    git remote add gitlab %gitlab%
    git remote set-url --add origin %gitlab%
)



