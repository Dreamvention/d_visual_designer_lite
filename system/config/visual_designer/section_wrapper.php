<?php
//отображение блока в окне при выборе блока
$_['display']          = true;
//Порядковый номер
$_['sort_order']       = 0;
//Категория(content, social, structure)
$_['category']         = 'content';
//отображать название блока
$_['display_title']    = false;
//Может содержать дочерние блоки
$_['child_blocks']     = true;
//Обязательынй дочерний блок
$_['child']            = 'row';
//Уровень доступный для добавления блока
$_['level_min']        = 0;
$_['level_max']        = 0;
//Расположение кнопок управления
$_['control_position'] = 'advanced';
//Отображение кнопок управления
$_['display_control']  = true;
//Кнопка перетаскивания
$_['button_drag']      = true;
//Кнопка layout
$_['button_layout']    = false;
//Кнопка редатирования
$_['button_edit']      = true;
//Кнопка копирования
$_['button_copy']      = true ;
//Кнопка сворачивания
$_['button_collapse']  = true;
//Кнопка удаления
$_['button_remove']    = true;
//Доступен пре-рендер
$_['pre_render']       = true;
//Доступно сохранение в html
$_['save_html'] = true;
//Типы полей
$_['types'] = array(
    'row_stretch' => 'string',
    'background_video' => 'boolean',
    'link' => 'string',
    'container' => 'string'
);
//Настройки по умолчанию
$_['setting'] = array(
    'container' => 'fluid',
    'row_stretch' => '',
    'background_video' => 0,
    'link' => '',
    // 'link' => 'https://vimeo.com/51589652',
    // 'link' => 'https://www.youtube.com/watch?v=lMJXxhRFO1k',
);