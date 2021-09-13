#!/bin/sh
git diff --cached --name-only --diff-filter=M -z $against -- | while read -d $'\0' f; do
fileName="${f##*/}"
checkFileName=".git\COMMIT_EDITMSG"
warnFileNames=("ProjectSettings.asset" "GraphicsSettings.asset" "EditorBuildSettings.asset" "QualitySettings.asset" "UniversalRP_HighQuality.asset" "UniversalRP_LowQuality.asset" "UniversalRP_MediumQuality.asset" "UniversalRP_PerfectQuality.asset" "ForwardRenderer.asset")

for warnFileName in ${warnFileNames[@]}
do
	if [ "$fileName" = "$warnFileName" ]; then
		while read line; do
			if [[ "$line" != 'Merge'* && "$line" != *"$warnFileName"* ]]
			then
				cat <<EOF
Error: 注意啦，这是一个特别的文件，你真的要提交吗？
如果你确定是要提交这个文件的修改，请对本次提交的描述进行修改，详见下句：

Please add \`$fileName' to your message in the first line!
EOF
				exit 1
			fi
			break
		done < $checkFileName 
	fi
done
done