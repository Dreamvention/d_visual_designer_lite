<?php
//отображение блока в окне при выборе блока
$_['display']          = true;
//Категория(content, social, structure)
$_['category']         = 'content';
//отображать название блока
$_['display_title']    = false;
//Может содержать дочерние блоки
$_['child_blocks']     = true;
//Уровень доступный для добавления блока
$_['level_min']        = 4;
$_['level_max']        = 4;
//Расположение кнопок управления
$_['control_position'] = 'bottom';
//Отображение кнопок управления
$_['display_control']  = true;
//Кнопка перетаскивания
$_['button_drag']      = true;
//Кнопка редатирования
$_['button_edit']      = true;
//Кнопка копирования
$_['button_copy']      = true;
//Кнопка сворачивания
$_['button_collapse']  = true;
//Кнопка удаления
$_['button_remove']    = true;
//Свой шаблон
$_['custom_layout']    = 'column_inner';
//Доступен пре-рендер
$_['pre_render']       = true;
//Доступно сохранение в html
$_['save_html']        = true;
//Типы полей
$_['types']            = array(
    'size' => 'string',
    'offset' => 'string',
    'order' => 'string',
    'float' => 'boolean',
    'align' => 'string',
    'size_phone' => 'string',
    'size_tablet' => 'string',
    'offset_phone' => 'string',
    'offset_tablet' => 'string',
    'order_phone' => 'string',
    'order_tablet' => 'string'
);
//Настройки по умолчанию
$_['setting']          = array(
    'design_margin_bottom' => '',
    'size'   => 12,
    'offset' => '',
    'order' => '',
    'float'  => '',
    'align'  => 'center',
    'size_phone' => '',
    'size_tablet' => '',
    'offset_phone' => '',
    'offset_tablet' => '',
    'order_phone' => '',
    'order_tablet' => ''
);