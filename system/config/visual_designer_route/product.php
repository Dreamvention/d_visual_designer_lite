<?php
//Название конфига
$_['name']              = 'Product';
//Статус Frontend редатора
$_['frontend_status']   = '1';
//GET параметр route в админке
$_['backend_route']     = 'catalog/product|form';
//REGEX для GET параметров route в админке
$_['backend_route_regex'] = 'catalog/product/*';
//GET параметр route на Frontend
$_['frontend_route']    = 'product/product';
//GET параметр содержащий id страницы в админке
$_['backend_param']     = 'product_id';
//GET параметр содержащий id страницы на Frontend
$_['frontend_param']    = 'product_id';
//Путь для сохранения описания на Frontend
$_['edit_route']        = 'extension/visual_designer/visual_designer/designer|saveProduct';
//События
$_['events']            = array(
    'admin/view/catalog/product_form/after' => 'extension/visual_designer/event/visual_designer|view_product_after',
    'admin/model/catalog/product/addProduct/after' => 'extension/visual_designer/event/visual_designer|model_catalog_product_addProduct_after',
    'admin/model/catalog/product/addProduct/before' => 'extension/visual_designer/event/visual_designer|model_catalog_product_addProduct_before',
    'admin/model/catalog/product/editProduct/after' => 'extension/visual_designer/event/visual_designer|model_catalog_product_editProduct_after',
    'admin/model/catalog/product/editProduct/before' => 'extension/visual_designer/event/visual_designer|model_catalog_product_editProduct_before',
    'catalog/view/product/product/before' => 'extension/visual_designer/event/visual_designer|view_product_before'
);
