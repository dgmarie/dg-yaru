#! /usr/bin/env bash
mkdir -p "${DESTDIR}/${2}"

ln -svf "${DESTDIR}/${1}/${3}" "${DESTDIR}/${2}"