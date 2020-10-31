#!/bin/bash
#clear

# Просим ввести путь папки формата /../...../*

echo "Путь папки (/../...../*):"
read path

# очищаем старые данные таблицы с результатами
rm result.xls
# создаем таблицу
echo -e "Name \t Extension \t Date \t Size \t Duration" >> result.xls
# чтение файлов с пробелами в имени
IFS=$'\n'

for file in $path
do
	filename="${file##*/}"

	# вывод имени файла в таблицу
	Name=$(echo "$filename" | sed 's/\.[^.]*$//')
	echo $Name

	# вывод расширения файла
	Extension=$(echo "$filename" | sed 's/^.*\.//')
	echo $Extension

	# вывод даты последнего изменения файла
	Date=$(stat -c "%y" "$file" | awk '{print $1}')
	echo $Date
	
	# вывод размера файла
	Size=$(du -sh "$file" | awk '{print $1}')
	echo $Size	

	# проверка, является ли файл - директорией
	if [[ -d "$file" ]];
		then
		Extension="dir"
	fi

	# вывод длительности видео/аудио
	Duration=$(ffmpeg -i $file 2>&1 | grep Duration | awk '{print $2}')

	# вывод результатов в таблицу result.xls
	echo -e "$Name \t $Extension \t $Date \t $Size \t $Duration" >> result.xls
done

