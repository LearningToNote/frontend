'use strict'

angular.module('frontendApp')
  .constant 'USER_ROLES',
    all: '*',
    admin: 'admin',
    editor: 'editor',
    guest: 'guest'
