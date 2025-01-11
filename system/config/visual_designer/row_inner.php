<?php
//отображение блока в окне при выборе блока
$_['display']          = true;
//Порядковый номер
$_['sort_order']       = 1;
//Категория(content, social, structure)
$_['category']         = 'content';
//отображать название блока
$_['display_title']    = false;
//Может содержать дочерние блоки
$_['child_blocks']     = true;
//Обязательынй дочерний блок
$_['child']            = 'column_inner';
//Уровень доступный для добавления блока
$_['level_min']        = 3;
$_['level_max']        = 3;
//Возможность добавления на 1 уровень через строку
$_['helper_insert']    = false;
//Расположение кнопок управления
$_['control_position'] = 'advanced-bottom';
//Отображение кнопок управления
$_['display_control']  = true;
//Кнопка перетаскивания
$_['button_drag']      = true;
//Кнопка layout
$_['button_layout']    = true;
//Кнопка редатирования
$_['button_edit']      = true;
//Кнопка копирования
$_['button_copy']      = true ;
//Кнопка сворачивания
$_['button_collapse']  = true;
//Кнопка удаления
$_['button_remove']    = true;
//Свой шаблон
$_['custom_layout']    = 'row_inner';
//Доступен пре-рендер
$_['pre_render'] = true;
//Доступно сохранение в html
$_['save_html'] = true;
//Типы полей
$_['types']           = array(
    'background_video' => 'boolean',
    'link' => 'string',
    'align' => 'string',
    'container' => 'string'
);
//Настройки по умолчанию
$_['setting']          = array(
    'background_video' => 0,
    'container' => 'fluid',
    'link' => '',
    'align' => 'left',
    'align_items' => 'stretch'
);