<?php
//Название конфига
$_['name']              = 'Information page';
//Статус Frontend редатора
$_['frontend_status']   = '1';
//GET параметр route в админке
$_['backend_route']     = 'catalog/information|form';
//REGEX для GET параметров route в админке
$_['backend_route_regex'] = 'catalog/information/*';
//GET параметр route на Frontend
$_['frontend_route']    = 'information/information';
//GET параметр содержащий id страницы в админке
$_['backend_param']     = 'information_id';
//GET параметр содержащий id страницы на Frontend
$_['frontend_param']    = 'information_id';
//Путь для сохранения описания на Frontend
$_['edit_route']        = 'extension/visual_designer/visual_designer/designer|saveInformation';
//События необходимые для работы данного route
$_['events']            = array(
    'admin/view/catalog/information_form/after' => 'extension/visual_designer/event/visual_designer|view_information_after',
    'admin/model/catalog/information/addInformation/after' => 'extension/visual_designer/event/visual_designer|model_catalog_infromation_addInformation_after',
    'admin/model/catalog/information/addInformation/before' => 'extension/visual_designer/event/visual_designer|model_catalog_infromation_addInformation_before',
    'admin/model/catalog/information/editInformation/after' => 'extension/visual_designer/event/visual_designer|model_catalog_infromation_editInformation_after',
    'admin/model/catalog/information/editInformation/before' => 'extension/visual_designer/event/visual_designer|model_catalog_infromation_editInformation_before',
    'catalog/view/information/information/before' => 'extension/visual_designer/event/visual_designer|view_information_before'
);
