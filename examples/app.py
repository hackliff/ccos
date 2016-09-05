#! /usr/bin/env python
# -*- coding: utf-8 -*-
# vim:fenc=utf-8
#
# Copyright © 2016 hackliff <xavier.bruhiere@gmail.com>
# Distributed under terms of the MIT license.

"""
Experimental configuration from stdin.
"""

import sys

import yaml

def config(stream):
    """Load yaml content on the given stream interface."""
    content = ''.join([line for line in stream])
    return yaml.load(content)


if __name__ == '__main__':
    conf = config(sys.stdin)
    print('like listening on {}:{} ({})'.format(conf['server']['host'],
                                                conf['server']['port'],
                                                conf['api_key']))
