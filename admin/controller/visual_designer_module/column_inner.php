<?php
/*
 *    location: admin/controller
 */
namespace Opencart\Admin\Controller\Extension\VisualDesigner\VisualDesignerModule;

class ColumnInner extends \Opencart\System\Engine\Controller
{
    private $codename = 'column_inner';
    private $route = 'extension/visual_designer/visual_designer_module/column_inner';

    public function __construct($registry)
    {
        parent::__construct($registry);

        $this->load->language($this->route);
    }

    public function options() {
        $data = array();

        $data['sizes'] = array(
            'auto' => 'auto',
            'fill' => 'fill',
            '1' => '1/12',
            '2' => '2/12',
            '3' => '3/12',
            '4' => '4/12',
            '5' => '5/12',
            '6' => '6/12',
            '7' => '7/12',
            '8' => '8/12',
            '9' => '9/12',
            '10' => '10/12',
            '11' => '11/12',
            '12' => '12/12',
        );


        $data['orders'] = array(
            'first' => 'first',
            'last' => 'last',
            '1' => '1/12',
            '2' => '2/12',
            '3' => '3/12',
            '4' => '4/12',
            '5' => '5/12',
            '6' => '6/12',
            '7' => '7/12',
            '8' => '8/12',
            '9' => '9/12',
            '10' => '10/12',
            '11' => '11/12',
            '12' => '12/12',
            );

        $data['floats'] = array(
            '' => $this->language->get('text_none'),
            'left' => $this->language->get('text_left'),
            'right' => $this->language->get('text_right')
            );
        $data['aligns'] = array(
           'left' => $this->language->get('text_left'),
           'center' => $this->language->get('text_center'),
           'right' => $this->language->get('text_right')
           );

        return $data;
    }

    public function local(){
        $data = array();

        $data['entry_size'] = $this->language->get('entry_size');
        $data['entry_float'] = $this->language->get('entry_float');
        $data['entry_align'] = $this->language->get('entry_align');
        $data['entry_offset'] = $this->language->get('entry_offset');
        $data['entry_order'] = $this->language->get('entry_order');
        $data['entry_adaptive_design'] = $this->language->get('entry_adaptive_design');

        $data['column_offset'] = $this->language->get('column_offset');
        $data['column_size'] = $this->language->get('column_size');
        $data['column_order'] = $this->language->get('column_order');
        $data['column_device'] = $this->language->get('column_device');

        $data['text_tablet'] = $this->language->get('text_tablet');
        $data['text_phone'] = $this->language->get('text_phone');
        $data['text_enabled'] = $this->language->get('text_enabled');
        $data['text_yes'] = $this->language->get('text_yes');
        $data['text_no'] = $this->language->get('text_no');
        $data['text_none'] = $this->language->get('text_none');

        $data['button_add'] = $this->language->get('button_add');
        return $data;
    }
}
