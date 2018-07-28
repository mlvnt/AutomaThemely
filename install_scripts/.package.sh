#!/bin/bash

declare -a outputs=("deb" "rpm" "sh")
declare -a pypacks=("astral" "requests" "tz" "tzlocal" "schedule")
declare -a otherdeps=("python3-pip")

deps=""
for p in "${pypacks[@]}"
do
	deps="$deps-d python3-$p "
done

for d in "${otherdeps[@]}"
do
	deps="$deps-d $d "
done

for out in "${outputs[@]}"
do
	fpm -s python -t "${out}" -f -n 'automathemely' --python-bin python3 --python-pip pip3 \
	--python-package-name-prefix python3 --no-python-dependencies ${deps}--after-install postinst.sh \
	--before-remove preremove.sh ../setup.py
done

version="$(echo *.deb | grep -o -P '(?<=_).*(?=_)')"
if [ "$version" != "" ]
then
	shopt -s extglob
	mkdir "../releases/v$version"
	mv automathemely* "../releases/v$version"
fi