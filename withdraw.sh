#!/bin/bash

## 处理源文件生成id和ip对应关系
idip(){
rm -rf  si_idip.txt

#for item in {1..10}; do

#   egrep 'InstanceId|PublicAddresses' si${item}.txt  -A 1  \
#   |egrep "InstanceId|43|101|129"  | sed 's/[[:space:]]//g'   | awk '{if(NR%2==0){printf $0 "\n"}else{printf"%s#",$0}}'  >> si_idip.txt

egrep  -E 'InstanceId|[0-9]{1,3}(\.[0-9]{1,3}){3}' si*.txt    | egrep -v "10.0(\.[0-9]{1,3}){2}"  | awk '{$1=""; print$0}'|  sed 's/[[:space:]]//g'| xargs -n2 -d'\n' >> si_idip.txt
#done
}

idip

## 过滤掉自己不想要的机器id
del_id(){
old_ip=$(cat old.txt)

for item in ${old_ip}; do
    echo "${item}"
    #sed -i "s/\<${item}\>/***/g" si_idip.txt
    sed -i "/\<${item}\>/d" si_idip.txt
done
}

del_id

## 生成最终可以直接复制的文档

finalize(){
for i in xaa{a..f}; do
echo $i

egrep "InstanceId" $i   | awk -F "," '{print $(NF-1)}' | awk -F ":" '{print $NF}' |tr "\n" "," >> $i.txt

done

}

# finalize()

## 生成100个id项目

cat si_idip.txt  | awk -F ":" '{print$2}' | awk '{print $1}'  | xargs -d "\n" -n100 > final.txt