#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# vi: set ft=python :

import sys
from os import environ, path, listdir, remove
from shutil import move, rmtree

PREFIX = environ.get('MESON_INSTALL_DESTDIR_PREFIX', '/usr')
data_dir = sys.argv[1]
project_name = sys.argv[2]
flavours = sys.argv[3:]

themes_dir = path.join(PREFIX, data_dir, 'themes')

for f in flavours:
    variant = 'dark' if f == 'dark' or f.endswith('-dark') else 'light'
    
    if f == 'light':
        suffix = ''
    else:
        suffix = '-' + f
    theme_name = project_name + suffix
    flavour_dir = path.join(themes_dir, theme_name, 'cinnamon')

    # rename cinnamon.css
    cinnamon_css_name = f + ".css"
    cinnamon_css_src = path.join(flavour_dir, cinnamon_css_name)
    if path.exists(cinnamon_css_src):
        cinnamon_css_dst = path.join(flavour_dir, 'cinnamon.css')
        move(cinnamon_css_src, cinnamon_css_dst)

    # rename assets dir
    assets = path.join(flavour_dir, 'assets')
    assets_dst = path.join(flavour_dir, variant + '-assets')
    if path.exists(assets):
        if path.isdir(assets_dst):
            rmtree(assets_dst)
        move(assets, assets_dst)
    
    # rename assets
    if suffix != '':
        common_assets = path.join(flavour_dir, 'common-assets')
        for i in assets_dst, common_assets:
            asset_dir = path.join(flavour_dir, i)
            for dir in listdir(asset_dir):
                asset_subdir = path.join(asset_dir, dir)
                for file in listdir(asset_subdir):
                    if file.endswith(suffix + '.svg'):
                        print(file)
                        file_dst = path.join(asset_subdir, file.split(suffix)[0])
                        file = path.join(asset_subdir, file)
                        if path.isfile(file_dst):
                            remove(file_dst)
                        move(file, file_dst)
