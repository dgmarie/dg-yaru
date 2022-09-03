#!/bin/bash

mkdir -p "${DESTDIR}/${2}"

ln -s "${3}" "${DESTDIR}/${2}/${1}.tmp"
mv "${DESTDIR}/${2}/${1}.tmp" "${DESTDIR}/${2}/${1}"
