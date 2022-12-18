#! /usr/bin/env bash
mkdir -p "${DESTDIR}/${2}"

ln -rsvf "${DESTDIR}/${1}/${3}" "${DESTDIR}/${2}"